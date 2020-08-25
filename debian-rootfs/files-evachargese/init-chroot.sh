#!/bin/sh

export DEBIAN_FRONTEND=noninteractive DEBCONF_NONINTERACTIVE_SEEN=true
export LC_ALL=C LANGUAGE=C LANG=C
export PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"

# https://wiki.debian.org/Multistrap
/var/lib/dpkg/info/dash.preinst install

# process preseeds
if [ -d /tmp/preseeds/ ]; then
        for file in `ls -1 /tmp/preseeds/*`; do
                debconf-set-selections $file
        done
fi

# configure the debian system
dpkg --configure -a
mount proc -t proc /proc
dpkg --configure -a

# default password
sed -i -e 's/root:\*:/root:$6$JrFWa6qL$Rthf9\/1SpixCHEHtqBxaGXX3WBEVgPzuMra7P7BxJtnbYo.C.qLsoenVK9iL1ta853zNwhBPZeYNK8BqW\/zzT.:/' /etc/shadow

# empty machine-id
: > /etc/machine-id
chmod 444 /etc/machine-id
