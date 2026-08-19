#!/bin/bash
# ESP-IDF (ESP32 toolchain)
set -euo pipefail
source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/../lib/common.sh"

log "Installing ESP-IDF (ESP32 toolchain)"
# Needs cmake, ninja-build, ccache, dfu-util, python3-pip already installed
# (fedora/packages.sh covers these on Fedora).
idf_dir="$USER_HOME/esp/esp-idf"
if [ -d "$idf_dir" ]; then
  echo "  ESP-IDF already cloned, skipping."
  exit 0
fi
mkdir -p "$USER_HOME/esp"
git clone -b v5.3.1 --recursive https://github.com/espressif/esp-idf.git "$idf_dir"
( cd "$idf_dir" && ./install.sh esp32,esp32s3,esp32c3 )
echo "NOTE: 'get_idf' alias (. \$HOME/esp/esp-idf/export.sh) needs adding to"
echo "      .zshrc if you want it - not included by default to avoid"
echo "      slowing down every shell startup with an unconditional source."
