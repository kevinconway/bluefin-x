#!/bin/bash

set -ouex pipefail

# Install ProtonVPN
"$(dirname "$0")/proton_scripts/install_vpn.sh"

# Install Proton Mail Bridge
"$(dirname "$0")/proton_scripts/install_bridge.sh"

# Install Proton Mail/Calendar desktop app
"$(dirname "$0")/proton_scripts/install_mail.sh"

# Install Proton Drive CLI
"$(dirname "$0")/proton_scripts/install_drive_cli.sh"

# Install .NET SDK
dnf5 install -y dotnet-sdk-10.0

# Install NVIDIA drivers. No-op unless Containerfile.nvidia bind-mounts the
# akmods-nvidia-open RPMs at /tmp/akmods-rpms (see ublue-os/image-template
# "Adding NVIDIA drivers"). Must run before the dnf cache cleanup below.
if [[ -d /tmp/akmods-rpms ]]; then
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
fi

dnf clean all
rm -rf /var/lib/dnf/repos
