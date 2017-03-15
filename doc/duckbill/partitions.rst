Partitions
==========

The default SD card/eMMC images contain two primary partitions::

  Device         Boot Start     End Sectors  Size Id Type
  /dev/mmcblk0p1 *     2048    4095    2048    1M 53 OnTrack DM6 Aux3
  /dev/mmcblk0p2       6144 3751935 3745792  1.8G 83 Linux

The first partition is required for the Freescale i.MX28 platform as it contains
the boot stream, used by the i.MX28 internal ROM to bring up the device.
In our case, this partition contains U-Boot as bootloader. This partition is
required to have the partition id 0x53 and is 1 MiB in size.

The second partition is a normal ext4 linux filesystem containing the root
filesystem. It must also contain a subdirectory */boot* in which the kernel
*zImage* and one or multiple device tree files (e.g. *imx28-duckbill-2.dtb*)
reside. Please note, that U-Boot will look after these files during boot, so
when renaming files in this directory also update the U-Boot environment
variables *image* and *fdt_file* accordingly.

Another important point to note is, that the second partition is created as a
small partition of around 340 MB (this may also vary depending on the product
variant since various products include various packages pre-installed).
Then during the first boot, the partition is resized on-the-fly to fill up the
whole space available. This done to be able to distribute small images and to
not depend on the exact size of the eMMC or SD card used (e.g. even two SD
cards labeled both with 2 GB may differ in exact size). One drawback of this
approach is, that the device needs to reboot during this first boot because
the new partition size is not recognized by the linux kernel as the partition
is busy.

U-Boot uses dedicated space to save various variables, the so called
U-Boot environment. On Duckbill, there are two different regions reserved in
the eMMC/SD card for this U-Boot environment. When modifying the environment,
only one region is updated, the other one is left unchanged so that there is
always a valid copy of the U-Boot environment. Both regions are 128 kB each.
The first region starts at offset 128 kB from the beginning of the eMMC/SD card,
the second region starts at offset 256 kB, thus both regions are placed before
the start of the first partition.
