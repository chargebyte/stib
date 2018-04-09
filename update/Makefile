#
# Copyright (c) 2018 I2SE GmbH
#

include meta-inf.mk
ifneq ($(PRODUCT),)
-include meta-inf-$(PRODUCT).mk
endif

# some internal variables
customerfs_tarball_fn:=customerfs.tar.bz2
updatefile_filename:=$(UPDATEFILE_PREFIX)$(VERSION)$(UPDATEFILE_SUFFIX)

define manifest_content:=
[update]
compatible=$(COMPATIBLE)
version=$(VERSION)

[hooks]
filename=hooks.sh

[image.rootfs]
filename=rootfs.ext4
hooks=pre-install;post-install

[image.customerfs]
filename=$(customerfs_tarball_fn)
hooks=pre-install;post-install
endef

all: publish/$(updatefile_filename)

.PHONY: clean
clean:
	rm -f bundle-staging/manifest.raucm bundle-staging/$(customerfs_tarball_fn)
	rm -f publish/*

export manifest_content
bundle-staging/manifest.raucm:
	echo "$$manifest_content" > $@

bundle-staging/$(customerfs_tarball_fn): $(wildcard customerfs/**/*)
	tar -caf $@ -C customerfs ./

publish/$(updatefile_filename): $(wildcard bundle-staging/*-install.d/*) bundle-staging/manifest.raucm bundle-staging/$(customerfs_tarball_fn) bundle-staging/rootfs.ext4 bundle-staging/hooks.sh
	mkdir -p publish
	rauc bundle --cert=pki/rauc.crt --key=pki/rauc.key bundle-staging publish/tmp.raucb
	mv publish/tmp.raucb $@

self-signed-demo-key: pki/rauc.key pki/rauc.crt

pki/rauc.key pki/rauc.crt:
	mkdir -p pki
	openssl req -x509 -newkey rsa:4096 -nodes -days 1024 -keyout pki/rauc.key -out pki/rauc.crt -subj "/O=STIB/CN=rauc"
