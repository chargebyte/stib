CAN
===

The device has a CAN interface onboard, which is available as *can0*
in Linux. It has a default baudrate of 1 MBit/s.

The following list mentions some features the system is capable of:

* FlexCAN driver with Netlink support (incl. CAN bit-timing calculation)
* Broadcast Manager CAN Protocol 
* CAN Gateway/Router supported

The CAN configuration is located in this script::

  /etc/rc.local
