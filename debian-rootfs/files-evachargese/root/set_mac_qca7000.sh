#!/bin/sh

otp=`cat /sys/fsl_otp/HW_OCOTP_CUST2`

mac=`/root/otp2mac.sh $otp 00:01:87`

modpib -M $mac /root/QCA7000-SpiSlave-HomePlugGP_CE-ClassB-minus67db.pib

/root/flash_qca7000_temporarily.sh -f