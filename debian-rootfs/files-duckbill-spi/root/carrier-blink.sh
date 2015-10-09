#!/bin/sh
#
#  Copyright (c) 2014 I2SE GmbH
#

if [ $# -lt 2 ]; then
	cat >&2 <<EOU
Usage: $0 INTERFACE LED
  INTERFACE       network interface
  LED             led name
EOU
	exit 1
fi

iface="/sys/class/net/$1"
led="/sys/class/leds/$2"

blink=1

if [ ! -d "$led" ]; then
	echo "led doesn't exists"
	exit 2
fi

if [ ! -d "$iface" ]; then
	echo "iface doesn't exists"
	exit 3
fi

while [ 1 ]; do
	carrier=`head -1 $iface/carrier`
	if [ "$carrier" = "1" ]; then
		if [ $blink -eq 1 ]; then
			echo "200" > "$led/brightness"
		else
			echo "0" > "$led/brightness"
		fi
		blink=$((1-$blink))
	else
		echo "0" > "$led/brightness"
		blink=1
	fi
	sleep 0.5
done
