#!/bin/sh

MODEL=$(cat /proc/device-tree/model)

case "$MODEL" in
"I2SE EVAcharge SE")
        LED="evse:yellow:led1"
        ;;
"I2SE Tarragon")
        LED="evse:yellow:led2"
        ;;
*)
        exit 0
esac

. /lib/led.sh
led_timer "$LED" 250 250

exit 0
