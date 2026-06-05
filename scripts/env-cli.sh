#!/usr/bin/env bash
set -euo pipefail

# Préfixe depends (on n’a construit que BDB via "make -C depends NO_QT=1 bdb")
TRIPLET="$(uname -m)-pc-linux-gnu"
PREFIX="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)/depends/$TRIPLET"

export PATH="$PREFIX/native/bin:$PATH"
export CPPFLAGS="-I$PREFIX/include${CPPFLAGS:+ $CPPFLAGS}"
export LDFLAGS="-L$PREFIX/lib${LDFLAGS:+ $LDFLAGS}"
export PKG_CONFIG_PATH="$PREFIX/lib/pkgconfig:$PREFIX/share/pkgconfig${PKG_CONFIG_PATH:+:$PKG_CONFIG_PATH}"

# Force l’édition de liens avec Berkeley DB 4.8 produit par depends
export LIBS="-ldb_cxx-4.8 -ldb-4.8${LIBS:+ $LIBS}"
