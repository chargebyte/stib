#!/usr/bin/env bash
#
# This generates an eMMC image with three partitions for iMX6 based boards.
#  1) RootFS 1 - start offset is fixed at 4 MB, size as given per cmdline argument
#  2) RootFS 2 - same size and content as RootFS 1
#  3) Data     - fixed 1 GB as placeholder remaining space, should be dynamically
#                extended at first boot
#
# Bootstream is placed at 0x400 as required by iMX6. A secondary bootstream
# is not installed.
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

head=255
sect=63

[ -x `which ptgen` ] || {
    echo "ERROR: ptgen not found"
    exit 1
}

# we assume that there is still enough room for a 1G data partition
set `ptgen -o $OUTPUT -h $head -s $sect -a 0 -l 4096 -p ${ROOTFSSIZE} -p ${ROOTFSSIZE} -p 1G`

ROOTFS1OFFSET="$(($1 / 512))"
ROOTFS1SIZE="$(($2 / 512))"
ROOTFS2OFFSET="$(($3 / 512))"
ROOTFS2SIZE="$(($4 / 512))"
DATAOFFSET="$(($5 / 512))"
DATASIZE="$(($6 / 512))"

dd bs=512 if="$ROOTFS" of="$OUTPUT" seek="$ROOTFS1OFFSET" conv=notrunc
dd bs=512 if="$ROOTFS" of="$OUTPUT" seek="$ROOTFS2OFFSET" conv=notrunc
dd bs=512 if="$BOOTSTREAM" of="$OUTPUT" seek=2 conv=notrunc
