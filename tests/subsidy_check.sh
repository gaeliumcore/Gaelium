#!/usr/bin/env bash
set -euo pipefail

GAE=./src/gaeliumd
CLI=./src/gaelium-cli
DAT="$HOME/.gaelium-subsidy-check"
CONF="$DAT/gaelium.conf"

# ---------- helpers ----------
rpc() { "$CLI" -datadir="$DAT" -regtest "$@"; }
have_rpc_getblocksubsidy() { rpc help 2>/dev/null | grep -qw getblocksubsidy; }

# valeur attendue selon NOTRE barème (en GAEL entiers)
subsidy_expected() {
  local h="$1"
  # Clamp DEV
  if (( h >= 2627689 && h <= 2627999 )); then echo 0; return; fi
  if (( h == 2628000 )); then echo 19; return; fi
  # Cas généraux
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

# somme des vout.value de la coinbase du bloc (format getblock 2)
subsidy_measured_block() {
  local h="$1"
  local bh
  bh=$(rpc getblockhash "$h")
  rpc getblock "$bh" 2 | awk '
    BEGIN{in_tx=0; txi=-1; in_vout=0; sum=0}
    /"tx":[[:space:]]*\[/ { in_tx=1; txi=-1; next }
    in_tx && /{\s*"txid"/ { txi++ }
    in_tx && txi==0 && /"vout":[[:space:]]*\[/ { in_vout=1; next }
    in_vout && /"value"[[:space:]]*:/ { gsub(/,/, "", $2); sum+=$2+0 }
    in_vout && /\]/ { printf "%.8f\n", sum; exit }
  '
}

# ---------- setup regtest minimal ----------
pkill -x gaeliumd 2>/dev/null || true
rm -rf "$DAT"
mkdir -p "$DAT"
cat > "$CONF" <<CFG
server=1
daemon=1
regtest=1
rpcuser=gael
rpcpassword=gael-pass-test
CFG

$GAE -datadir="$DAT" -regtest >/dev/null 2>&1 || true
$CLI -datadir="$DAT" -regtest -rpcwait getblockchaininfo >/dev/null

# wallet (si absent)
if ! rpc getwalletinfo >/dev/null 2>&1; then
  rpc createwallet "" >/dev/null
  rpc -rpcwait getwalletinfo >/dev/null
fi

# miner 2 blocs (h=1 et h=2)
ADDR=$(rpc getnewaddress)
rpc generatetoaddress 2 "$ADDR" >/dev/null

# ---------- table de vérif ----------
HEIGHTS=(1 2 150000 300000 450000 600000 900000 1800000 2627689 2627999 2628000 2628001)

printf "%-9s | %-14s | %-14s | %-8s\n" "height" "expected(GAEL)" "observed(GAEL)" "OK?"
printf -- "---------+----------------+----------------+--------\n"

fail=0
if have_rpc_getblocksubsidy; then
  for h in "${HEIGHTS[@]}"; do
    exp=$(subsidy_expected "$h")
    obs=$(rpc getblocksubsidy "$h" 2>/dev/null || echo "NA")
    ok="YES"
    [[ "$obs" == "NA" || "$obs" != "$exp" ]] && ok="NO" && fail=1
    printf "%-9s | %-14s | %-14s | %-8s\n" "$h" "$exp" "$obs" "$ok"
  done
else
  for h in "${HEIGHTS[@]}"; do
    exp=$(subsidy_expected "$h")
    if (( h==1 || h==2 )); then
      obs=$(subsidy_measured_block "$h")
      exp_fmt=$(awk -v e="$exp" 'BEGIN{printf "%.8f", e+0}')
      [[ "$obs" == "$exp_fmt" ]] && ok="YES" || { ok="NO"; fail=1; }
      printf "%-9s | %-14s | %-14s | %-8s\n" "$h" "$exp" "$obs" "$ok"
    else
      printf "%-9s | %-14s | %-14s | %-8s\n" "$h" "$exp" "NA" "NA"
    fi
  done
fi

if (( fail )); then
  echo -e "\nAu moins une divergence détectée. Regarde $DAT/regtest/debug.log."
  exit 1
else
  echo -e "\nOK: subsides conformes aux attentes sur les vérifs possibles."
fi
