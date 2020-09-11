#!/bin/sh

rauc_get_other_fs_device() {
	local i

	eval $(rauc status --output-format=shell 2>/dev/null)

	for i in $RAUC_SLOTS; do
		eval state=\$RAUC_SLOT_STATE_$i
		eval class=\$RAUC_SLOT_CLASS_$i
		eval device=\$RAUC_SLOT_DEVICE_$i

		# we only look at rootfs class
		[ "$class" = "$1" ] || continue

		# we want to determine the inactive slot
		[ "$state" = "inactive" ] || continue

		echo "$device"
		break
	done
}

rauc_get_other_rootfs_device() {
	rauc_get_other_fs_device "rootfs"
}

rauc_get_other_customerfs_device() {
	rauc_get_other_fs_device "customerfs"
}
