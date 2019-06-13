#!/bin/sh

# obtain serial number from baptism data, otherwise look in normal U-Boot env
RAUC_SYSTEM_SERIAL=$(fw_printenv -n serial# -c /etc/baptism-data.config 2>/dev/null)
if [ -z "$RAUC_SYSTEM_SERIAL" ]; then
	RAUC_SYSTEM_SERIAL=$(fw_printenv -n serial# 2>/dev/null)
fi

# pass serial to rauc if available
if [ -n "$RAUC_SYSTEM_SERIAL" ]; then
	echo RAUC_SYSTEM_SERIAL=$RAUC_SYSTEM_SERIAL
fi
