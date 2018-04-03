#!/usr/bin/env bash
#
# This generates an eMMC image with four partitions for iMX28 based boards.
#  1) Boot Stream
#  2) RootFS 1 - start offset is fixed at 4 MB, size as given per cmdline argument
#  3) RootFS 2 - same size and content as RootFS 1
#  4) Data     - fixed 1 GB as placeholder remaining space, should be dynamically
#                extended at first boot
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
set `ptgen -o $OUTPUT -h $head -s $sect -a 0 -l 4096 -t 53 -p 2M -t 83 -p ${ROOTFSSIZE}M -p ${ROOTFSSIZE}M -p 1G`

ROOTFS1OFFSET="$(($3 / 512))"
ROOTFS1SIZE="$(($4 / 512))"
ROOTFS2OFFSET="$(($5 / 512))"
ROOTFS2SIZE="$(($6 / 512))"
DATAOFFSET="$(($7 / 512))"
DATASIZE="$(($8 / 512))"

dd bs=512 if="$ROOTFS" of="$OUTPUT" seek="$ROOTFS1OFFSET" conv=notrunc
dd bs=512 if="$ROOTFS" of="$OUTPUT" seek="$ROOTFS2OFFSET" conv=notrunc
sdimage -d "$OUTPUT" -f "$BOOTSTREAM"
