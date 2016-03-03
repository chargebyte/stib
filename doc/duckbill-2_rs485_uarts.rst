UART
====

The Duckbill 485 has an application UART which is connected to the
RS-485 interface.

+------------------------------+------------------+
| Attribute                    | Application UART |
+==============================+==================+
| Function                     | RS-485 Gateway   |
+------------------------------+------------------+
| Linux Device                 | /dev/ttyAPP0     |
+------------------------------+------------------+
| Baudrate                     | 115200           |
+------------------------------+------------------+
| Data bits                    | 8                |
+------------------------------+------------------+
| Parity                       | None             |
+------------------------------+------------------+
| Stop bits                    | 1                |
+------------------------------+------------------+
| Flow control                 | None             |
+------------------------------+------------------+

The BSP makes the UART available via a TCP socket on the Ethernet.
The RFC2217 compatible network service listens on TCP port 5000.

