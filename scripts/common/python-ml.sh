#!/bin/bash
# Python AI/ML packages (CPU-only torch)
set -euo pipefail
source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/../lib/common.sh"

log "Installing Python AI/ML packages"
# CPU-only torch index - this machine has no NVIDIA GPU (AMD iGPU only).
# Using the default index pulls several GB of unused CUDA packages.
pip3 install --user --break-system-packages -U \
  matplotlib numpy opencv-python
pip3 install --user --break-system-packages -U \
  torch torchvision --index-url https://download.pytorch.org/whl/cpu
