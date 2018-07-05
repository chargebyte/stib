#!/bin/bash

echo -n "Testing for open-plc-utils ... "

if [ -x /usr/local/bin/plctool ]; then
	echo -e "\e[32mOK"
	echo -ne "\e[39m"
else
	echo -e "\e[31mFAILED"
	echo -ne "\e[39m"
fi

echo -n "Testing for can-utils ... "

if [ -x /usr/bin/cansend ]; then
	echo -e "\e[32mOK"
	echo -ne "\e[39m"
else
	echo -e "\e[31mFAILED"
	echo -ne "\e[39m"
fi

echo -n "Testing for /dev/ttymxc0 (RS485) ... "

DEVICE="no"
stty -F /dev/ttymxc0 > /dev/null 2>&1 && DEVICE="yes"

if [ "$DEVICE" = "yes" ]; then
	echo -e "\e[32mOK"
	echo -ne "\e[39m"
else
	echo -e "\e[31mFAILED"
	echo -ne "\e[39m"
fi

echo -n "Testing for /dev/ttymxc4 (RS485) ... "

DEVICE="no"
stty -F /dev/ttymxc4 > /dev/null 2>&1 && DEVICE="yes"

if [ "$DEVICE" = "yes" ]; then
	echo -e "\e[32mOK"
	echo -ne "\e[39m"
else
	echo -e "\e[31mFAILED"
	echo -ne "\e[39m"
fi

echo -n "Testing for /dev/ttymxc5 (STM32) ... "
	
DEVICE="no"
stty -F /dev/ttymxc5 > /dev/null 2>&1 && DEVICE="yes"

if [ "$DEVICE" = "yes" ]; then
	echo -e "\e[32mOK"
	echo -ne "\e[39m"
else
	echo -e "\e[31mFAILED"
	echo -ne "\e[39m"
fi

echo -n "Testing for /dev/ttymxc6 (ext UART) ... "

DEVICE="no"
stty -F /dev/ttymxc6 > /dev/null 2>&1 && DEVICE="yes"

if [ "$DEVICE" = "yes" ]; then
	echo -e "\e[32mOK"
	echo -ne "\e[39m"
else
	echo -e "\e[31mFAILED"
	echo -ne "\e[39m"
fi


echo -n "Testing for ADC channel 4 ... "

if [ ! -e /sys/bus/iio/devices/iio:device0/in_voltage4_raw ]; then
	echo -e "\e[31mFAILED"
	echo -ne "\e[39m"
else
	echo -e "\e[32mOK"
	echo -ne "\e[39m"
fi

echo -n "Testing for OTP (Ethernet) ... "
VAL=`cat /sys/fsl_otp/HW_OCOTP_MAC0`

if [ "$VAL" = "" ]; then
	echo -e "\e[31mFAILED"
	echo -ne "\e[39m"
elif [ "$VAL" = "0x0" ]; then
	echo -e "\e[31mFAILED"
	echo -ne "\e[39m"
else
	echo -e "\e[32mOK"
	echo -ne "\e[39m"
fi

echo -n "Testing for OTP (QCA7000) ... "
VAL=`cat /sys/fsl_otp/HW_OCOTP_GP2`

if [ "$VAL" = "" ]; then
	echo -e "\e[31mFAILED"
	echo -ne "\e[39m"
elif [ "$VAL" = "0x0" ]; then
	echo -e "\e[31mFAILED"
	echo -ne "\e[39m"
else
	echo -e "\e[32mOK"
	echo -ne "\e[39m"
fi

echo -n "Testing for watchdog ... "

if [ ! -e /dev/watchdog ]; then
	echo -e "\e[31mFAILED"
	echo -ne "\e[39m"
else
	echo -e "\e[32mOK"
	echo -ne "\e[39m"
fi

echo -n "Testing for pwmchip1 (DIG IN ref) ... "

if [ ! -e /sys/class/pwm/pwmchip1/pwm0/enable ]; then
	echo -e "\e[31mFAILED"
	echo -ne "\e[39m"
else
	echo -e "\e[32mOK"
	echo -ne "\e[39m"
fi

echo -n "Testing for pwmchip7 (CP) ... "

if [ ! -e /sys/class/pwm/pwmchip7/pwm0/enable ]; then
	echo -e "\e[31mFAILED"
	echo -ne "\e[39m"
else
	echo -e "\e[32mOK"
	echo -ne "\e[39m"
fi

echo -n "Testing for i2c-dev ... "

if [ ! -e /dev/i2c-3 ]; then
	echo -e "\e[31mFAILED"
	echo -ne "\e[39m"
else
	echo -e "\e[32mOK"
	echo -ne "\e[39m"
fi

echo -n "Testing for 3 LEDs ... "

if [ ! -e /sys/class/leds/evse:green:led1 ]; then
	echo -e "\e[31mFAILED"
	echo -ne "\e[39m"
