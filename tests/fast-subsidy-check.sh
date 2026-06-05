#!/usr/bin/env bash
set -euo pipefail

GAE=./src/gaeliumd
CLI=./src/gaelium-cli
DAT="$HOME/.gaelium-subsidy-check"
CONF="$DAT/gaelium.conf"

rpc(){ "$CLI" -datadir="$DAT" -regtest "$@"; }

# ---------- setup basique ----------
pkill -x gaeliumd 2>/dev/null || true
mkdir -p "$DAT"
cat > "$CONF" <<CFG
server=1
daemon=1
regtest=1
rpcuser=gael
rpcpassword=gael-pass-test
CFG

$GAE -datadir="$DAT" -regtest >/dev/null 2>&1 || true
rpc -rpcwait getblockcount >/dev/null

# Wallet si absent
rpc getwalletinfo >/dev/null 2>&1 || rpc createwallet "" >/dev/null

# ---------- helpers ----------
subsidy_expected() {
  local h="$1"
  if (( h >= 2627689 && h <= 2627999 )); then echo 0; return; fi
  if (( h == 2628000 )); then echo 19; return; fi
  if (( h <= 0 )); then echo 0; return; fi
  if (( h == 1 )); then echo $((10000000 + 3000)); return; fi
  if (( h >= 2628001 )); then echo 3; return; fi
  if (( h >= 1800000 )); then echo 29; return; fi
  if (( h >= 900000  )); then echo 90; return; fi
  if (( h >= 600000  )); then echo 175; return; fi
  if (( h >= 450000  )); then echo 350; return; fi
  if (( h >= 300000  )); then echo 700; return; fi
  if (( h >= 150000  )); then echo 1500; return; fi
  echo 3000
}

# Somme des vout.value de la coinbase (robuste via Python/JSON)
subsidy_of() {
  local h="$1"
  local bh
  bh=$(rpc getblockhash "$h") || return 1
  rpc getblock "$bh" 2 | python3 - "$h" <<'PY'
import sys, json
b = json.load(sys.stdin)
tx0 = b["tx"][0]  # coinbase
total = sum(v.get("value", 0.0) for v in tx0.get("vout", []))
print(f"{total:.8f}")
PY
}

# ---------- vérif simple (pas de minage) ----------
printf "%-8s | %-16s | %-16s | %-4s\n" "height" "expected(GAEL)" "observed(GAEL)" "OK?"
printf "%-8s-+-%-16s-+-%-16s-+-%-4s\n" "--------" "----------------" "----------------" "----"

for h in 1 2; do
  exp=$(printf '%.8f' "$(subsidy_expected "$h")")
  # Miner juste si nécessaire pour 1 et 2
  bc=$(rpc getblockcount)
  if (( bc < h )); then
    addr=$(rpc getnewaddress)
    rpc generatetoaddress $((h-bc)) "$addr" >/dev/null
  fi
  obs=$(subsidy_of "$h" || echo "NA")
  ok="NO"
  [[ "$obs" == "$exp" ]] && ok="OK"
  printf "%-8s | %-16s | %-16s | %-4s\n" "$h" "$exp" "$obs" "$ok"
done

# ---------- mode “milestones” optionnel ----------
# Lance avec:  RUN_MILESTONES=1 bash tests/fast-subsidy-check.sh
if [[ "${RUN_MILESTONES:-0}" == "1" ]]; then
  heights=(150000 300000 450000 600000 900000 1800000 2627689 2627999 2628000 2628001)

  # minage accéléré (mock time) – n’utilise que si tu veux explorer loin
  addr=$(rpc getnewaddress)
  fast_mine_to () {
    local target=$1
    while :; do
      local bc=$(rpc getblockcount)
      (( bc >= target )) && break
      # avance le temps mock et mine en lots
      local tiph=$(rpc getblockhash "$bc")
      local tipt=$(rpc getblock "$tiph" 1 | python3 - <<'PY'
import sys, json; print(json.load(sys.stdin)["time"])
PY
)
      rpc setmocktime $((tipt + 1))
      local more=$(( target - bc ))
      (( more > 100 )) && more=100
      rpc generatetoaddress "$more" "$addr" >/dev/null
    done
  }

  for h in "${heights[@]}"; do
    exp=$(printf '%.8f' "$(subsidy_expected "$h")")
    fast_mine_to "$h"
    obs=$(subsidy_of "$h" || echo "NA")
    ok="NO"
    [[ "$obs" == "$exp" ]] && ok="OK"
    printf "%-8s | %-16s | %-16s | %-4s\n" "$h" "$exp" "$obs" "$ok"
  done
  rpc setmocktime 0 >/dev/null 2>&1 || true
fi
