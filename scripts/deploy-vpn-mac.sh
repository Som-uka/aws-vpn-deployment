#!/usr/bin/env bash
#
# deploy-vpn-mac.sh
# Installs the AWS VPN Client on macOS, verifying the installer against a
# known-good SHA256 before running. Distributed via the Mac MDM channel.
#
# Note: hash and URL are placeholders; pinned to the approved version in a
# real deployment. Run as root.
set -euo pipefail

INSTALLER_URL="<approved-aws-vpn-client-pkg-url>"
EXPECTED_HASH="<sha256-of-approved-pkg>"     # lowercase hex
PKG_PATH="/tmp/aws-vpn-client.pkg"
PROFILE_SOURCE="<managed-connection-profile-path>"
PROFILE_DEST="/Library/Application Support/AWSVPNClient/ConfigurationFiles/summit.ovpn"

echo "Downloading AWS VPN Client package..."
curl -fsSL "$INSTALLER_URL" -o "$PKG_PATH"

echo "Verifying package integrity..."
ACTUAL=$(shasum -a 256 "$PKG_PATH" | awk '{print $1}')
if [[ "$ACTUAL" != "$EXPECTED_HASH" ]]; then
  echo "Hash mismatch. Expected $EXPECTED_HASH, got $ACTUAL. Aborting." >&2
  exit 1
fi

echo "Hash verified. Installing..."
installer -pkg "$PKG_PATH" -target /

echo "Deploying managed connection profile..."
mkdir -p "$(dirname "$PROFILE_DEST")"
cp "$PROFILE_SOURCE" "$PROFILE_DEST"

echo "AWS VPN Client deployment complete."
