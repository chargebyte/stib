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
	FDT_FILE="imx28-duckbill.dtb"
	if [ "$HWREV" = "v2" ]; then
		FDT_FILE="imx28-duckbill-v2.dtb"
	fi
	;;

duckbill-spi)
	FDT_FILE="imx28-duckbill-spi.dtb"
	if [ "$HWREV" = "v1" ]; then
		FDT_FILE="imx28-duckbill-spi-v1.dtb"
	fi
	;;

duckbill-enocean)
	FDT_FILE="imx28-duckbill-enocean.dtb"
	if [ "$HWREV" = "v1" ]; then
		FDT_FILE="imx28-duckbill-enocean-v1.dtb"
	fi
	;;

duckbill-485)
	FDT_FILE="imx28-duckbill-485.dtb"
	if [ "$HWREV" = "v1" ]; then
		FDT_FILE="imx28-duckbill-485-v1.dtb"
	fi
	;;
esac

[ -n "$FDT_FILE" ] || {
	echo "Error: could not map product to fdt_file" >&2
	exit 1
}

# need to write this two times, so that both env copies are updated
fw_setenv -c "$ENVCFG" fdt_file "$FDT_FILE"
fw_setenv -c "$ENVCFG" fdt_file "$FDT_FILE"
