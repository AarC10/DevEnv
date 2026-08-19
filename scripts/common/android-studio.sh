#!/bin/bash
# Install Android Studio
set -euo pipefail
source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/../lib/common.sh"

log "Installing Android Studio"
install_dir="$USER_HOME/.local/opt"
if [ -d "$install_dir/android-studio" ]; then
  echo "  Android Studio already installed, skipping."
  exit 0
fi
mkdir -p "$install_dir"
tmp="/tmp/android-studio.tar.gz"
curl -fL -o "$tmp" \
  "https://redirector.gvt1.com/edgedl/android/studio/ide-zips/2024.3.2.14/android-studio-2024.3.2.14-linux.tar.gz"
tar -xzf "$tmp" -C "$install_dir"
rm -f "$tmp"
echo "NOTE: launch $install_dir/android-studio/bin/studio.sh once by hand to"
echo "      finish first-run setup and install the Android SDK."
