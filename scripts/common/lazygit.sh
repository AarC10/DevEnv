#!/bin/bash
# Install lazygit (upstream binary, not a repo)
set -euo pipefail
source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/../lib/common.sh"

log "Installing lazygit"
# Not in Fedora's repos. Installed from the upstream GitHub release binary
# rather than the atim/lazygit COPR, to avoid adding a third-party repo
# for one binary.
if command -v lazygit &>/dev/null; then
  echo "lazygit already installed, skipping."
  exit 0
fi
tag ver tmp
tag=$(curl -fsSL https://api.github.com/repos/jesseduffield/lazygit/releases/latest | grep '"tag_name"' | sed -E 's/.*"([^"]+)".*/\1/')
ver="${tag#v}"
tmp="/tmp/lazygit.tar.gz"
curl -fsSL -o "$tmp" "https://github.com/jesseduffield/lazygit/releases/download/${tag}/lazygit_${ver}_linux_x86_64.tar.gz"
mkdir -p "$USER_HOME/.local/bin"
tar -xzf "$tmp" -C /tmp lazygit
mv /tmp/lazygit "$USER_HOME/.local/bin/lazygit"
chmod +x "$USER_HOME/.local/bin/lazygit"
rm -f "$tmp"
