#!/bin/bash

set -ouex pipefail

## See https://proton.me/support/bridge-for-linux and
## https://proton.me/support/verifying-bridge-package
rpm --import https://proton.me/download/bridge/bridge_pubkey.gpg

TMP="$(mktemp -d /var/cache/proton-bridge.XXXXXX)"
trap 'rm -rf "$TMP"' EXIT
RPM="${TMP}/protonmail-bridge.x86_64.rpm"

wget -O "$RPM" https://proton.me/download/bridge/protonmail-bridge.x86_64.rpm
dnf5 install -y --setopt=tsflags=noscripts "$RPM"
