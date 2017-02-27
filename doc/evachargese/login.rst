Login
=====

To get shell access to the EVAcharge SE, you can connect to the device via network
using SSH protocol, or locally by using the Debug UART (e.g. by using an
USB-to-UART adapter with 3.3 V-level).

At both methods, a login prompt is presented. Default credentials are:

* username *root*
* password *zebematado*

To use SSH, the SSH server needs an individual, random SSH host key. During
manufacturing, all EVAcharge SE are programmed with such a key. However, the
MfgTool images up to version r04 provided via I2SE's website to restore a broken
EVAcharge SE factory image, did *not* contain a SSH host key for security reasons.
A missing SSH host key results in refused connections by the SSH
server ("Connection reset by peer.").
Thus the user has to trigger the creation of such an individual key via
Debug UART after restoring the EVAcharge SE image::

  # delete all existing/left-over SSH host keys
  rm -f /etc/ssh/ssh_host_*
  
  # reconfigure OpenSSH server via Debian's package management will trigger key re-creation
  dpkg-reconfigure openssh-server

For newer EVAcharge SE factory images (r07 and later), this issue has been fixed
using an additional boot script: the required SSH host keys are generated
automatically during the first boot, so no further user action is required.
