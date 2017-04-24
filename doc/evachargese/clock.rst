Clock
=====

After a cold boot the real-time clock (RTC) of the i.MX28 lose its setting and needs to be reinitialized with current time.

New EVAcharge SE factory images (r07 and later) already contains a NTP daemon which could fetch the current time from the internet. But this requires a working network configuration with a gateway and at least 1 DNS server. So please follow the `Debian network documentation`_.

.. _Debian network documentation: https://wiki.debian.org/NetworkConfiguration

As per default the NTP daemon is preconfigured for the following servers:

- 0.debian.pool.ntp.org
- 1.debian.pool.ntp.org
- 2.debian.pool.ntp.org
- 3.debian.pool.ntp.org

The NTP configuration itself is located in this file::

  /etc/ntp.conf

Please refer to the `Debian NTP documentation`_ and `NTP pool project`_ for more information.

.. _Debian NTP documentation: https://wiki.debian.org/NTP
.. _NTP pool project: http://www.pool.ntp.org/

