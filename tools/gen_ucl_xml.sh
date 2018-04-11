#!/bin/bash
#
# Script to generate Mfgtool ucl.xml
#

if [ -z "$1" ]; then
	echo "SYNTAX: $0 <IMAGEDIR>"
	exit 1
fi

IMAGEDIR="$1"
PREFIX="emmc.img"
EXTBASE=16

if [ ! -f "$IMAGEDIR/$PREFIX.01" ]; then
	echo "ERROR: No image file found"
	exit 1
fi

FILESIZE=`stat --printf="%s" "$IMAGEDIR"/$PREFIX.01`
BLOCKSIZE=$((4 * 1024))
TOTALCOUNT=`ls -1 "$IMAGEDIR"/$PREFIX* | sort -r | head -n 1`
TOTALCOUNT="${TOTALCOUNT##*.}"
[ "$EXTBASE" = 16 ] && TOTALCOUNT=$(printf '%d' "0x$TOTALCOUNT")

cat <<EOL
<UCL>
  <CFG>
    <STATE name="Recovery" dev="IMX28" />
    <STATE name="Updater"  dev="Updater" />

    <DEV name="IMX28"   vid="15A2" pid="004F" />
    <DEV name="Updater" vid="066F" pid="37FF" />
  </CFG>

  <LIST name="Linux" desc="Burn Linux Firmware to eMMC">
    <CMD type="boot" body="Recovery" file="updater_ivt.sb">Booting Update Firmware</CMD>
    <CMD type="find" body="Updater" timeout="180"/>

    <CMD type="push" body="mknod block,mmcblk0,/dev/mmcblk0,block">Creating Block Device for eMMC</CMD>
EOL

for FILENAME in `cd "$IMAGEDIR"; ls -1 $PREFIX* | sort -r`; do
	BASENAME="${FILENAME##*/}"
	WOSUFFIX="$BASENAME"
	# strip off suffix if given
	[ -n "$SUFFIX" ] && WOSUFFIX="${BASENAME%%$SUFFIX}"
	# assume the first image starts with 01
	EXTENSION="${WOSUFFIX##*.}"
	# we need to take care of the leading zero
	SEEK=$(($EXTBASE#$EXTENSION * $FILESIZE / $BLOCKSIZE - $FILESIZE / $BLOCKSIZE))

	if [ "$EXTBASE" = 16 ]; then
		PROGRESS=$(printf '%d' "0x$EXTENSION")
	else
		PROGRESS="$EXTENSION"
	fi

	cat <<-EOL
	    <CMD type="push" body="pipe ${UNCOMPRESS}dd of=/dev/mmcblk0 seek=$SEEK bs=$BLOCKSIZE" file="files/$BASENAME">Sending $PROGRESS/$TOTALCOUNT</CMD>
	    <CMD type="push" body="frf">Writing $PROGRESS/$TOTALCOUNT</CMD>
	EOL
done

cat <<EOL
    <CMD type="push" body="$ echo Update Complete!">Done</CMD>
  </LIST>
</UCL>
EOL
