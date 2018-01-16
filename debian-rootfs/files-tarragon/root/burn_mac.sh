#!/bin/bash
#
#  Copyright (c) 2018 I2SE GmbH
#

verify=`cat /sys/fsl_otp/HW_OCOTP_MAC0 2>/dev/null`

if [ $# -lt 2 ]; then
	cat >&2 <<EOU
Usage: $0 MAC1 MAC2
  MAC1   MAC address 1
  MAC2   MAC address 2
EOU
	exit 1
fi

mac1="$1"
mac2="$2"

if [[ "$verify" == "" ]]; then
	echo "FSL OTP not found"
	exit 1
fi

if [[ "$verify" != "0x0" ]]; then
	echo "MAC address already burned"
	exit 1
fi

if [[ ! "$mac1" =~ ^([0-9A-Fa-f]{2}[:-]){5}([0-9A-Fa-f]{2})$ ]]; then
	echo "Invalid MAC1"
	exit 1
fi

if [[ ! "$mac2" =~ ^([0-9A-Fa-f]{2}[:-]){5}([0-9A-Fa-f]{2})$ ]]; then
	echo "Invalid MAC2"
	exit 1
fi

reg0="0x${mac1:6:2}${mac1:9:2}${mac1:12:2}${mac1:15:2}"
reg1="0x${mac2:12:2}${mac2:15:2}${mac1:0:2}${mac1:3:2}"
reg2="0x${mac2:0:2}${mac2:3:2}${mac2:6:2}${mac2:9:2}"

echo "HW_OCOTP_MAC0: $reg0"
echo $reg0 > /sys/fsl_otp/HW_OCOTP_MAC0
sleep 1
echo "HW_OCOTP_MAC1: $reg1"
echo $reg0 > /sys/fsl_otp/HW_OCOTP_MAC1
sleep 1
echo "HW_OCOTP_MAC2: $reg2"
echo $reg0 > /sys/fsl_otp/HW_OCOTP_MAC2
