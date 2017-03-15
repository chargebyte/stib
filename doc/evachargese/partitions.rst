Partitions
==========

The following table describes the partitions of the eMMC:

+-----------+---------------------------+----------------+--------------+-------------+
| Partition | Function                  | Linux Device   | Size         | File system |
+===========+===========================+================+==============+=============+
| 1         | Boot loader + Kernel + DT | /dev/mmcblk0p1 | 8 MB         | --          |
+-----------+---------------------------+----------------+--------------+-------------+
| 2         | Root file system          | /dev/mmcblk0p2 | 3 GB         | ext4        |
+-----------+---------------------------+----------------+--------------+-------------+
| --        | free space                | --             | min. 800 MB  | --          |
+-----------+---------------------------+----------------+--------------+-------------+

The first partition is required for the Freescale i.MX28 platform as it contains
the boot stream, used by the i.MX28 internal ROM to bring up the device. For
EVAcharge SE, this partition contains the imx-bootlets as bootloader, combined
with the Linux kernel with in turn has Device Tree blob appended.
This partition is required to have the partition id 0x53.

The second partition is a normal ext4 linux filesystem containing the root filesystem.

The remaining space of the eMMC is not assigned to any partition by default
and can be used by customer for e.g. a dedicated data partition.

The kernel has built-in support for the following filesystems:

- ext4
- vfat
