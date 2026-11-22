#!/bin/bash

set -ouex pipefail

# See https://protonvpn.com/support/official-linux-vpn-fedora
FEDORA_VER="$(cut -d' ' -f3 /etc/fedora-release)"
REPO_DIR="https://repo.protonvpn.com/fedora-${FEDORA_VER}-stable/protonvpn-stable-release"
RPM="$(wget -qO- "${REPO_DIR}/" \
    | grep -oE 'protonvpn-stable-release-[0-9]+\.[0-9]+\.[0-9]+-[0-9]+\.noarch\.rpm' \
    | sort -uV | tail -1)"
test -n "$RPM"
wget "${REPO_DIR}/${RPM}"
dnf5 install -y "./${RPM}"
dnf5 check-update --refresh proton-vpn-gnome-desktop && dnf5 install -y --setopt=tsflags=noscripts proton-vpn-gnome-desktop proton-vpn-cli
