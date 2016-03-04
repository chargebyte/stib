SPI
===

The Duckbill SPI is intended to be used in the evaluation kit “PLC bundle for Internet of Things”. 
Thus the device tree file contains a section which refers to the Qualcomm Atheros QCA7000 serial-to-powerline bridge.

The settings for the QCA driver are listed in the following table.

+------------------------------+-----------------+-------------------+
| Attribute                    | Source          | SSP2              |
+==============================+=================+===================+
| Type                         | Modprobe config | External          |
+------------------------------+-----------------+-------------------+
| MAC address                  | Device tree     | Value from OTP    |
+------------------------------+-----------------+-------------------+
| Max SPI clock rate           | Device tree     | 8 MHz             |
+------------------------------+-----------------+-------------------+
| SPI mode                     | Device tree     | 3                 |
+------------------------------+-----------------+-------------------+
| Expected SPI slave           | Device tree     | QCA7000           |
+------------------------------+-----------------+-------------------+
| Expected command mode        | Device tree     | burst             |
+------------------------------+-----------------+-------------------+

The device tree binding for the QCA driver can be found in the Kernel sources: 
Documentation/devicetree/bindings/net/qca-qca7000-spi.txt

Note 1: The MAC address is added dynamically by U-Boot into the device tree.

Note 2: The reference clock for SSP2 is switched from ref_io1 to ref_xtal by an additional kernel patch.
This limits the maximum SPI frequency to 24 MHz. This is due to observed bit errors when ref_io1 is 
used as clock source. However, for the use-case with QCA7000, the maximum clock rate is already limited 
by the QCA7000 which only supports up to 12 MHz. The reason for the conservative 8 MHz in the device tree is,
that the SPI leaves the Duckbill via the connector and “flying wires”.

