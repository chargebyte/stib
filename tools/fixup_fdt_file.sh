#!/usr/bin/env bash

[ $# -eq 3 ] || {
	echo "Syntax: $0 <u-boot env config> <product> <hwrev>" >&2
	exit 1
}

ENVCFG="$1"
PRODUCT="$2"
HWREV="$3"

case "$PRODUCT" in
duckbill)
	FDT_FILE="imx28-duckbill-2.dtb"
	if [ "$HWREV" = "v1" ]; then
		FDT_FILE="imx28-duckbill.dtb"
	fi
	;;

duckbill-spi)
	FDT_FILE="imx28-duckbill-2-spi.dtb"
	if [ "$HWREV" = "v1" ]; then
		FDT_FILE="imx28-duckbill-spi.dtb"
	fi
	;;

duckbill-enocean)
	FDT_FILE="imx28-duckbill-2-enocean.dtb"
	if [ "$HWREV" = "v1" ]; then
		FDT_FILE="imx28-duckbill-enocean.dtb"
	fi
	;;

duckbill-485)
	FDT_FILE="imx28-duckbill-2-485.dtb"
	if [ "$HWREV" = "v1" ]; then
		FDT_FILE="imx28-duckbill-485.dtb"
	fi
	;;

evachargese)
	FDT_FILE="imx28-evachargese.dtb"
	;;

esac

[ -n "$FDT_FILE" ] || {
	echo "Error: could not map product to fdt_file" >&2
	exit 1
}

# need to write this two times, so that both env copies are updated
fw_setenv -c "$ENVCFG" fdt_file "$FDT_FILE"
fw_setenv -c "$ENVCFG" fdt_file "$FDT_FILE"
