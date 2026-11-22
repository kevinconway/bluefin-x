#!/bin/bash

set -ouex pipefail

# Install ProtonVPN
"$(dirname "$0")/proton_scripts/install_vpn.sh"

# Install Proton Mail Bridge
"$(dirname "$0")/proton_scripts/install_bridge.sh"

# Install Proton Mail/Calendar desktop app
"$(dirname "$0")/proton_scripts/install_mail.sh"

# Install .NET SDK
dnf5 install -y dotnet-sdk-10.0

dnf clean all
