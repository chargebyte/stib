General information
===================

This BSP consists of several software components:

* Bootloader: Freescale imx-bootlets (based on 10.12.01)
* Linux kernel (based on v4.4.34)
* Root file system (based on Debian Jessie)

Important note: This BSP does not contain an ISO 15118 software stack.

.. note::

    The EVAcharge SE was formerly shipped with a manually created BSP.
    The versioning was based on simple numbers with prefix, e.g. R04.
    By switching to STIB, the STIB based version numbers (tags) are now
    used, e.g. v1.5.
