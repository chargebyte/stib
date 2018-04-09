#!/usr/bin/env bash
#
# This generates an eMMC image based on a template image file for iMX6ULL based boards.
#
# Partitions are assumed to be as following and must match because of hard-coded
# offsets below.
#
#  1) RootFS 1     - start offset is fixed at 4 MB, size 1 GB
#  2) RootFS 2     - same size and content as RootFS 1
#  3) Extended Partition
#    5) Data       - fixed 1 GB
#    6) Customer 1 - fixed 128 MB
#    7) Customer 2 - fixed 128 MB
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
TEMPLATE=tools/emmc-template-armhf.image.gz

gzip -dc "$TEMPLATE" > "$OUTPUT"
ROOTFS1OFFSET="8192"
ROOTFS2OFFSET="2105344"

dd bs=512 if="$ROOTFS" of="$OUTPUT" seek="$ROOTFS1OFFSET" conv=notrunc
dd bs=512 if="$ROOTFS" of="$OUTPUT" seek="$ROOTFS2OFFSET" conv=notrunc
dd bs=512 if="$BOOTSTREAM" of="$OUTPUT" seek=2 conv=notrunc
