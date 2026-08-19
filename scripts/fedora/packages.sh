#!/bin/bash
# All dnf5 package installs, consolidated (includes zsh, ESP-IDF build deps)
set -euo pipefail
source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/../lib/common.sh"

log "Installing system packages (dnf5)"
# SDL2-devel got renamed to sdl2-compat-devel on Fedora.
# No plugdev group here (Debian/Ubuntu thing) - stlink's udev rules handle
# that probe, dialout covers everything else.
# gcc/g++/make aren't part of the Zephyr SDK (ARM toolchain only), needed
# for `cargo install just` etc.
# .i686 libs are for Zephyr's native_sim board, which builds 32-bit.
# openocd's package already ships 60-openocd.rules, no manual copy needed.
# libusb1-devel is for building hidapi (pulled in by spsdk, see
# scripts/common/embedded-pip.sh) - no prebuilt wheel for it here.
sudo dnf5 install -y \
  gcc gcc-c++ make clang-tools-extra \
  zsh cmake ninja-build ccache dfu-util python3-pip \
  stlink openocd \
  glibc-devel.i686 libgcc.i686 libstdc++-devel.i686 libatomic.i686 \
  libpcap-devel libusb1-devel \
  sdl2-compat-devel \
  fortune-mod cowsay \
  git curl wget \
  dnf5-plugins \
  fontconfig \
  eza neovim fd-find zoxide git-delta \
  webkit2gtk4.1-devel openssl-devel libappindicator-gtk3-devel \
  librsvg2-devel systemd-devel patchelf

log "Adding aaron to dialout group (serial/USB device access)"
sudo usermod -aG dialout "$(whoami)"
