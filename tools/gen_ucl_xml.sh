#!/bin/bash
#
# Script to generate Mfgtool ucl.xml 
#

if [ "$1" == "" ]; then
	echo "SYNTAX: $0 <IMAGEDIR>"
	exit 1
fi

IMAGEDIR="$1"

# Make sure this is in sync with profile.ini
SECTION="Linux"

if [ ! -f $IMAGEDIR/emmc.img.01 ]; then
	echo "ERROR: No image file found"
	exit 1
fi

cat <<EOL
<UCL>
  <CFG>
    <STATE name="Recovery" dev="IMX28"/>
    <STATE name="Updater" dev="Updater"/>
    <DEV name="IMX28" vid="15A2" pid="004F"/>
    <DEV name="Updater" vid="066F" pid="37FF"/>
  </CFG>

  <LIST name="$SECTION" desc="Reflash Linux to whole eMMC">
    <CMD type="boot" body="Recovery" file="updater_ivt.sb" >Booting Update Firmware</CMD>
    <CMD type="find" body="Updater" timeout="180"/>

    <CMD type="push" body="mknod block,mmcblk0,/dev/mmcblk0,block"/>
EOL

PREFIX="emmc.img"
FILESIZE=`stat --printf="%s" $IMAGEDIR/$PREFIX.01`

for FILENAME in `ls -1 $IMAGEDIR/$PREFIX* | sort -r`; do
	BASENAME="${FILENAME##*/}"
	# assume the first image starts with 01	
	EXTENSION="${BASENAME##*.}"
	# we need to take care of the leading zero
	SEEK=$((10#$EXTENSION * $FILESIZE / 1024 - $FILESIZE / 1024))
	cat <<EOL
    <CMD type="push" body="pipe dd of=/dev/mmcblk0 seek=$SEEK bs=1k" file="files/$BASENAME">Sending $BASENAME</CMD>
    <CMD type="push" body="frf">Writing $BASENAME</CMD>
EOL
done

cat <<EOL
    <CMD type="push" body="$ echo Update Complete!">Done</CMD>
  </LIST>
</UCL>
EOL
