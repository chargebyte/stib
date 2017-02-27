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
