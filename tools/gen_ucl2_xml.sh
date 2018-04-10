#!/bin/bash
#
# Script to generate a ucl2.xml for MfgTool2 file
#

if [ -z "$1" -o -z "$2" ]; then
	echo "SYNTAX: $0 <IMAGEDIR> <DTB FILE>"
	exit 1
fi

IMAGEDIR="$1"
DTB="$2"
PREFIX="emmc.img"

if [ ! -f "$IMAGEDIR/$PREFIX.01" ]; then
	echo "ERROR: No image file found"
	exit 1
fi



cat <<EOL
<UCL>
  <CFG>
    <STATE name="BootStrap" dev="MX6ULL" vid="15A2" pid="0080" />
    <STATE name="Updater"   dev="MSC"    vid="066F" pid="37FF" />
  </CFG>

  <LIST name="eMMC" desc="Burn Linux Firmware to eMMC">
    <CMD state="BootStrap" type="boot" body="BootStrap" file ="firmware/u-boot.imx">Loading U-Boot</CMD>
    <CMD state="BootStrap" type="load" file="firmware/zImage_mfgtool" address="0x80800000"
        loadSection="OTH" setSection="OTH" HasFlashHeader="FALSE">Loading Kernel</CMD>
    <CMD state="BootStrap" type="load" file="firmware/fsl-image-mfgtool-initramfs-imx_mfgtools.cpio.gz.u-boot" address="0x83800000"
        loadSection="OTH" setSection="OTH" HasFlashHeader="FALSE">Loading Initramfs</CMD>
    <CMD state="BootStrap" type="load" file="firmware/$DTB" address="0x83000000"
        loadSection="OTH" setSection="OTH" HasFlashHeader="FALSE">Loading Device Tree Binary</CMD>
    <CMD state="BootStrap" type="jump">Starting Linux</CMD>

    <!--
    <CMD state="Updater" type="push" body="$ echo none  > /sys/class/leds/*:red:*/trigger">Switch LED</CMD>
    <CMD state="Updater" type="push" body="$ echo 0     > /sys/class/leds/*:red:*/brightness">Switch LED</CMD>

    <CMD state="Updater" type="push" body="$ echo timer > /sys/class/leds/*:yellow:*/trigger">Switch LED</CMD>
    <CMD state="Updater" type="push" body="$ echo 1     > /sys/class/leds/*:yellow:*/brightness">Switch LED</CMD>

    <CMD state="Updater" type="push" body="$ echo none  > /sys/class/leds/*:green:*/trigger">Switch LED</CMD>
    <CMD state="Updater" type="push" body="$ echo 0     > /sys/class/leds/*:green:*/brightness">Switch LED</CMD>
    -->

    <CMD state="Updater" type="push" body="mknod block,mmcblk1,/dev/mmcblk1,block">Creating Block Device for eMMC</CMD>

EOL

FILESIZE=`stat --printf="%s" "$IMAGEDIR/$PREFIX.01"`
BLOCKSIZE=$((4 * 1024 * 1024))
TOTALCOUNT=`ls -1 "$IMAGEDIR"/$PREFIX* | sort -r | head -n 1`
TOTALCOUNT="${TOTALCOUNT##*.}"

for FILENAME in `cd "$IMAGEDIR"; ls -1 $PREFIX* | sort -r`; do
	BASENAME=`basename "${FILENAME}"`
	# assume the first image starts with 01
	EXTENSION="${BASENAME##*.}"
	# we need to take care of the leading zero
	SEEK=$((10#$EXTENSION * $FILESIZE / $BLOCKSIZE - $FILESIZE / $BLOCKSIZE))

	cat <<-EOL
	    <CMD state="Updater" type="push" body="pipe dd of=/dev/mmcblk1 seek=$SEEK bs=$BLOCKSIZE" file="files/$BASENAME">Sending $EXTENSION/$TOTALCOUNT</CMD>
	    <CMD state="Updater" type="push" body="frf">Writing $EXTENSION/$TOTALCOUNT</CMD>
	EOL
done

cat <<EOL

    <!--
    <CMD state="Updater" type="push" body="$ echo none  > /sys/class/leds/*:red:*/trigger">Switch LED</CMD>
    <CMD state="Updater" type="push" body="$ echo 0     > /sys/class/leds/*:red:*/brightness">Switch LED</CMD>

    <CMD state="Updater" type="push" body="$ echo none  > /sys/class/leds/*:yellow:*/trigger">Switch LED</CMD>
    <CMD state="Updater" type="push" body="$ echo 0     > /sys/class/leds/*:yellow:*/brightness">Switch LED</CMD>

    <CMD state="Updater" type="push" body="$ echo none  > /sys/class/leds/*:green:*/trigger">Switch LED</CMD>
    <CMD state="Updater" type="push" body="$ echo 1     > /sys/class/leds/*:green:*/brightness">Switch LED</CMD>
    -->

    <CMD state="Updater" type="push" body="$ echo Update complete!">Done</CMD>
  </LIST>
</UCL>
EOL
