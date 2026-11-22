#!/bin/bash

set -ouex pipefail

# See https://proton.me/support/drive-cli and
# https://proton.me/download/drive/cli/index.html
DRIVE_CLI_VER="0.9.0"
DRIVE_CLI_SHA512="3533025ba69ae112b64e3e01fbcc1ad0688136a4043f6cf6a72886967d85fdcd9ec235479c2e113171614be5225bfba93427509a05ca5aa6071d924fa7e91ca8"

# Download to TMP to avoid the download showing up in the docker image layer
TMP="$(mktemp -d /var/cache/proton-drive.XXXXXX)"
trap 'rm -rf "$TMP"' EXIT
wget -O "${TMP}/proton-drive" \
    "https://proton.me/download/drive/cli/${DRIVE_CLI_VER}/linux-x64/proton-drive"
echo "${DRIVE_CLI_SHA512}  ${TMP}/proton-drive" | sha512sum --check
install -Dm755 "${TMP}/proton-drive" /usr/local/bin/proton-drive

# libsecret is a dependency of the CLI
dnf5 install -y libsecret
