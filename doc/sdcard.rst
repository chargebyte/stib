SD card slot
============

The devices are equipped with an additional SD card slot to store customer
data. When an SD card is inserted, it is accessible through the linux device
``/dev/mmcblk1``, and if the SD card contains multiple partitions they
appear as ``/dev/mmcblk1p1``, ``/dev/mmcblk1p2`` and so on.

Supported filesystems are FAT/FAT32 and ext2/3/4 by default.

Please note, that the filesystems on SD card are not automatically mounted,
you can do this manually e.g. by

  mount /dev/mmcblk1p1 /mnt

Do not forget to unmount the filesystem before removing the SD card, otherwise
you will most likely loss data, depending on the filesystem you used.

Note 1: It is not possible to boot a Duckbill 2 device from SD card as it
was possible for former Duckbill series. Duckbill 2 series devices always
boot from internal eMMC flash (however, it would be possible to instruct
U-Boot to not load linux kernel/root filesystem from eMMC but from SD card).

Note 2: Support for the SD card slot was introduced with BSP v1.3.
