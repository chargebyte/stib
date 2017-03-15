Networking
==========

The device has on ethernet interface onboard, which is called *eth0*.
It supports 10/100 Mbit connections and MDI/MDI-X.
It ships with the following default network configuration:

+-------------------+----------------+
| Parameter         | Setting        |
+===================+================+
| Linux interface   | eth0           |
+-------------------+----------------+
| Connector         | J2             |
+-------------------+----------------+
| IPv4 address      | 192.168.37.250 |
+-------------------+----------------+
| IPv4 address      | 255.255.255.0  |
+-------------------+----------------+


The interface for CP [#f1]_ SLAC [#f2]_ is called *qca0*. It behaves like a usual ethernet
interface (including ethtool support). The QCA7000 which is connected via SPI to
the i.MX28 runs in burst mode. This interface ships with the following default
network configuration.

+-------------------+----------------+
| Parameter         | Setting        |
+===================+================+
| Linux interface   | qca0           |
+-------------------+----------------+
| Connector         | X6             |
+-------------------+----------------+
| IPv4 address      | 192.168.66.2   |
+-------------------+----------------+
| IPv4 address      | 255.255.255.0  |
+-------------------+----------------+

For a detailed description of all possible settings, please refer to the
`Debian network documentation`_.

.. _Debian network documentation: https://wiki.debian.org/NetworkConfiguration

The following list mentions only some features a Linux system is capable of:

* IPv4
* IPv6
* Unix domain sockets
* TCP / UDP
* VLAN, DHCP, Ethernet Bridging ( requires additional configuration )

.. rubric:: Footnotes

.. [#f1] Control Pilot
.. [#f2] Signal Level Attenuation Characterization
