#!/bin/bash
# Zephyr SDK + west (global, no venv)
set -euo pipefail
source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/../lib/common.sh"

log "Installing Zephyr SDK + west (global, no venv)"
# west + Zephyr's Python deps are installed globally with --user so `west`
# works in any plain shell, no venv activation needed. --break-system-packages
# is required on Fedora due to PEP 668.
pip3 install --user --break-system-packages -U west

sdk_version="0.17.4"
sdk_dir="$USER_HOME/zephyr-sdk"
if [ ! -d "$sdk_dir" ]; then
  tmp="/tmp/zephyr-sdk.tar.xz"
  curl -fL -o "$tmp" \
    "https://github.com/zephyrproject-rtos/sdk-ng/releases/download/v${sdk_version}/zephyr-sdk-${sdk_version}_linux-x86_64_minimal.tar.xz"
  tar -xJf "$tmp" -C "$USER_HOME"
  mv "$USER_HOME/zephyr-sdk-${sdk_version}" "$sdk_dir"
  rm -f "$tmp"
  ( cd "$sdk_dir" && ./setup.sh -t arm-zephyr-eabi -c -h )
fi
