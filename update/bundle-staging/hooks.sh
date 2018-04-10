#!/bin/sh

env | logger

case "$1" in
	install-check)
		if [ "$RAUC_MF_COMPATIBLE" != "$RAUC_SYSTEM_COMPATIBLE" ]; then
			echo "Compatible does not match!" 1>&2
			exit 10
		fi
		;;

	slot-pre-install)
		/bin/run-parts --lsbsysinit -a "$RAUC_SLOT_CLASS" -a "$RAUC_SLOT_MOUNT_POINT" -a "$RAUC_MOUNT_PREFIX/bundle" -- "$RAUC_MOUNT_PREFIX/bundle/pre-install.d"
		;;

	slot-post-install)
		/bin/run-parts --lsbsysinit -a "$RAUC_SLOT_CLASS" -a "$RAUC_SLOT_MOUNT_POINT" -a "$RAUC_MOUNT_PREFIX/bundle" -- "$RAUC_MOUNT_PREFIX/bundle/post-install.d"
		;;

	*)
		exit 1
		;;
esac

exit 0