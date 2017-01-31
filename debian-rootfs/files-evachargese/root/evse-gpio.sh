#!/bin/bash
#
#  Copyright (c) 2013 I2SE GmbH
#

DAUGHTER=""
DAUGHTER="$DAUGHTER 39"  # MX28_PAD_LCD_D07__GPIO_1_7, DAUGHTER_GPIO_0
DAUGHTER="$DAUGHTER 42"  # MX28_PAD_LCD_D10__GPIO_1_10, DAUGHTER_GPIO_1
DAUGHTER="$DAUGHTER 57"  # MX28_PAD_LCD_WR_RWN__GPIO_1_25, DAUGHTER_GPIO_2
DAUGHTER="$DAUGHTER 60"  # MX28_PAD_LCD_VSYNC__GPIO_1_28, DAUGHTER_GPIO_3
DAUGHTER="$DAUGHTER 61"  # MX28_PAD_LCD_HSYNC__GPIO_1_29, DAUGHTER_GPIO_4
DAUGHTER="$DAUGHTER 62"  # MX28_PAD_LCD_DOTCLK__GPIO_1_30, DAUGHTER_GPIO_5

QCA7K=""
QCA7K="$QCA7K 45"  # MX28_PAD_LCD_D13__GPIO_1_13, QCA7K_RESET
QCA7K="$QCA7K 46"  # MX28_PAD_LCD_D14__GPIO_1_14, QCA7K_GPIO_0
QCA7K="$QCA7K 47"  # MX28_PAD_LCD_D15__GPIO_1_15, QCA7K_GPIO_1
QCA7K="$QCA7K 50"  # MX28_PAD_LCD_D18__GPIO_1_18, QCA7K_GPIO_2
QCA7K="$QCA7K 53"  # MX28_PAD_LCD_D21__GPIO_1_21, QCA7K_GPIO_3
# QCA7K="$QCA7K 121"  MX28_PAD_I2C0_SDA__GPIO_3_25, QCA7K_SPI_INT

GPIOS="$DAUGHTER $QCA7K"

function usage {
        echo "Usage: $0 ACTION"
        echo "  ACTION = export | unexport | set"
        echo "  If ACTION is set then second parameter must be the new GPIO value"
        exit 1
}

case "$1" in
        "export")
                test $# -ne 1 && usage
                ;;
        "unexport")
                test $# -ne 1 && usage
                ;;
        "set")
                test $# -lt 2 && usage
                ;;
        *)
                usage
                ;;
esac

if [ "$1" == "export" ]; then

        for gpio in $GPIOS; do
                test -e /sys/class/gpio/gpio$gpio && continue
                echo "$gpio" > /sys/class/gpio/export
        done

elif [ "$1" == "unexport" ]; then

        for gpio in $GPIOS; do
                test ! -e /sys/class/gpio/gpio$gpio && continue
                echo "$gpio" > /sys/class/gpio/unexport
        done

elif [ "$1" == "set" ]; then

        if [ "$3" == "daughter" ]; then
                GPIOS="$DAUGHTER"
        elif [ "$3" == "qca7k" ]; then
                GPIOS="$QCA7K"
        fi

        for gpio in $GPIOS; do
                echo "out" > /sys/class/gpio/gpio$gpio/direction || continue
                echo "$2" > /sys/class/gpio/gpio$gpio/value
        done

fi

