#!/bin/bash
#
#  Copyright (c) 2018 I2SE GmbH
#

verify=`cat /sys/fsl_otp/HW_OCOTP_MAC0 2>/dev/null`

if [ $# -lt 2 ]; then
	cat >&2 <<EOU
Usage: $0 MAC1 MAC2 [MAC3]
  MAC1   Ethernet MAC address
  MAC2   QCA7500 MAC address
  MAC3   QCA7000 MAC address (must have an I2SE OUI)
EOU
	exit 1
fi

mac1=`echo $1 | tr '[:upper:]' '[:lower:]'`
mac2=`echo $2 | tr '[:upper:]' '[:lower:]'`
mac3=`echo $3 | tr '[:upper:]' '[:lower:]'`

if [ "$verify" == "" ]; then
	echo "FSL OTP not found"
	exit 1
fi

if [ "$verify" != "0x0" ]; then
	echo "Ethernet MAC address already burned"
	exit 1
fi

if [[ ! "$mac1" =~ ^([0-9a-f]{2}[:]){5}([0-9a-f]{2})$ ]]; then
	echo "Invalid MAC1"
	exit 1
fi

if [[ ! "$mac2" =~ ^([0-9a-f]{2}[:]){5}([0-9a-f]{2})$ ]]; then
	echo "Invalid MAC2"
	exit 1
fi

reg0="0x${mac1:6:2}${mac1:9:2}${mac1:12:2}${mac1:15:2}"
reg1="0x${mac2:12:2}${mac2:15:2}${mac1:0:2}${mac1:3:2}"
reg2="0x${mac2:0:2}${mac2:3:2}${mac2:6:2}${mac2:9:2}"
reg3=""

if [ $# -gt 2 ]; then
	# Currently this script and the kernel only support I2SE OUI for QCA7000
	if [[ ! "$mac3" =~ ^00[:]01[:]87([:]([0-9a-f]){2}){3}$ ]]; then
		echo "Invalid MAC3"
		exit 1
	fi

	verify=`cat /sys/fsl_otp/HW_OCOTP_GP30 2>/dev/null`

	if [ "$verify" == "0x0" ]; then
		reg3="0x${mac3:6:2}${mac3:9:2}${mac3:12:2}${mac3:15:2}"
	else
		echo "QCA7000 MAC address already burned"
	fi
fi

if [ "$mac1" == "$mac2" ]; then
	echo "MAC1 and MAC2 are equal"
	exit 1
fi

if [ "$mac1" == "$mac3" ]; then
	echo "MAC1 and MAC3 are equal"
	exit 1
fi

if [ "$mac2" == "$mac3" ]; then
	echo "MAC2 and MAC3 are equal"
	exit 1
fi

echo "HW_OCOTP_MAC0: $reg0"
echo $reg0 > /sys/fsl_otp/HW_OCOTP_MAC0
sleep 1
echo "HW_OCOTP_MAC1: $reg1"
echo $reg1 > /sys/fsl_otp/HW_OCOTP_MAC1
sleep 1
echo "HW_OCOTP_MAC2: $reg2"
echo $reg2 > /sys/fsl_otp/HW_OCOTP_MAC2

if [ "$reg3" != "" ]; then
	sleep 1
	echo "HW_OCOTP_GP30: $reg3"
	echo $reg3 > /sys/fsl_otp/HW_OCOTP_GP30
fi
