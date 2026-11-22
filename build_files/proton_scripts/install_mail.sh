#!/bin/bash

set -ouex pipefail

## See https://proton.me/support/mail-desktop-app
wget https://proton.me/download/mail/linux/ProtonMail-desktop-beta.rpm
dnf5 install -y --setopt=tsflags=noscripts ./ProtonMail-desktop-beta.rpm
