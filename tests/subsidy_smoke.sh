#!/usr/bin/env bash
set -euo pipefail

GAE=./src/gaeliumd
CLI=./src/gaelium-cli
DAT="$HOME/.gaelium-subsidy-check"
CONF="$DAT/gaelium.conf"

rpc(){ "$CLI" -datadir="$DAT" -regtest "$@"; }

# Setup regtest minimal (propre)
pkill -x gaeliumd 2>/dev/null || true
rm -rf "$DAT"; mkdir -p "$DAT"
cat > "$CONF" <<CFG
server=1
daemon=1
regtest=1
rpcuser=gael
rpcpassword=gael-pass-test
CFG

# Démarre et attend le RPC
$GAE -datadir="$DAT" -regtest >/dev/null 2>&1 || true
rpc -rpcwait getblockchaininfo >/dev/null

# Essaie juste d'obtenir une adresse (sans createwallet)
if ! ADDR=$(rpc getnewaddress 2>/dev/null); then
  echo "ERREUR: getnewaddress indisponible (wallet non chargé ?)."
  echo "Regarde $DAT/regtest/debug.log"
  exit 1
fi

# Mine 2 blocs (hauteurs 1 et 2)
rpc generatetoaddress 2 "$ADDR" >/dev/null

# Somme des outputs de la coinbase (bloc h)
subsidy_of(){
  local H="$1"
  local BH
  BH=$(rpc getblockhash "$H")
  rpc getblock "$BH" 2 | awk '
    BEGIN{idx=-1; in_vout=0; sum=0}
    /"tx":[[:space:]]*\[/ { idx=-1; next }
    /{\s*"txid"/         { idx++; next }
    idx==0 && /"vout":[[:space:]]*\[/ { in_vout=1; next }
    in_vout && /"value"[[:space:]]*:/ { gsub(/,/, "", $2); sum+=$2 }
    in_vout && /\]/ { printf "%.8f\n", sum; exit }
  '
}

echo "height | expected(GAEL) | observed(GAEL)  | OK"
echo "------+-----------------+-----------------+----"
obs1=$(subsidy_of 1); exp1=10003000
printf "1      | %-15s | %-15s | %s\n" "$exp1" "$obs1" "$( [ "$obs1" = "10003000.00000000" ] && echo OK || echo NO )"
obs2=$(subsidy_of 2); exp2=3000
printf "2      | %-15s | %-15s | %s\n" "$exp2" "$obs2" "$( [ "$obs2" = "3000.00000000" ] && echo OK || echo NO )"
