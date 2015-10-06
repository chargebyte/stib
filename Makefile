BOARD ?= duckbill
CROSS_COMPILE ?= arm-linux-gnueabi-
JOBS ?= $(shell cat /proc/cpuinfo | grep processor | wc -l)

ROOTFSSIZE:=$(shell echo $$((512 * 1024 * 1024)))
ROOTFSCHUNKSIZE:=$(shell echo $$((64 * 1024 * 1024)))

PATH:=./tools/ptgen:./tools/fsl-imx-uuc:$(PATH)
export PATH ROOTFSSIZE

.PHONY: jessie-requirements
jessie-requirements:
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

.PHONY: u-boot uboot
u-boot uboot: u-boot/u-boot.sb

u-boot/u-boot.sb:
	$(MAKE) -C u-boot $(BOARD)_defconfig CROSS_COMPILE="$(CROSS_COMPILE)"
	$(MAKE) -C u-boot -j $(JOBS) u-boot.sb CROSS_COMPILE="$(CROSS_COMPILE)"

.PHONY: linux
linux: linux/arch/arm/boot/zImage

linux/arch/arm/boot/zImage:
	$(MAKE) -C linux $(BOARD)_defconfig ARCH=arm CROSS_COMPILE="$(CROSS_COMPILE)"
	$(MAKE) -C linux -j $(JOBS) ARCH=arm CROSS_COMPILE="$(CROSS_COMPILE)"

dtbs:
	$(MAKE) -C linux ARCH=arm CROSS_COMPILE="$(CROSS_COMPILE)" dtbs

.PHONY: clean
clean: tools-clean
	$(MAKE) -C u-boot clean
	$(MAKE) -C linux clean

rootfs-clean:
	$(MAKE) -C debian-rootfs clean

.PHONY: rootfs
rootfs:
	$(MAKE) -C debian-rootfs

install: clean-rootfs
	sudo mkdir -p rootfs
	sudo cp -av debian-rootfs/rootfs/* rootfs/
	sudo mkdir -p rootfs/boot
	sudo cp -av linux/arch/arm/boot/zImage rootfs/boot/
	sudo cp -av linux/arch/arm/boot/dts/imx28-$(BOARD).dtb rootfs/boot/
	sudo chown 0:0 rootfs/boot/*
	sudo chmod 0644 rootfs/boot/*
	sudo mv rootfs/sbin/init rootfs/sbin/init.orig
	sudo cp -a debian-rootfs/files rootfs-tmp/
	sudo sh -c 'echo "$(BOARD)" > rootfs-tmp/etc/hostname'
	sudo chown 0:0 -R rootfs-tmp
	sudo cp -a rootfs-tmp/* rootfs
	sudo rm -rf rootfs-tmp

clean-rootfs:
	sudo rm -rf rootfs rootfs-tmp

.PHONY: rootfs-image disk-image

rootfs-image: images/rootfs.img

.PHONY: images/rootfs.img
images/rootfs.img:
	rm -f images/rootfs.img
	mkdir -p images
	dd if=/dev/zero of=images/rootfs.img seek=$$(($(ROOTFSSIZE) - 1)) bs=1 count=1
	sudo mkfs.ext4 images/rootfs.img
	sudo mount images/rootfs.img /mnt -o loop
	sudo cp -a rootfs/* /mnt
	sudo umount /mnt

disk-image: images/sdcard.img
	rm -f images/sdcard.img.*
	split -b $(ROOTFSCHUNKSIZE) --numeric-suffixes=1 images/sdcard.img images/sdcard.img.

images/sdcard.img: images/rootfs.img
	sh tools/gen_sdcard_ext4.sh images/sdcard.img u-boot/u-boot.sb images/rootfs.img $$(($(ROOTFSSIZE) / (1024 * 1024)))
