#!/bin/bash
#
# Copyright (c) 2018 I2SE GmbH
#

SERIALPORT="/dev/ttymxc5"
GPIO_BOOT0="74"
GPIO_RESET="75"
GPIO_SEQUENCE="$GPIO_BOOT0,-$GPIO_RESET,$GPIO_RESET,:-$GPIO_BOOT0,-$GPIO_RESET,$GPIO_RESET"
FIRMWARE="tarragon_sw_stm32.bin"

# export gpio
test -e /sys/class/gpio/gpio$GPIO_BOOT0 || echo $GPIO_BOOT0 > /sys/class/gpio/export
test -e /sys/class/gpio/gpio$GPIO_RESET || echo $GPIO_RESET > /sys/class/gpio/export

# config gpio as output
echo "out" > /sys/class/gpio/gpio$GPIO_BOOT0/direction
echo "out" > /sys/class/gpio/gpio$GPIO_RESET/direction

# flash new firmware
stm32flash -i "$GPIO_SEQUENCE" -e 0 -w "$FIRMWARE" "$SERIALPORT"

# workaround to restart flashed firmware (reset STM32)
echo low > /sys/class/gpio/gpio$GPIO_RESET/direction
echo input > /sys/class/gpio/gpio$GPIO_RESET/direction
