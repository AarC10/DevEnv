#!/bin/bash
# Install JetBrains Toolbox
set -euo pipefail
source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/../lib/common.sh"

log "Installing JetBrains Toolbox"
install_dir="$USER_HOME/.local/opt"
if compgen -G "$install_dir/jetbrains-toolbox-*" >/dev/null; then
  echo "JetBrains Toolbox already extracted, skipping download."
else
  mkdir -p "$install_dir" "$USER_HOME/Downloads"
  tmp="$USER_HOME/Downloads/jetbrains-toolbox.tar.gz"
  curl -fL --retry 5 -o "$tmp" \
    "https://download.jetbrains.com/toolbox/jetbrains-toolbox-2.6.4.53961.tar.gz"
  tar -xzf "$tmp" -C "$install_dir"
fi
echo "NOTE: Toolbox needs one manual GUI launch to finish setup and create"
echo "      the ~/.local/bin symlinks for individual IDEs - run"
echo "      $install_dir/jetbrains-toolbox-*/jetbrains-toolbox by hand once."
