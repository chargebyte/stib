#!/bin/bash

BAUDRATE=57600

function usage {
	echo "Usage: sh ./update_kl02.sh <device> <file>"
	echo "  device is the serial device where the microcontroller to update is connected"
	echo "  file is the srec file for update"
}

if [ $# -ne 2 ]; then
	usage
	exit 1
fi

if [ ! -e "$1" ]; then
	echo "Serial device doesn't exist"
	exit 2
fi

if [ ! -f "$2" ]; then
	echo "srec file doesn't exist"
	exit 3
fi

# Reset the controller...
python uss.py -p"$1" -ri

# Execute update
hc08sprg "$1":D $BAUDRATE "$2"

