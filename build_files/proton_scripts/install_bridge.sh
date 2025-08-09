#!/bin/bash

set -euo pipefail

# Install Proton Bridge
## See https://proton.me/support/install-bridge-linux-rpm-file for updates
wget https://proton.me/download/bridge/protonmail-bridge-3.13.0-1.x86_64.rpm
dnf5 install -y ./protonmail-bridge-3.13.0-1.x86_64.rpm
