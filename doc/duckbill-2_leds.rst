LEDs
====

The Duckbill is equipped with a two-color status LED. Each color of the LED is
wired to a dedicated GPIO pin of the CPU. As usual in Linux, both colors are
modelled as individual LED in the BSP.

During boot process, U-Boot switches the red LED on shortly to indicate that
a software component is running at all. When linux kernel takes over, it flashes
the green LED like a heartbeat, to indicate that the kernel is still alive and
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
| off      | off      | persistant               | Device is powered off, attach power supply       |
+----------+----------+--------------------------+--------------------------------------------------+
| on       | off      | < 10s                    | U-Boot is running and loading Linux              |
+----------+----------+--------------------------+--------------------------------------------------+
| on       | flashing | < 25s                    | Linux kernel is booting                          |
+----------+----------+--------------------------+--------------------------------------------------+
| on       | off      | persistant               | U-Boot could not start Linux, attach Debug UART  |
|          |          |                          | to see U-Boot's error message;                   |
|          |          |                          | check U-Boot's *image* and/or *fdt_file*         |
|          |          |                          | environment settings and ensure, that these two  |
|          |          |                          | files are present in the root filesystem below   |
|          |          |                          | /boot                                            |
+----------+----------+--------------------------+--------------------------------------------------+
| off      | flashing | persistant               | Linux system is running                          |
+----------+----------+--------------------------+--------------------------------------------------+
| on       | flashing | persistant               | Linux system is running, but errors during       |
|          |          |                          | initialization                                   |
+----------+----------+--------------------------+--------------------------------------------------+
