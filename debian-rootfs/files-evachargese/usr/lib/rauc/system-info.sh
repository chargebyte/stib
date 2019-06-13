#!/bin/sh

RAUC_SYSTEM_SERIAL=$(fw_printenv -n serial# 2>/dev/null)
if [ -n "$RAUC_SYSTEM_SERIAL" ]; then
	echo RAUC_SYSTEM_SERIAL=$RAUC_SYSTEM_SERIAL
fi
