LEDs
====

The Duckbill is equipped with a two-color status LED at the bottom side. Each color
of the LED is wired to a dedicated GPIO pin of the CPU. As usual in Linux, both colors
are modelled as individual LED in the BSP.

During boot process, U-Boot switches the red status LED on shortly to indicate that
a software component is running at all. When linux kernel takes over, it flashes
the green status LED like a heartbeat, to indicate that the kernel is still alive and
running. The red status LED represent the state of the SPI connection to the QCA7000.

+-----------------+-----------------------------------------------------------------------------+
| Attribute       | Status LED                                                                  |
+=================+=====================================+=======================================+
| Color           | red                                 | green                                 |
+-----------------+-------------------------------------+---------------------------------------+
| Linux Device    | /sys/class/leds/duckbill:red:status | /sys/class/leds/duckbill:green:status |
+-----------------+-------------------------------------+---------------------------------------+
| Default trigger | none                                | heartbeat                             |
+-----------------+-------------------------------------+---------------------------------------+

The following table lists various device states.

+---------------------+--------------------------+--------------------------------------------------+
| Status LED          | Duration of this state   | Status / possible solution                       |
+----------+----------+                          |                                                  |
| red      | green    |                          |                                                  |
+==========+==========+==========================+==================================================+
| off      | off      | persistent               | Device is powered off, attach power supply       |
+----------+----------+--------------------------+--------------------------------------------------+
| on       | off      | < 10s                    | U-Boot is running and loading Linux              |
+----------+----------+--------------------------+--------------------------------------------------+
| on       | flashing | < 25s                    | Linux kernel is booting                          |
+----------+----------+--------------------------+--------------------------------------------------+
| on       | off      | persistent               | U-Boot could not start Linux                     |
+----------+----------+--------------------------+--------------------------------------------------+
| off      | flashing | persistent               | Linux system is running, but no SPI connection   |
+----------+----------+--------------------------+--------------------------------------------------+
| flashing | flashing | persistent               | Linux system is running and has a working SPI    |
|          |          |                          | connection                                       |
+----------+----------+--------------------------+--------------------------------------------------+



