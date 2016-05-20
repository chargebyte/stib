Networking
==========

The device has on ethernet interface onboard, which is called *eth0* in the
Linux system. It supports 10/100 Mbit connections and MDI/MDI-X.

The following list mentions only some features a Linux system is capable of:

* IPv4
* IPv6
* Unix domain sockets
* TCP / UDP
* DHCP
* Ethernet Bridging

The Duckbill device comes with the following default network configuration:

+-------------------+--------------+-------------------+
| Setting           |   Value      |   Value           |
+===================+==============+===================+
| Linux interface   |   eth0       |   eth0:1          |
+-------------------+--------------+-------------------+
| IPv4 address      |   via DHCP   |   169.254.12.53   |
+-------------------+--------------+-------------------+
| IPv4 netmask      |   via DHCP   |   255.255.0.0     |
+-------------------+--------------+-------------------+
| Default gateway   |   via DHCP   |                   |
+-------------------+--------------+-------------------+
| DNS server        |   via DHCP   |                   |
+-------------------+--------------+-------------------+

These settings allow to integrate the Duckbill into every network with automatic
configuration, but also provide an emergency fallback IP address in case you attach
the Duckbill directly to a PC.

For a detailed description of all possible settings, please refer to the
`Debian network documentation`_.

.. _Debian network documentation: https://wiki.debian.org/NetworkConfiguration
