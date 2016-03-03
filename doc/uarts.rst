UARTs
=====

The Duckbill comes with two UARTs on the pin headers. The Debug UART (part of connector 4)
is usually used as system console, while the second UART (part of connector 3)
is used as application UART. Please note, that the Debug UART has 3.3 V level,
so do not connect it directly to your PCs serial port. We recommend to use an 
USB to UART TTL level adapter; there are plenty products available.

+------------------------------+----------------+------------------+
| Attribute                    | Debug UART     | Application UART |
+==============================+================+==================+
| Function                     | System console | Customer defined |
+------------------------------+----------------+------------------+
| Linux Device                 | /dev/ttyAMA0   | /dev/ttyAPP0     |
+------------------------------+----------------+------------------+
| Baudrate                     | 115200         | 115200           |
+------------------------------+----------------+------------------+
| Data bits                    | 8              | 8                |
+------------------------------+----------------+------------------+
| Parity                       | None           | None             |
+------------------------------+----------------+------------------+
| Stop bits                    | 1              | 1                |
+------------------------------+----------------+------------------+
| Flow control                 | None           | None             |
+------------------------------+----------------+------------------+

The settings listed above are default values. For the Debug UART, we do not recommend
to change the settings.

The application UART uses only Rx and Tx lines by default, but not RTS/CTS. If your
application required hardware flow control, you have to modify the Device Tree binary
to use the correct pin muxing on the additional required pins. In this case, you loose
this/these pin(s) for other functionality.
