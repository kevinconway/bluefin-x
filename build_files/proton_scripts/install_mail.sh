#!/bin/bash

set -ouex pipefail

## See https://proton.me/support/mail-desktop-app

TMP="$(mktemp -d /var/cache/proton-mail.XXXXXX)"
trap 'rm -rf "$TMP"' EXIT
RPM="${TMP}/ProtonMail-desktop-beta.rpm"

wget -O "$RPM" https://proton.me/download/mail/linux/ProtonMail-desktop-beta.rpm
dnf5 install -y --setopt=tsflags=noscripts "$RPM"
