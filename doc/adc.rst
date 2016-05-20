ADC
===

The Duckbill comes with one ADC input pin (LRADC2 at connector 1). 
The low-level hardware driver registers itself to Linux's IIO subsystem
(Industrial I/O subsystem) and thus this ADC pin is available as following device:

  /sys/bus/iio/devices/iio:device0/in_voltage2_raw
