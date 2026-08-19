#!/bin/bash
# oh-my-zsh + powerlevel10k + MesloLGS NF font + chsh
set -euo pipefail
source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/../lib/common.sh"

log "Setting up Zsh + oh-my-zsh + powerlevel10k"

if [ ! -d "$USER_HOME/.oh-my-zsh" ]; then
  RUNZSH=no CHSH=no KEEP_ZSHRC=yes \
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi

if [ ! -d "$USER_HOME/powerlevel10k" ]; then
  git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$USER_HOME/powerlevel10k"
fi

# MesloLGS NF font (p10k's recommended font)
font_dir="$USER_HOME/.local/share/fonts/MesloLGS-NF"
if [ ! -d "$font_dir" ]; then
  mkdir -p "$font_dir"
  base="https://github.com/romkatv/powerlevel10k-media/raw/master"
  for f in "MesloLGS NF Regular.ttf" "MesloLGS NF Bold.ttf" "MesloLGS NF Italic.ttf" "MesloLGS NF Bold Italic.ttf"; do
    curl -fL -o "$font_dir/$f" "$base/${f// /%20}"
  done
  fc-cache -f "$font_dir"
fi

sudo chsh -s /usr/bin/zsh "$(whoami)"
echo "NOTE: chsh takes effect in NEW sessions only - existing open terminals"
echo "      keep whatever shell they were spawned with."
