BOARD ?= duckbill
CROSS_COMPILE ?= arm-linux-gnueabi-

.PHONY: requirements
requirements:
	sudo apt-get install -y build-essential make patch multistrap curl bc
	sudo sh -c 'echo "deb http://emdebian.org/tools/debian/ jessie main" > /etc/apt/sources.list.d/crosstools.list'
	curl http://emdebian.org/tools/debian/emdebian-toolchain-archive.key | sudo apt-key add -
	sudo dpkg --add-architecture armel
	sudo apt-get update
	sudo apt-get install -y crossbuild-essential-armel

tools: tools/fsl-imx-uuc/sdimage tools/ptgen/ptgen

tools/fsl-imx-uuc/sdimage: tools/fsl-imx-uuc/sdimage.c tools/fsl-imx-uuc/Makefile
	$(MAKE) -C tools/fsl-imx-uuc

tools/ptgen: tools/ptgen/ptgen.c tools/ptgen/Makefile
	$(MAKE) -C tools/ptgen

.PHONY: tools-clean
tools-clean:
	$(MAKE) -C tools/fsl-imx-uuc clean
	$(MAKE) -C tools/ptgen clean

u-boot uboot: u-boot/u-boot.sb

u-boot/u-boot.sb:
	$(MAKE) -C u-boot $(BOARD)_defconfig CROSS_COMPILE="$(CROSS_COMPILE)"
	$(MAKE) -C u-boot u-boot.sb CROSS_COMPILE="$(CROSS_COMPILE)"

linux: linux/arch/arm/boot/zImage

linux/arch/arm/boot/zImage:
	$(MAKE) -C linux $(BOARD)_defconfig ARCH=arm CROSS_COMPILE="$(CROSS_COMPILE)"
	$(MAKE) -C linux ARCH=arm CROSS_COMPILE="$(CROSS_COMPILE)"

dtbs:
	$(MAKE) -C linux ARCH=arm CROSS_COMPILE="$(CROSS_COMPILE)" dtbs

.PHONY: clean
clean: tools-clean
	$(MAKE) -C u-boot clean
	$(MAKE) -C linux clean

.PHONY: rootfs
rootfs:
	$(MAKE) -C debian-rootfs

install:
	sudo mkdir -p rootfs
	sudo cp -va -t rootfs debian-rootfs/rootfs/*
	sudo mkdir -p rootfs/boot
	sudo cp -va linux/arch/arm/boot/zImage rootfs/boot/
	sudo cp -va linux/arch/arm/boot/dts/imx28-$(BOARD).dtb rootfs/boot/
	sudo chown 0:0 rootfs/boot/*
	sudo chmod 0644 rootfs/boot/*
	sudo mv rootfs/sbin/init rootfs/sbin/init.orig
	sudo cp debian-rootfs/init.sh rootfs/sbin/init
	sudo chown 0:0 rootfs/sbin/init
	sudo chmod 0755 rootfs/sbin/init

clean-rootfs:
	sudo rm -rf rootfs
