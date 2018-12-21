FAQs/Howtos
===========

This howto section describes some basic procedures on a running EVAcharge SE device.

USB recovery mode
-----------------

The USB recovery mode is activated when:

- EVAcharge SE is powered on without a bootable image in the eMMC
- Boot selector jumpers (JP6, JP7) are configured for USB

Note: During USB recovery mode the i.MX28 attached LEDs are off.

Flashing
--------

The eMMC flash can be programmed via NXP's Manufacturing Tool `MfgTool <https://www.nxp.com/webapp/Download?colCode=IMX_MFG_TOOL>`_ (registration required). This uses the USB recovery mode of the i.MX28.
In this mode the MfgTool transfers a small piece of software into i.MX28's RAM, which is capable to access the device's eMMC flash.

Requirements:

- Windows(tm) PC with USB 2.0 interface
- NXP MfgTool 1 for i.MX28

Note: USB 3.0 isn't supported by MfgTool

Required steps:

- Extract the ZIP archive with the Linux image
- Copy the complete EVAcharge directory (e.g. EVAcharge) into NXP MfgTool Profile directory (<MfgToolInstallDir>/Profiles)
- Configure EVAcharge SE in USB recovery mode
- Power the EVAcharge SE with 12 V
- Connect the Windows PC with the EVAcharge SE via a USB-A-Male to USB-A-Male cable
  (at first time this triggers a driver installation)
- Start MfgTool
- Press the button "Scan devices"
- After the EVAcharge SE has been found the button on the right should be named as "Start" and green
- Select the profile (is the same as the directory name copied above) which should be flashed via the drop-down list
- Now press the button "Start" and wait until the writing process has been finished
- Finally press the button "Stop" and disconnect the EVAcharge SE from USB and power
- Before using the EVAcharge SE the boot selector jumpers must configured for eMMC again

.. _ethernet-bridging:

Ethernet Bridging
-----------------

It’s possible to use the EVAcharge SE as an Ethernet to Powerline bridge.

In order to setup a bridge automatically during boot then follow these steps:

- boot up EVAcharge SE and log in via Debug UART
- rename the existing network configuration::

   mv /etc/network/interfaces /etc/network/interfaces.orig

- create a new /etc/network/interfaces with the following content:
  ::

    source /etc/network/interfaces.d/*

    auto lo br0
    iface lo inet loopback

    iface eth0 inet manual
    iface eth1 inet manual

    # Bridge setup
    iface br0 inet static
      bridge_ports eth0 eth1
      bridge_maxwait 2
      address 192.168.37.250
      netmask 255.255.255.0
      post-up /sbin/brctl setfd br0 0

- finally restart the network interfaces::

  /etc/init.d/networking restart
