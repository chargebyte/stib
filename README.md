Simple Target Image Builder
===========================

This repository contains a simple but straightforward system to create a bootable
Linux system for the I2SE Duckbill device series: it compiles U-Boot as boot loader,
compiles a Linux kernel with device tree blobs and creates a root filesystem
based on Debian Jessie 8 (armel). Then all is packed into a single disk image,
ready to be used on the SD card and/or Duckbill's internal eMMC.

This system is intended to be run on a recent Linux system, currently Debian Jessie 8
and Ubuntu 14.04 (LTS) is supported. The main reason for this is, that both distributions
come with precompiled cross compiler packages, however, if you have a working
cross compiler for 'armel' at hand, you can simply make it available in PATH and
change the CROSS_COMPILE setting in the Makefile.

Compared to other Embedded Linux build systems (e.g. ptxdist, OpenWrt...) this
system is limited by design. Please remember the following design decisions
when using it:
* This system is intended to be run on a developer (none-shared) host.
  No precautions are taken to prevent this system running in parallel with
  a second instance in the same base directory.
* This system heavily uses sudo to handle the file permissions of the target
  linux system properly. So ensure that the system user you are using has
  the required permissions.
* You need a working internet connection to download the Debian packages for the
  target system. Only some minor efforts are done to cache the downloaded files.


Workflow to generate an image file
----------------------------------

To ensure that your host environment is setup corrctly, we have prepared a Makefile target
which helps you to install the distro packages as required. Simply issue a

```
$ make jessie-requirements
```

or

```
$ make trusty-requirements
```

and see which packages are fetched and installed via apt. Note, that the multistrap tool
in Ubuntu is faulty, so it's patched at this stage when the broken package is detected.
This step need to be run only once.

> Note:
> Due to a bug in multistrap, please ensure that your working directory name does not include any
> whitespace characters, otherwise multistrap will fail.
> See [Debian Bug 803365](http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=803365) for details.

This repository uses submodules to link/access various required sources and tools. So
after cloning this repo, you have to init these submodules first:

```
$ make prepare
```

Since the linux kernel project size is around 1.2 GB, this can take a while; however, if you
do not delete this directory, this is only required once. Later, hoping between branches and
pulling new changesets in, is really fast.

After this, compile the required tools, U-Boot and linux kernel:

```
$ make tools u-boot linux
```

Now it's time to create the basic Debian root filesystem with multistrap:

```
$ make rootfs
```

However, we want to customize it a little bit:

```
$ make install
```

And now, we pack all into a single SD card/eMMC image and split it into smaller chunks
so that we can deploy it during manufacturing process:

```
$ make disk-image
```

The resulting images/image parts are here:

```
$ ls -la images
```

To clean up everything generated by this makefile, simply run:

```
$ make distclean
```


Product variants
----------------

The original Duckbill (v1) has a SD card slot, the newer Duckbill v2 have an internal
eMMC flash chip. To select your target device, give this information via command line
argument to the makefile on each invocation, e.g.

```
$ make HWREV=v1 rootfs
```

Valid hardware revisions are at the moment: `v1` and `v2`.

There are multiple product variants available. To select the variant your are building
an image for, use `PRODUCT` command line argument, e.g.

```
$ make PRODUCT=duckbill-spi rootfs
```

Valid products are: `duckbill`, `duckbill-spi`, `duckbill-enocean` and `duckbill-485`.

You can also combine both variables, e.g.

```
$ make PRODUCT=duckbill HWREV=v1 rootfs
```

Default values are `PRODUCT=duckbill` and `HWREV=v2`.

These settings influence the default package selection and the U-Boot environment
(fdt_file is switched in the image file).


SD card / eMMC partitioning
---------------------------

The target SD card/eMMC images contain two primary partitions:

```
Device         Boot Start     End Sectors  Size Id Type
/dev/mmcblk0p1 *     2048    4095    2048    1M 53 OnTrack DM6 Aux3
/dev/mmcblk0p2       6144 3751935 3745792  1.8G 83 Linux
```

The first partition is required for the Freescale i.MX28 platform as it contains the boot stream,
used by the i.MX28 internal ROM to bring up the device. In our case, this partition contains
U-Boot as bootloader. This partition is required to have the partition id 0x53 and is 1 MiB in size.

The second partition is a normal ext4 linux filesystem containing the root filesystem. It must also
contain a subdirectory `/boot` in which the kernel `zImage` and one or multiple device tree files
(e.g. `imx28-duckbill.dtb`) reside. Please note, that U-Boot will look after these files during boot,
so when renaming files in this directory also update the U-Boot environment variables `image` and
`fdt_file` accordingly.

Another important point to note is, that the second partition is created as a small partition
of around 340 MB (this may also vary depending on the product variant since various products
include various packages pre-installed). Then during the first boot, the partition is resized
on-the-fly to fill up the whole space available. This done to be able to distribute small images
and to not depend on the exact size of the eMMC or SD card used (e.g. even two SD cards labeled
both with 2 GB may differ in exact size). One drawback of this approach is, that the device
needs to reboot during this first boot because the new partition size is not recognized by
the linux kernel as the partition is busy.
