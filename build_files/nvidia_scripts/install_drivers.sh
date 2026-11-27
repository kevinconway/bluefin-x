#!/bin/bash

set -ouex pipefail

# Hit a case where the fedora-multimedia repos were updated but the bluefin
# fedora base was not yet updated. Calling nvidia-install tries to install the
# mesa-*.i686 from fedora-multimedia which then ends up looking like a conflict.
# I think this resolves itself on the next bluefin image update but putting
# this here to workaround it for now. Update the mesa libs to their latest
# to prevent nvidia-install from having a conflict. zstd too.
dnf5 upgrade -y mesa-filesystem mesa-dri-drivers mesa-libEGL mesa-libGL mesa-libgbm mesa-vulkan-drivers zstd

# Attempt to recreate all the additions from the old dx-nvidia image but
# updated for Fedora 45 and using the open source nvidia drivers
IMAGE_NAME=silverblue /tmp/akmods-rpms/ublue-os/nvidia-install.sh
rm -f /usr/share/vulkan/icd.d/nouveau_icd.*.json
ln -sf libnvidia-ml.so.1 /usr/lib64/libnvidia-ml.so
dnf5 -y --enable-repo="copr:copr.fedorainfracloud.org:ublue-os:staging" install gnome-shell-extension-supergfxctl-gex
tee /usr/lib/modprobe.d/00-nouveau-blacklist.conf <<'EOF'
blacklist nouveau
options nouveau modeset=0
EOF
tee /usr/lib/bootc/kargs.d/00-nvidia.toml <<'EOF'
kargs = ["rd.driver.blacklist=nouveau", "modprobe.blacklist=nouveau", "nvidia-drm.modeset=1"]
EOF
if [[ -f /etc/modprobe.d/nvidia-modeset.conf ]]; then
	cp /etc/modprobe.d/nvidia-modeset.conf /usr/lib/modprobe.d/nvidia-modeset.conf
fi

KERNEL_VERSION="$(rpm -q --queryformat='%{VERSION}-%{RELEASE}.%{ARCH}' kernel-core)"
export DRACUT_NO_XATTR=1
dracut --no-hostonly --kver "$KERNEL_VERSION" --reproducible --add ostree \
	-f "/usr/lib/modules/$KERNEL_VERSION/initramfs.img"
chmod 0600 "/usr/lib/modules/$KERNEL_VERSION/initramfs.img"
