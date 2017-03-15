FAQs/Howtos
===========

This Howto section describes some basic procedures on a running Duckbill device.
For build-time FAQ/Howtos, please refer to the documentation of the used BSP
project called `STIB`_.

.. _STIB: https://github.com/I2SE/stib

USB recovery mode
-----------------

The USB recovery mode is activated when:

* Duckbill is powered on without a bootable image in the eMMC,
* PSWITCH is pressed for more than five seconds while ROM boot.

Note: During USB recovery mode the Duckbill LEDs are off

Flashing
--------

The embedded eMMC flash can be programmed via Freescale's Manufacturing Tool `MfgTool <https://www.nxp.com/webapp/Download?colCode=IMX_MFG_TOOL>`_ (registration required). This uses the USB recovery mode of the i.MX28.
In this mode the MfgTool transfers a small software into i.MX28's RAM, which is able to access the eMMC flash.

Requirements:

* Windows PC with USB 2.0 interface
* Freescale MfgTool 1 for i.MX28

Note: USB 3.0 isn't supported by MfgTool

Necessary steps:

* Extract the ZIP archive with the Linux image
* Copy the complete Duckbill directory ( e.g. Duckbill2_v1_2 ) into Freescale MfgTool Profile directory ( <MfgToolInstallDir>/Profiles )
* Start Duckbill in USB recovery mode ( at first time this triggers a driver installation )
* Start MfgTool
* Press the button "Scan devices"
* After the Duckbill has been found the button on the right should be named as "Start" and green
* Select the profile ( is the same as the directory name copied above ) which should be flashed via the drop-down list
* Now press the button "Start" and wait until the writing process has been finished
* Finally press the button "Stop" and disconnect Duckbill from USB

Update the Linux kernel
-----------------------

* Transfer the new linux kernel image (zImage) binary to the Duckbill.
* Replace the existing linux kernel image in */boot* directory with the new one.
* Reboot the Duckbill, so that the new kernel is used.


Update the Device Tree binary
-----------------------------

* Transfer the new Device Tree binary file to the Duckbill.
* Replace the existing Device Tree binary in */boot* directory with the new one.
* Please remember, that U-Boot looks for a device specific filename when booting,
  so either use the same filename as of the replaced file, or adjust the U-Boot setting with::

    fw_setenv fdt_file <new-file.dtb>
    sync

* Reboot the Duckbill, so that the new Device Tree is used.


Update U-Boot on the target device from running Linux
-----------------------------------------------------

* Transfer the new U-Boot image file (u-boot.sb) to the Duckbill.
* Install it with the following command::

    sdimage -f u-boot.sb -d /dev/mmcblk0
    sync


Modify U-Boot environment
-------------------------

The BSP comes with the U-Boot tools *fw_printenv* and *fw_setenv*
pre-installed. Use fw_printenv to show all or individual U-Boot environment
variables and use fw_setenv to modify or delete them.

Both tools require the configuration file */etc/fw_env.config* with the
following content::

  /dev/mmcblk0 0x20000 0x20000
  /dev/mmcblk0 0x40000 0x20000

This file tells both tools where to save the both redundant U-Boot environment
regions within the eMMC/SD card, and how large both areas are.


Modify kernel command line parameters
-------------------------------------

U-Boot passes kernel command line arguments to linux kernel using the U-Boot environment
variable *bootargs*. However, on Duckbill this variable is constructed at run-time.
So if you need to append some command line arguments, please extend the U-Boot variable
*mmcargs*, e.g.::

  fw_setenv mmcargs console=\${console},\${baudrate} root=\${mmcroot} rootwait bootsys=\${bootsys} panic=1 <something to append>
  sync

Please note, that the default content of mmcargs contains variable names, so you have
to quote these properly, otherwise your shell would try to expand the variables!

To make it easier during development, it is recommended to introduce a dedicated variable
and to append solely a reference to it, e.g.::

  fw_setenv custom_args <something to append>
  fw_setenv mmcargs console=\${console},\${baudrate} root=\${mmcroot} rootwait bootsys=\${bootsys} panic=1 \${custom_args}
  sync

This way, you can focus on changing *custom_args* without worrying to always touch
the longish *mmcargs* variable.

The *mmcargs* U-Boot variable shown above contains the factory default string used in U-Boot
to build the kernel command line. So at runtime, the variable references are substituted and
this results in a default kernel command line:

  console=ttyAMA0,115200 root=/dev/mmcblk0p2 rootwait bootsys=1 panic=1
