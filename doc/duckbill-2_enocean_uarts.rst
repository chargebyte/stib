UART
====

The Duckbill EnOcean has an application UART which is connected to the 
EnOcean module TCM310.

+------------------------------+------------------+
| Attribute                    | Application UART |
+==============================+==================+
| Function                     | EnOcean Gateway  |
+------------------------------+------------------+
| Linux Device                 | /dev/ttyAPP0     |
+------------------------------+------------------+
| Baudrate                     | 57600            |
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
