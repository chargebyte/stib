.. Duckbill BSP documentation master file, created by
   sphinx-quickstart on Tue Jan 19 10:19:44 2016.
   You can adapt this file completely to your liking, but it should at least
   contain the root `toctree` directive.


Duckbill Board Support Package
==============================

This document helps you to get familiar with the Board Support Package of Duckbill,
that is the default firmware which is pre-installed on the internal eMMC on
Duckbill 2 based devices or can be flashed to SD cards (for former Duckbills).

This document only describes the Board Support Package revision 2.x; the former
Board Support packages are not supported anymore. We strongly recommend to
upgrade your application to this new BSP since it is much simpler than the former
one.

Since Duckbill and Duckbill 2 are very similar, this document focuses the differences
only where really needed. In all other cases, there is no weighting on this point.

It is assumed, that the reader is at least familiar with Linux on desktop systems.

This BSP documentation applies to several product variants:

* :ref:`duckbill-2`
* :ref:`duckbill-2-485`
* :ref:`duckbill-2-enocean`

.. _duckbill-2:

Duckbill 2
----------

.. toctree::
   :maxdepth: 2

   general
   duckbill-2_pin-muxing
   login
   duckbill-2_leds
   uarts
   i2c
   adc
   networking
   partitions
   duckbill-2_preinstalled-packages
   faqs
   sources

.. _duckbill-2-485:

Duckbill 2 485/Duckbill 2 485+
------------------------------

.. toctree::
   :maxdepth: 2

   general
   login
   duckbill-2_rs485_leds
   duckbill-2_rs485_uarts
   networking
   partitions
   faqs
   sources

.. _duckbill-2-enocean:

Duckbill 2 EnOcean
------------------------------

.. toctree::
   :maxdepth: 2

   general
   login
   duckbill-2_enocean_leds
   duckbill-2_enocean_uarts
   networking
   partitions
   faqs
   sources
