#!/bin/sh

DEVICE="/sys/class/pwm/pwmchip1"

echo 0 > $DEVICE/export
echo 40000 > $DEVICE/pwm0/period
echo 20000 > $DEVICE/pwm0/duty_cycle
echo 1 > $DEVICE/pwm0/enable
