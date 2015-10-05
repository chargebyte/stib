all: create-dirs feed-cache multistrap update-cache create-devs

create-dirs:
	mkdir -p rootfs
	mkdir -p debcache

multistrap:
	sudo multistrap -f multistrap.conf

update-cache:
	sudo cp -a rootfs/var/cache/apt debcache/

feed-cache:
	sudo mkdir -p rootfs/var/cache/apt
	-sudo cp -a debcache/* rootfs/var/cache/apt/

create-devs:
	sudo /usr/share/multistrap/device-table.pl --no-fakeroot -d rootfs -f device_table.txt
