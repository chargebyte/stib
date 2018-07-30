#!/bin/bash

function usage {
        echo "Usage: $0 MOTOR STATE"
        echo "  MOTOR = 1, 2"
	echo "  STATE = 0 (open), 1 (close)"
        exit 1
}

test $# -ne 2 && usage

if [ "$1" != "2" ]; then
OUT1=gpio71
OUT2=gpio72
POLARITY1=1
POLARITY2=0
else
OUT1=gpio73
OUT2=gpio136
POLARITY1=0
POLARITY2=0
fi

# Init direction and polarity
echo "out" >/sys/class/gpio/$OUT1/direction
echo "out" >/sys/class/gpio/$OUT2/direction
echo $POLARITY1 >/sys/class/gpio/$OUT1/active_low
echo $POLARITY2 >/sys/class/gpio/$OUT2/active_low

# Stop
echo "0" >/sys/class/gpio/$OUT1/value;echo "0" >/sys/class/gpio/$OUT2/value

# Wait for CAP charging
echo "1" >/sys/class/gpio/$OUT1/value;echo "0" >/sys/class/gpio/$OUT2/value
sleep 5

if [ "$2" == "1" ]; then
	# Reverse
	echo "0" >/sys/class/gpio/$OUT1/value;echo "1" >/sys/class/gpio/$OUT2/value
	sleep 0.6
	# Stop
	echo "0" >/sys/class/gpio/$OUT1/value;echo "0" >/sys/class/gpio/$OUT2/value
else
	# Forward
	echo "1" >/sys/class/gpio/$OUT1/value;echo "0" >/sys/class/gpio/$OUT2/value
	sleep 0.6
	# Stop
	echo "0" >/sys/class/gpio/$OUT1/value;echo "0" >/sys/class/gpio/$OUT2/value
fi

sleep 1
