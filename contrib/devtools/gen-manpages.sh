#!/bin/sh

TOPDIR=${TOPDIR:-$(git rev-parse --show-toplevel)}
SRCDIR=${SRCDIR:-$TOPDIR/src}
MANDIR=${MANDIR:-$TOPDIR/doc/man}

GAELIUMD=${GAELIUMD:-$SRCDIR/gaeliumd}
GAELIUMCLI=${GAELIUMCLI:-$SRCDIR/gaelium-cli}
GAELIUMTX=${GAELIUMTX:-$SRCDIR/gaelium-tx}
GAELIUMQT=${GAELIUMQT:-$SRCDIR/qt/gaelium-qt}

[ ! -x $GAELIUMD ] && echo "$GAELIUMD not found or not executable." && exit 1

# The autodetected version git tag can screw up manpage output a little bit
GAELVER=($($GAELIUMCLI --version | head -n1 | awk -F'[ -]' '{ print $6, $7 }'))

# Create a footer file with copyright content.
# This gets autodetected fine for gaeliumd if --version-string is not set,
# but has different outcomes for gaelium-qt and gaelium-cli.
echo "[COPYRIGHT]" > footer.h2m
$GAELIUMD --version | sed -n '1!p' >> footer.h2m

for cmd in $GAELIUMD $GAELIUMCLI $GAELIUMTX $GAELIUMQT; do
  cmdname="${cmd##*/}"
  help2man -N --version-string=${GAELVER[0]} --include=footer.h2m -o ${MANDIR}/${cmdname}.1 ${cmd}
  sed -i "s/\\\-${GAELVER[1]}//g" ${MANDIR}/${cmdname}.1
done

rm -f footer.h2m
