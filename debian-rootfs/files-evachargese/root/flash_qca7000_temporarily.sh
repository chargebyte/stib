#!/bin/sh

BL=/root/NvmSoftloader-QCA7000-v1.1.0-01-FINAL.nvm
PIB=/root/QCA7000-SpiSlave-HomePlugGP_CE-ClassB-minus67db.pib
FW=/root/MAC-QCA7000-v1.1.0-01-X-FINAL.nvm

if [ "$1" = "-f" ]; then
	/usr/local/bin/plcwait -R -i qca0
	sleep 3 
fi

/usr/local/bin/plcwait -s -i qca0

/usr/local/bin/plctool -r -i qca0 | /bin/grep -q -e 'MAC-QCA7000' && exit 0

if [ ! -f "$BL" ]; then
	echo "No bootloader image found"
	exit 1
fi

if [ ! -f "$PIB" ]; then
	echo "No PIB file found"
	exit 1
fi

if [ ! -f "$FW" ]; then
	echo "No firmware image found"
	exit
fi

/usr/local/bin/plcboot -N "$FW" -P "$PIB" -S "$BL" -i qca0

