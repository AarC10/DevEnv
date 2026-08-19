#!/bin/bash
# Fedora/KDE dev environment - runs everything in scripts/fedora and
# scripts/common, in order. Each script also runs standalone:
#
#   sudo -v                          # cache your password once
#   bash install.sh                   # everything
#   bash scripts/common/rust.sh        # just one thing
#
# Safe to re-run - each script skips whatever it already did.

set -euo pipefail
REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

run() { echo -e "\n### $1"; bash "$REPO_ROOT/$1"; }

run scripts/fedora/packages.sh
run scripts/common/flatpaks.sh
run scripts/fedora/vscode.sh
run scripts/common/vscode-extensions.sh
run scripts/common/jetbrains-toolbox.sh
run scripts/fedora/docker.sh
run scripts/common/zsh.sh
run scripts/fedora/konsole.sh
run scripts/common/rsed.sh
run scripts/common/eza-aliases.sh
run scripts/common/git-extras.sh
run scripts/common/gdb-dashboard.sh
run scripts/common/dev-folders.sh
run scripts/common/rust.sh
run scripts/common/go.sh
run scripts/common/node.sh
run scripts/common/just.sh
run scripts/common/probe-rs.sh
run scripts/common/ai-clis.sh
run scripts/common/lazygit.sh
run scripts/common/python-modern.sh
run scripts/common/zoxide-delta-config.sh
run scripts/common/lazyvim.sh
run scripts/fedora/spectacle.sh
run scripts/common/zephyr.sh
run scripts/common/python-ml.sh
run scripts/common/embedded-pip.sh
run scripts/common/zshrc.sh
run scripts/common/repos.sh
run scripts/fedora/grub-theme.sh
run scripts/fedora/kde-layout.sh

echo -e "\n### Done. Log out and back in (or reboot) to pick up: default shell, docker group, dialout group."
echo "Not run above, do these yourself if wanted:"
echo "  - scripts/common/esp-idf.sh, android-studio.sh, scripts/fedora/spicetify.sh (bigger/optional)"
echo "  - JetBrains IDEs: install through the Toolbox GUI, no scripted path for that part"
echo "  - SEGGER J-Link: https://www.segger.com/downloads/jlink/ (license-gated)"
echo "  - STM32CubeProgrammer/CubeMX: https://www.st.com/en/development-tools/ (free ST account)"
echo "  - OPENAI_API_KEY: add by hand to ~/.config/secrets/env.zsh, not in this repo"
