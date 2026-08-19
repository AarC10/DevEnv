#!/bin/bash
# NXP/GNSS/J-Link Python tooling (spsdk, imgtool, etc.)
set -euo pipefail
source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/../lib/common.sh"

log "Installing embedded-adjacent Python tooling"
# spsdk provides blhost/sdphost/nxpimage/nxpuuu/dk6prog/etc as console
# scripts (NXP MCU bootloader + provisioning tooling).
# imgtool: MCUboot image signing (Zephyr-adjacent).
# pygnssutils + pyubx2: u-blox GNSS tooling (gnssstreamer, ubxsave, etc).
# pylink-square: SEGGER J-Link Python bindings.
# Needs libusb1-devel installed first (fedora/packages.sh) - spsdk pulls in
# hidapi, which builds from source against libusb-1.0 here (no wheel).
pip3 install --user --break-system-packages -U \
  spsdk imgtool pygnssutils pyubx2 pylink-square
