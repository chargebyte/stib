#!/bin/bash

function usage {
        echo "Usage: $0 MOTOR STATE"
        echo "  MOTOR = 1, 2"
	echo "  STATE = 0 (open), 1 (close)"
        exit 1
}

test $# -ne 2 && usage

# Init direction and polarity
echo "out" >/sys/class/gpio/gpio71/direction
echo "out" >/sys/class/gpio/gpio72/direction
echo 1 >/sys/class/gpio/gpio71/active_low
echo 0 >/sys/class/gpio/gpio72/active_low
echo "out" >/sys/class/gpio/gpio73/direction
echo "out" >/sys/class/gpio/gpio136/direction
echo 0 >/sys/class/gpio/gpio73/active_low
echo 0 >/sys/class/gpio/gpio136/active_low

if [ "$1" != "2" ]; then
OUT1=gpio71
OUT2=gpio72
else
OUT1=gpio73
OUT2=gpio136
fi

# Brake
echo "1" >/sys/class/gpio/$OUT1/value;echo "1" >/sys/class/gpio/$OUT2/value

# Wait for CAP charging (always MOTOR1)
echo "1" >/sys/class/gpio/gpio71/value;echo "1" >/sys/class/gpio/gpio72/value
sleep 5

if [ "$2" == "1" ]; then
	# Closing ( = go reverse ) 
	echo "0" >/sys/class/gpio/$OUT1/value;echo "1" >/sys/class/gpio/$OUT2/value
	sleep 0.6
	# Brake
	echo "1" >/sys/class/gpio/$OUT1/value;echo "1" >/sys/class/gpio/$OUT2/value
else
	# Open ( = go forward )
	echo "1" >/sys/class/gpio/$OUT1/value;echo "0" >/sys/class/gpio/$OUT2/value
	sleep 0.6
	# Brake
	echo "1" >/sys/class/gpio/$OUT1/value;echo "1" >/sys/class/gpio/$OUT2/value
fi

sleep 1
