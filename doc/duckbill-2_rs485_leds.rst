LEDs
====

The Duckbill is equipped with a two-color status LED at the bottom side. Each color
of the LED is wired to a dedicated GPIO pin of the CPU. As usual in Linux, both colors
are modelled as individual LED in the BSP.

During boot process, U-Boot switches the red status LED on shortly to indicate that
a software component is running at all. When linux kernel takes over, it flashes
the green status LED like a heartbeat, to indicate that the kernel is still alive and
running.

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
| off      | flashing | persistent               | Linux system is running                          |
+----------+----------+--------------------------+--------------------------------------------------+
| on       | flashing | persistent               | Linux system is running, but errors during       |
|          |          |                          | initialization                                   |
+----------+----------+--------------------------+--------------------------------------------------+

Additionally, the Duckbill 485 has two single LEDs on left and right side of the case.
The LEDs are handled by the ser2net application via sysfs. They indicate RS-485 operations
by flashing and are operational after a socket connection to ser2net has been established.

+-----------------+-------------------------------------+---------------------------------------+
| Attribute       | TX LED                              | RX LED                                |
+=================+=====================================+=======================================+
| Color           | red                                 | green                                 |
+-----------------+-------------------------------------+---------------------------------------+
| Linux Device    | /sys/class/leds/duckbill:red:rs485  | /sys/class/leds/duckbill:green:rs485  |
+-----------------+-------------------------------------+---------------------------------------+
| Default trigger | none                                | none                                  |
+-----------------+-------------------------------------+---------------------------------------+
