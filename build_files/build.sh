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
  "$(dirname "$0")/nvidia_scripts/install_drivers.sh"
fi

dnf clean all
rm -rf /var/lib/dnf/repos
