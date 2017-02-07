#!/bin/bash
#
#  Copyright (c) 2013 I2SE GmbH
#

if [ $# -lt 1 ]; then
	cat >&2 <<EOU
Usage: $0 OTPVALUE [OUI]
  OTPVALUE        hex value of /sys/fsl_otp register
  OUI             separated with colons (8 chars)
EOU
	exit 1
fi

val="$1"
val=`printf "%08X" $((val))`
oui="00:00:00"

if [ "${#val}" != "8" ]; then
	exit 1
fi

if [ "${#2}" == "8" ]; then
	oui="$2"
fi

mac="${oui}:${val:2:2}:${val:4:2}:${val:6:2}"

echo $mac

