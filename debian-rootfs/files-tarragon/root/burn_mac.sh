#!/bin/bash
#
#  Copyright (c) 2018 I2SE GmbH
#

verify=`cat /sys/fsl_otp/HW_OCOTP_MAC0 2>/dev/null`

if [ $# -lt 1 ] || [ $# -gt 5 ]; then
	cat >&2 <<EOU
Usage: $0 MAC1 [MAC2 MAC3 [MAC4 MAC5]]
  MAC1   Ethernet MAC address
  MAC2   QCA7000 CP Host MAC address (must have an I2SE OUI)
  MAC3   QCA7000 CP Firmware MAC address (must have an I2SE OUI)
  MAC4   QCA7000 MAINS Host MAC address (must have an I2SE OUI)
  MAC5   QCA7000 MAINS Firmware MAC address (must have an I2SE OUI)
EOU
	exit 1
fi

mac1=`echo $1 | tr '[:upper:]' '[:lower:]'`
mac2=`echo $2 | tr '[:upper:]' '[:lower:]'`
mac3=`echo $3 | tr '[:upper:]' '[:lower:]'`
mac4=`echo $4 | tr '[:upper:]' '[:lower:]'`
mac5=`echo $5 | tr '[:upper:]' '[:lower:]'`

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

if [ $# -eq 2 ]; then
	echo "MAC3 not specified"
	exit 1
fi

if [ $# -eq 4 ]; then
	echo "MAC5 not specified"
	exit 1
fi

reg0="0x${mac1:6:2}${mac1:9:2}${mac1:12:2}${mac1:15:2}"
reg1="0x0000${mac1:0:2}${mac1:3:2}"
reg2=""
reg3=""
reg4=""
reg5=""

if [ $# -gt 2 ]; then

	# Currently this script and the kernel only support I2SE OUI for QCA7000
	if [[ ! "$mac2" =~ ^00[:]01[:]87([:]([0-9a-f]){2}){3}$ ]]; then
		echo "Invalid MAC2"
		exit 1
	fi

	# Currently this script and the kernel only support I2SE OUI for QCA7000
	if [[ ! "$mac3" =~ ^00[:]01[:]87([:]([0-9a-f]){2}){3}$ ]]; then
		echo "Invalid MAC3"
		exit 1
	fi

	verify=`cat /sys/fsl_otp/HW_OCOTP_GP2 2>/dev/null`

	if [ "$verify" == "0x0" ]; then
		reg2="0x${mac2:6:2}${mac2:9:2}${mac2:12:2}${mac2:15:2}"
		reg3="0x${mac3:6:2}${mac3:9:2}${mac3:12:2}${mac3:15:2}"
	else
		echo "QCA7000 MAC CP address already burned"
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
fi

if [ $# -gt 4 ]; then

	# Currently this script and the kernel only support I2SE OUI for QCA7000
	if [[ ! "$mac4" =~ ^00[:]01[:]87([:]([0-9a-f]){2}){3}$ ]]; then
		echo "Invalid MAC4"
		exit 1
	fi

	# Currently this script and the kernel only support I2SE OUI for QCA7000
	if [[ ! "$mac5" =~ ^00[:]01[:]87([:]([0-9a-f]){2}){3}$ ]]; then
		echo "Invalid MAC5"
		exit 1
	fi

	verify=`cat /sys/fsl_otp/HW_OCOTP_GP1 2>/dev/null`

	if [ "$verify" == "0x0" ]; then
		reg4="0x${mac4:6:2}${mac4:9:2}${mac4:12:2}${mac4:15:2}"
		reg5="0x${mac5:6:2}${mac5:9:2}${mac5:12:2}${mac5:15:2}"
	else
		echo "QCA7000 MAC MAINS address already burned"
	fi

	if [ "$mac2" == "$mac4" ]; then
		echo "MAC2 and MAC4 are equal"
		exit 1
	fi

	if [ "$mac2" == "$mac5" ]; then
		echo "MAC2 and MAC5 are equal"
		exit 1
	fi

	if [ "$mac3" == "$mac4" ]; then
		echo "MAC3 and MAC4 are equal"
		exit 1
	fi

	if [ "$mac3" == "$mac5" ]; then
		echo "MAC3 and MAC5 are equal"
		exit 1
	fi

	if [ "$mac4" == "$mac5" ]; then
		echo "MAC4 and MAC5 are equal"
		exit 1
	fi
fi

echo "HW_OCOTP_MAC0: $reg0"
echo $reg0 > /sys/fsl_otp/HW_OCOTP_MAC0
sleep 1
echo "HW_OCOTP_MAC1: $reg1"
echo $reg1 > /sys/fsl_otp/HW_OCOTP_MAC1
echo "HW_OCOTP_MAC2: unused"

if [ "$reg2" != "" ]; then
	sleep 1
	echo "HW_OCOTP_GP2: $reg2"
	echo $reg2 > /sys/fsl_otp/HW_OCOTP_GP2
	sleep 1
	echo "HW_OCOTP_SW_GP2: $reg3"
	echo $reg3 > /sys/fsl_otp/HW_OCOTP_SW_GP2
fi

if [ "$reg4" != "" ]; then
	sleep 1
	echo "HW_OCOTP_GP1: $reg4"
	echo $reg4 > /sys/fsl_otp/HW_OCOTP_GP1
	sleep 1
	echo "HW_OCOTP_SW_GP1: $reg5"
	echo $reg5 > /sys/fsl_otp/HW_OCOTP_SW_GP1
fi