elif [ ! -e /sys/class/leds/evse:yellow:led2 ]; then
	echo -e "\e[31mFAILED"
	echo -ne "\e[39m"
elif [ ! -e /sys/class/leds/evse:red:led3 ]; then
	echo -e "\e[31mFAILED"
	echo -ne "\e[39m"
else
	echo -e "\e[32mOK"
	echo -ne "\e[39m"
fi

echo -n "Testing for userspace GPIOs (qca7000) ... "

if [ ! -e /sys/class/gpio/gpio81 ]; then
	echo -e "\e[31mFAILED"
	echo -ne "\e[39m"
else
	echo -e "\e[32mOK"
	echo -ne "\e[39m"
fi

echo -n "Testing for running eth1 ... "

QCA="down"
/sbin/ifconfig eth1 2>/dev/null | grep -q UP && QCA="up"
test "$QCA" = "up" && /usr/local/bin/plctool -r -i eth1 | grep -q -e 'MAC-QCA7000' || QCA="down"

if [ "$QCA" = "down" ]; then
	echo -e "\e[31mFAILED"
	echo -ne "\e[39m"
else
	echo -e "\e[32mOK"
	echo -ne "\e[39m"
fi

echo -n "Testing for running eth2 ... "

QCA="down"
/sbin/ifconfig eth2 2>/dev/null | grep -q UP && QCA="up"
test "$QCA" = "up" && /usr/local/bin/plctool -r -i eth2 | grep -q -e 'MAC-QCA7000' || QCA="down"

if [ "$QCA" = "down" ]; then
	echo -e "\e[31mFAILED"
	echo -ne "\e[39m"
else
	echo -e "\e[32mOK"
	echo -ne "\e[39m"
fi

echo -n "Testing for running eth0 ... "

ETH="down"
/sbin/ifconfig eth0 2>/dev/null | grep -q UP && ETH="up"

if [ "$ETH" = "down" ]; then
	echo -e "\e[31mFAILED"
	echo -ne "\e[39m"
else
	echo -e "\e[32mOK"
	echo -ne "\e[39m"
fi

echo -n "Testing for running can0 ... "

CAN="down"
/sbin/ifconfig can0 2>/dev/null | grep -q UP && CAN="up"

if [ "$CAN" = "down" ]; then
	echo -e "\e[31mFAILED"
	echo -ne "\e[39m"
else
	echo -e "\e[32mOK"
	echo -ne "\e[39m"
fi

echo -n "Testing for running can1 ... "

CAN="down"
/sbin/ifconfig can1 2>/dev/null | grep -q UP && CAN="up"

if [ "$CAN" = "down" ]; then
	echo -e "\e[31mFAILED"
	echo -ne "\e[39m"
else
	echo -e "\e[32mOK"
	echo -ne "\e[39m"
fi

echo -n "Testing for PWM fan ... "

if [ ! -e /sys/class/hwmon/hwmon0/fan1_input ]; then
	echo -e "\e[31mFAILED"
	echo -ne "\e[39m"
else
	echo -e "\e[32mOK"
	echo -ne "\e[39m"
fi

echo -n "Testing for CPU thermal ... "

if [ ! -e /sys/class/hwmon/hwmon1/temp1_input ]; then
	echo -e "\e[31mFAILED"
	echo -ne "\e[39m"
else
	echo -e "\e[32mOK"
	echo -ne "\e[39m"
fi

echo -n "Testing for running OpenSSH ... "

if [ -f /var/run/sshd.pid -o -f /var/run/dropbear.pid ]; then
	echo -e "\e[32mOK"
	echo -ne "\e[39m"
else
	echo -e "\e[31mFAILED"
	echo -ne "\e[39m"
fi

echo -n "Testing rootfs (ext4,rw) ... "

ROOTFS="fail"
mount | grep -e 'on / type ext4[^)]*rw,' -q && ROOTFS="ok"

if [ "$ROOTFS" = "fail" ]; then
	echo -e "\e[31mFAILED"
	echo -ne "\e[39m"
else
	echo -e "\e[32mOK"
	echo -ne "\e[39m"
fi

echo -n "Testing for USB root hub ... "

USBHUB="fail"
lsusb | grep -e '1d6b' -q && USBHUB="ok"

if [ "$USBHUB" = "fail" ]; then
	echo -e "\e[31mFAILED"
	echo -ne "\e[39m"
else
	echo -e "\e[32mOK"
	echo -ne "\e[39m"
fi

echo -n "Testing IPv6 support ... "

IP6="fail"
/sbin/ifconfig eth1 2>/dev/null | grep -q inet6 && IP6="ok"
# test ! -x /bin/ping6 && IP6="fail"

if [ "$IP6" = "fail" ]; then
	echo -e "\e[31mFAILED"
	echo -ne "\e[39m"
else
	echo -e "\e[32mOK"
	echo -ne "\e[39m"
fi

