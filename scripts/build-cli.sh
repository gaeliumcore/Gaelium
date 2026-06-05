#!/usr/bin/env bash
set -euo pipefail

# Charger l’environnement figé (BDB 4.8, chemins, etc.)
source "$(dirname "$0")/env-cli.sh"

# Configure + build (wallet CLI activé, pas de GUI)
./autogen.sh
./configure \
  --without-gui \
  --enable-wallet \
  --disable-tests \
  --disable-bench \
  --with-miniupnpc=no

# Construire uniquement les binaires CLI
make -C src -j"$(nproc)" gaeliumd gaelium-cli
