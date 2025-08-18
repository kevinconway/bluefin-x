#!/bin/bash

set -ouex pipefail

# Install ProtonVPN
"$(dirname "$0")/proton_scripts/install_vpn.sh"

# Install Windsurf repo
## See https://windsurf.com/download/editor for updates
rpm --import https://windsurf-stable.codeiumdata.com/wVxQEIWkwPUEAGf3/yum/RPM-GPG-KEY-windsurf
echo -e "[windsurf]
name=Windsurf Repository
baseurl=https://windsurf-stable.codeiumdata.com/wVxQEIWkwPUEAGf3/yum/repo/
enabled=1
autorefresh=1
gpgcheck=1
gpgkey=https://windsurf-stable.codeiumdata.com/wVxQEIWkwPUEAGf3/yum/RPM-GPG-KEY-windsurf" | tee /etc/yum.repos.d/windsurf.repo >/dev/null
dnf5 check-update --refresh windsurf && dnf5 install -y windsurf

dnf clean all
