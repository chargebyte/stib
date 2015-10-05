#!/bin/sh

export DEBIAN_FRONTEND=noninteractive DEBCONF_NONINTERACTIVE_SEEN=true
export LC_ALL=C LANGUAGE=C LANG=C
export PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"

/var/lib/dpkg/info/dash.preinst install

dpkg --configure -a

mount proc -t proc /proc

dpkg --configure -a

mv /sbin/init.orig /sbin/init
exec /sbin/init
