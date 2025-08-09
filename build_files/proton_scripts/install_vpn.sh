#!/bin/bash

set -ouex pipefail

## See https://protonvpn.com/support/official-linux-vpn-fedora for updates
wget "https://repo.protonvpn.com/fedora-$(cat /etc/fedora-release | cut -d' ' -f 3)-stable/protonvpn-stable-release/protonvpn-stable-release-1.0.3-1.noarch.rpm"
dnf5 install -y ./protonvpn-stable-release-1.0.3-1.noarch.rpm
dnf5 check-update --refresh proton-vpn-gnome-desktop && dnf5 install -y proton-vpn-gnome-desktop
