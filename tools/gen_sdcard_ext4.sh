#!/usr/bin/env bash
#
# Copyright (C) 2015 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

set -x
[ $# -eq 4 ] || {
    echo "SYNTAX: $0 <file> <bootstream image> <rootfs image> <rootfs size>"
    exit 1
}

OUTPUT="$1"
BOOTSTREAM="$2"
ROOTFS="$3"
ROOTFSSIZE="$4"

head=4
sect=63

[ -x `which ptgen` ] || {
    echo "ERROR: ptgen not found"
    exit 1
}

# set the Boot stream partition size to 8M
set `ptgen -o $OUTPUT -h $head -s $sect -l 1024 -t 53 -p 8M -t 83 -p ${ROOTFSSIZE}M`

ROOTFS1OFFSET="$(($3 / 512))"
ROOTFS1SIZE="$(($4 / 512))"

dd bs=512 if="$ROOTFS" of="$OUTPUT" seek="$ROOTFS1OFFSET" conv=notrunc
sdimage -d "$OUTPUT" -f "$BOOTSTREAM"
