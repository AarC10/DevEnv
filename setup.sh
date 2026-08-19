#!/bin/bash
# Framework laptop / Fedora KDE dev environment setup.
# Idempotent-ish: safe to re-run. Each section skips or overwrites cleanly
# rather than failing on "already exists".
#
# Usage:
#   sudo -v                      # cache sudo once up front
#   bash setup.sh                # runs everything
#   bash setup.sh <section_name> # run just one section, e.g. `bash setup.sh zephyr`
#
# Toggle these off if you don't want them re-applied on a re-run:
DO_GRUB_THEME=true
DO_DESKTOP_LAYOUT=true
DO_CLONE_REPOS=true
DO_ESP_IDF=true
DO_ANDROID_STUDIO=true
DO_SPICETIFY=true

set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
USER_HOME="$HOME"
DEV="$USER_HOME/Development"

log() { echo -e "\n==> $*"; }

# ---------------------------------------------------------------------------
section_packages() {
  log "Installing system packages (dnf5)"
  # Notes from bring-up:
  # - Fedora renamed SDL2-devel -> sdl2-compat-devel.
  # - No 'plugdev' group on Fedora (that's Debian/Ubuntu only); stlink's own
  #   udev rules already grant 0666 access, dialout covers generic serial.
  # - gcc/g++/make are NOT pulled in by the Zephyr SDK (that's only the ARM
  #   cross toolchain) - `cargo install just` and friends need a host compiler.
  # - The four .i686 packages are only needed for Zephyr's native_sim board,
  #   which builds a 32-bit binary even on a 64-bit-only base install.
  # - openocd's dnf package ships /usr/lib/udev/rules.d/60-openocd.rules
  #   itself (confirmed via `dnf5 repoquery -l openocd`) - no need to hand-copy
  #   the upstream rules file separately.
  # - libusb1-devel is needed to build the 'hidapi' wheel that spsdk pulls in
  #   (see section_embedded_pip) - no prebuilt wheel for it on this Python.
  sudo dnf5 install -y \
    gcc gcc-c++ make clang-tools-extra \
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
}

# ---------------------------------------------------------------------------
section_flatpaks() {
  log "Setting up Flathub + flatpak apps"
  flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
  flatpak install -y --noninteractive flathub \
    com.spotify.Client \
    com.slack.Slack \
    com.discordapp.Discord
}

# ---------------------------------------------------------------------------
section_vscode() {
  log "Installing VS Code"
  # dnf's own repo download of the VS Code RPM has repeatedly failed
  # mid-transfer (Curl error 56, connection reset ~330MB in) on this network.
  # Downloading directly with curl (resumable, retries) and installing the
  # local RPM sidesteps it.
  if rpm -q code &>/dev/null; then
    echo "VS Code already installed, skipping."
    return
  fi
  sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
  sudo tee /etc/yum.repos.d/vscode.repo >/dev/null <<'EOF'
[code]
name=Visual Studio Code
baseurl=https://packages.microsoft.com/yumrepos/vscode
enabled=1
gpgcheck=1
gpgkey=https://packages.microsoft.com/keys/microsoft.asc
EOF
  local tmp="/tmp/vscode.rpm"
  curl -fL --retry 10 --retry-delay 3 --retry-all-errors -C - \
    -o "$tmp" \
    "https://code.visualstudio.com/sha/download?build=stable&os=linux-rpm-x64"
  sudo dnf5 install -y "$tmp"
  rm -f "$tmp"
}

# ---------------------------------------------------------------------------
section_jetbrains_toolbox() {
  log "Installing JetBrains Toolbox"
  local install_dir="$USER_HOME/.local/opt"
  if compgen -G "$install_dir/jetbrains-toolbox-*" >/dev/null; then
    echo "JetBrains Toolbox already extracted, skipping download."
  else
    mkdir -p "$install_dir" "$USER_HOME/Downloads"
    local tmp="$USER_HOME/Downloads/jetbrains-toolbox.tar.gz"
    curl -fL --retry 5 -o "$tmp" \
      "https://download.jetbrains.com/toolbox/jetbrains-toolbox-2.6.4.53961.tar.gz"
    tar -xzf "$tmp" -C "$install_dir"
  fi
  echo "NOTE: Toolbox needs one manual GUI launch to finish setup and create"
  echo "      the ~/.local/bin symlinks for individual IDEs - run"
  echo "      $install_dir/jetbrains-toolbox-*/jetbrains-toolbox by hand once."
}

# ---------------------------------------------------------------------------
section_docker() {
  log "Installing Docker CE"
  if command -v docker &>/dev/null; then
    echo "Docker already installed, skipping repo setup."
  else
    sudo dnf5 config-manager addrepo --from-repofile=https://download.docker.com/linux/fedora/docker-ce.repo
    sudo dnf5 install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
  fi
  sudo systemctl enable --now docker
  sudo usermod -aG docker "$(whoami)"
}

# ---------------------------------------------------------------------------
section_zsh() {
  log "Setting up Zsh + oh-my-zsh + powerlevel10k"
  sudo dnf5 install -y zsh

  if [ ! -d "$USER_HOME/.oh-my-zsh" ]; then
    RUNZSH=no CHSH=no KEEP_ZSHRC=yes \
      sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
  fi

  if [ ! -d "$USER_HOME/powerlevel10k" ]; then
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$USER_HOME/powerlevel10k"
  fi

  # MesloLGS NF font (p10k's recommended font)
  local font_dir="$USER_HOME/.local/share/fonts/MesloLGS-NF"
  if [ ! -d "$font_dir" ]; then
    mkdir -p "$font_dir"
    local base="https://github.com/romkatv/powerlevel10k-media/raw/master"
    for f in "MesloLGS NF Regular.ttf" "MesloLGS NF Bold.ttf" "MesloLGS NF Italic.ttf" "MesloLGS NF Bold Italic.ttf"; do
      curl -fL -o "$font_dir/$f" "$base/${f// /%20}"
    done
    fc-cache -f "$font_dir"
  fi

  sudo chsh -s /usr/bin/zsh "$(whoami)"
  echo "NOTE: chsh takes effect in NEW sessions only - existing open terminals"
  echo "      keep whatever shell they were spawned with."
}

# ---------------------------------------------------------------------------
section_konsole() {
  log "Configuring Konsole (MesloLGS profile, default shell, transparency)"
  mkdir -p "$USER_HOME/.local/share/konsole"
  cp "$SCRIPT_DIR/konsole/MesloLGS.profile" "$USER_HOME/.local/share/konsole/MesloLGS.profile"

  mkdir -p "$USER_HOME/.config"
  local konsolerc="$USER_HOME/.config/konsolerc"
  if [ -f "$konsolerc" ] && grep -q "^\[Desktop Entry\]" "$konsolerc"; then
    sed -i 's/^DefaultProfile=.*/DefaultProfile=MesloLGS.profile/' "$konsolerc"
  else
    { echo "[Desktop Entry]"; echo "DefaultProfile=MesloLGS.profile"; echo; cat "$konsolerc" 2>/dev/null; } > "$konsolerc.tmp"
    mv "$konsolerc.tmp" "$konsolerc"
  fi
}

# ---------------------------------------------------------------------------
section_rsed() {
  log "Installing rsed"
  mkdir -p "$USER_HOME/.local/bin"
  cp "$SCRIPT_DIR/custom_scripts/rsed" "$USER_HOME/.local/bin/rsed"
  chmod +x "$USER_HOME/.local/bin/rsed"
}

# ---------------------------------------------------------------------------
section_dev_folders() {
  log "Creating ~/Development structure"
  mkdir -p "$DEV/WildWestRocketry" "$DEV/Launch" "$DEV/AarC10" "$DEV/dotfiles"
}

# ---------------------------------------------------------------------------
section_rust() {
  log "Installing Rust (rustup)"
  if command -v rustc &>/dev/null; then
    echo "Rust already installed, skipping."
    return
  fi
  curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y --no-modify-path
}

# ---------------------------------------------------------------------------
section_go() {
  log "Installing Go (manual tarball, avoids sudo/system dirs)"
  local go_version="1.26.6"
  if [ -x "$USER_HOME/.local/go/bin/go" ]; then
    echo "Go already installed, skipping."
    return
  fi
  local tmp="/tmp/go.tar.gz"
  curl -fL -o "$tmp" "https://go.dev/dl/go${go_version}.linux-amd64.tar.gz"
  rm -rf "$USER_HOME/.local/go"
  tar -C "$USER_HOME/.local" -xzf "$tmp"
  rm -f "$tmp"
  mkdir -p "$USER_HOME/go/bin"
}

# ---------------------------------------------------------------------------
section_node() {
  log "Installing nvm + corepack/pnpm"
  if [ ! -d "$USER_HOME/.nvm" ]; then
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash
  fi
  export NVM_DIR="$USER_HOME/.nvm"
  # shellcheck disable=SC1091
  source "$NVM_DIR/nvm.sh"
  nvm install --lts
  corepack enable
  corepack prepare pnpm@latest --activate
}

# ---------------------------------------------------------------------------
section_just() {
  log "Installing 'just' command runner"
  export PATH="$USER_HOME/.cargo/bin:$PATH"
  if command -v just &>/dev/null; then
    echo "just already installed, skipping."
    return
  fi
  cargo install just
}

# ---------------------------------------------------------------------------
section_probe_rs() {
  log "Installing probe-rs-tools (cargo-embed, cargo-flash, probe-rs)"
  export PATH="$USER_HOME/.cargo/bin:$PATH"
  if command -v probe-rs &>/dev/null; then
    echo "probe-rs already installed, skipping."
    return
  fi
  cargo install probe-rs-tools
}

# ---------------------------------------------------------------------------
section_ai_clis() {
  log "Installing OpenAI Codex CLI + Gemini CLI"
  export NVM_DIR="$USER_HOME/.nvm"
  # shellcheck disable=SC1091
  source "$NVM_DIR/nvm.sh"
  npm install -g @openai/codex @google/gemini-cli
}

# ---------------------------------------------------------------------------
section_lazygit() {
  log "Installing lazygit"
  # Not in Fedora's repos. Installed from the upstream GitHub release binary
  # rather than the atim/lazygit COPR, to avoid adding a third-party repo
  # for one binary.
  if command -v lazygit &>/dev/null; then
    echo "lazygit already installed, skipping."
    return
  fi
  local tag ver tmp
  tag=$(curl -fsSL https://api.github.com/repos/jesseduffield/lazygit/releases/latest | grep '"tag_name"' | sed -E 's/.*"([^"]+)".*/\1/')
  ver="${tag#v}"
  tmp="/tmp/lazygit.tar.gz"
  curl -fsSL -o "$tmp" "https://github.com/jesseduffield/lazygit/releases/download/${tag}/lazygit_${ver}_linux_x86_64.tar.gz"
  mkdir -p "$USER_HOME/.local/bin"
  tar -xzf "$tmp" -C /tmp lazygit
  mv /tmp/lazygit "$USER_HOME/.local/bin/lazygit"
  chmod +x "$USER_HOME/.local/bin/lazygit"
  rm -f "$tmp"
}

# ---------------------------------------------------------------------------
section_python_modern() {
  log "Installing ruff + uv"
  pip3 install --user --break-system-packages -U ruff
  curl -LsSf https://astral.sh/uv/install.sh | sh
}

# ---------------------------------------------------------------------------
section_zoxide_delta_config() {
  log "Wiring zoxide into the shell + delta into git"
  # zoxide's shell hook goes directly in the .zshrc heredoc below (see
  # 'zoxide init zsh' line) - this section only handles the git side, which
  # is global config rather than a file template.
  git config --global core.pager "delta"
  git config --global interactive.diffFilter "delta --color-only"
  git config --global delta.navigate true
  git config --global delta.side-by-side true
  git config --global merge.conflictstyle diff3
  git config --global diff.colorMoved default
}

# ---------------------------------------------------------------------------
section_lazyvim() {
  log "Installing LazyVim (Neovim starter config)"
  if [ -d "$USER_HOME/.config/nvim/lua" ]; then
    echo "  ~/.config/nvim already has a config, skipping (won't overwrite)."
    return
  fi
  git clone https://github.com/LazyVim/starter "$USER_HOME/.config/nvim"
  rm -rf "$USER_HOME/.config/nvim/.git"
  # Pre-bootstraps plugins + compiles treesitter parsers so the first real
  # launch isn't the one paying that cost.
  nvim --headless "+Lazy! sync" +qa || true
}

# ---------------------------------------------------------------------------
section_spectacle() {
  log "Applying Spectacle (screenshot tool) settings + shortcut"
  mkdir -p "$USER_HOME/.config"
  cp "$SCRIPT_DIR/kde/spectaclerc" "$USER_HOME/.config/spectaclerc"

  # Disables the "Record Window" global shortcut (the other two Spectacle
  # keys in this group - CurrentMonitorScreenShot/OpenWithoutScreenshot -
  # are blank by Plasma's own default, not a customization, confirmed by
  # diffing a fresh install against the main PC's config).
  local kgs="$USER_HOME/.config/kglobalshortcutsrc"
  if grep -q "^\[services\]\[org.kde.spectacle.desktop\]" "$kgs" 2>/dev/null; then
    grep -q "^RecordWindow=" "$kgs" || \
      sed -i '/^\[services\]\[org.kde.spectacle.desktop\]/a RecordWindow=none' "$kgs"
  fi
}

# ---------------------------------------------------------------------------
section_zephyr() {
  log "Installing Zephyr SDK + west (global, no venv)"
  # west + Zephyr's Python deps are installed globally with --user so `west`
  # works in any plain shell, no venv activation needed. --break-system-packages
  # is required on Fedora due to PEP 668.
  pip3 install --user --break-system-packages -U west

  local sdk_version="0.17.4"
  local sdk_dir="$USER_HOME/zephyr-sdk"
  if [ ! -d "$sdk_dir" ]; then
    local tmp="/tmp/zephyr-sdk.tar.xz"
    curl -fL -o "$tmp" \
      "https://github.com/zephyrproject-rtos/sdk-ng/releases/download/v${sdk_version}/zephyr-sdk-${sdk_version}_linux-x86_64_minimal.tar.xz"
    tar -xJf "$tmp" -C "$USER_HOME"
    mv "$USER_HOME/zephyr-sdk-${sdk_version}" "$sdk_dir"
    rm -f "$tmp"
    ( cd "$sdk_dir" && ./setup.sh -t arm-zephyr-eabi -c -h )
  fi
}

# ---------------------------------------------------------------------------
section_python_ml() {
  log "Installing Python AI/ML packages"
  # CPU-only torch index - this machine has no NVIDIA GPU (AMD iGPU only).
  # Using the default index pulls several GB of unused CUDA packages.
  pip3 install --user --break-system-packages -U \
    matplotlib numpy opencv-python
  pip3 install --user --break-system-packages -U \
    torch torchvision --index-url https://download.pytorch.org/whl/cpu
}

# ---------------------------------------------------------------------------
section_eza_aliases() {
  log "Writing eza (modern ls) aliases to ~/.aliases"
  cp "$SCRIPT_DIR/config/.aliases" "$USER_HOME/.aliases"
}

# ---------------------------------------------------------------------------
section_git_extras() {
  log "Adding git aliases + nvim as git/shell default editor"
  # 'x' is a shell function alias (git doesn't support multi-command aliases
  # without the !f() {...}; f pattern).
  git config --global core.editor "nvim"
  git config --global init.defaultBranch "main"
  git config --global alias.x '!f() { git add -u && git commit -m "$@" && git push; }; f'
  git config --global alias.amend "commit --amend -m"
  git config --global alias.l "log --pretty=\"%C(Yellow)%h %<(10)%C(reset)%as %><(14)[%C(Green)%cr%C(reset)]%x09  %<(16)%C(Cyan)%an %C(reset)%s\""
  git config --global alias.yeet "push"
  git config --global alias.yoink "pull"
}

# ---------------------------------------------------------------------------
section_gdb_dashboard() {
  log "Installing gdb-dashboard (~/.gdbinit)"
  # This is what the main PC's 94KB .gdbinit actually was - not hand-rolled,
  # it's https://github.com/cyrus-and/gdb-dashboard, pulled fresh here rather
  # than copying the file so it stays current.
  curl -fsSL https://raw.githubusercontent.com/cyrus-and/gdb-dashboard/master/.gdbinit \
    -o "$USER_HOME/.gdbinit"
}

# ---------------------------------------------------------------------------
section_embedded_pip() {
  log "Installing embedded-adjacent Python tooling"
  # spsdk provides blhost/sdphost/nxpimage/nxpuuu/dk6prog/etc as console
  # scripts (NXP MCU bootloader + provisioning tooling).
  # imgtool: MCUboot image signing (Zephyr-adjacent).
  # pygnssutils + pyubx2: u-blox GNSS tooling (gnssstreamer, ubxsave, etc).
  # pylink-square: SEGGER J-Link Python bindings.
  # Needs libusb1-devel installed first (see section_packages) - spsdk pulls
  # in hidapi, which builds from source against libusb-1.0 on this Python
  # version (no prebuilt wheel).
  pip3 install --user --break-system-packages -U \
    spsdk imgtool pygnssutils pyubx2 pylink-square
}

# ---------------------------------------------------------------------------
section_vscode_extensions() {
  log "Installing VS Code extensions"
  # If you're signed into VS Code Settings Sync with the same account as the
  # main PC, most of this list installs itself automatically - this only
  # fills in whatever Settings Sync didn't cover.
  local exts="ms-vscode.cpptools ms-vscode.cpptools-extension-pack ms-vscode.cpptools-themes \
    llvm-vs-code-extensions.vscode-clangd ms-vscode.cmake-tools ms-vscode.makefile-tools \
    ms-vscode.vscode-serial-monitor ms-vscode.cpp-devtools eamodio.gitlens \
    github.copilot-chat docker.docker ms-azuretools.vscode-docker \
    ms-azuretools.vscode-containers ms-kubernetes-tools.vscode-kubernetes-tools \
    ms-vscode-remote.remote-ssh ms-vscode-remote.remote-ssh-edit \
    ms-vscode-remote.remote-containers ms-vscode.remote-explorer ms-python.python \
    ms-python.vscode-pylance ms-python.debugpy ms-python.isort ms-python.vscode-python-envs \
    ms-toolsai.jupyter ms-toolsai.jupyter-keymap ms-toolsai.jupyter-renderers \
    ms-toolsai.vscode-jupyter-cell-tags ms-toolsai.vscode-jupyter-slideshow golang.go"
  for e in $exts; do
    code --install-extension "$e" --force 2>&1 | tail -1
  done
}

# ---------------------------------------------------------------------------
section_esp_idf() {
  [ "$DO_ESP_IDF" = true ] || return 0
  log "Installing ESP-IDF (ESP32 toolchain)"
  local idf_dir="$USER_HOME/esp/esp-idf"
  if [ -d "$idf_dir" ]; then
    echo "  ESP-IDF already cloned, skipping."
    return
  fi
  sudo dnf5 install -y cmake ninja-build ccache dfu-util python3-pip
  mkdir -p "$USER_HOME/esp"
  git clone -b v5.3.1 --recursive https://github.com/espressif/esp-idf.git "$idf_dir"
  ( cd "$idf_dir" && ./install.sh esp32,esp32s3,esp32c3 )
  echo "NOTE: 'get_idf' alias (. \$HOME/esp/esp-idf/export.sh) needs adding to"
  echo "      .zshrc if you want it - not included by default to avoid"
  echo "      slowing down every shell startup with an unconditional source."
}

# ---------------------------------------------------------------------------
section_android_studio() {
  [ "$DO_ANDROID_STUDIO" = true ] || return 0
  log "Installing Android Studio"
  local install_dir="$USER_HOME/.local/opt"
  if [ -d "$install_dir/android-studio" ]; then
    echo "  Android Studio already installed, skipping."
    return
  fi
  mkdir -p "$install_dir"
  local tmp="/tmp/android-studio.tar.gz"
  curl -fL -o "$tmp" \
    "https://redirector.gvt1.com/edgedl/android/studio/ide-zips/2024.3.2.14/android-studio-2024.3.2.14-linux.tar.gz"
  tar -xzf "$tmp" -C "$install_dir"
  rm -f "$tmp"
  echo "NOTE: launch $install_dir/android-studio/bin/studio.sh once by hand to"
  echo "      finish first-run setup and install the Android SDK."
}

# ---------------------------------------------------------------------------
section_spicetify() {
  [ "$DO_SPICETIFY" = true ] || return 0
  log "Installing Spicetify (Spotify theming)"
  # Spotify here is a flatpak, not a native install - spicetify needs to be
  # pointed at the flatpak's internal paths and given filesystem access via
  # a flatpak override. This is best-effort based on spicetify's documented
  # flatpak support; verify it actually themes Spotify after running, the
  # flatpak's internal layout can shift between Spotify versions.
  curl -fsSL https://raw.githubusercontent.com/spicetify/cli/main/install.sh | sh
  export PATH="$PATH:$USER_HOME/.spicetify"
  local spotify_files="/var/lib/flatpak/app/com.spotify.Client/current/active/files/extra/share/spotify"
  flatpak override --user com.spotify.Client --filesystem="$spotify_files"
  spicetify config spotify_path "$spotify_files"
  spicetify config prefs_path "$USER_HOME/.var/app/com.spotify.Client/config/spotify/prefs"
  echo "NOTE: run 'spicetify backup apply' by hand after confirming the paths"
  echo "      above are still correct for the installed Spotify flatpak version."
}

# ---------------------------------------------------------------------------
section_zshrc() {
  log "Writing ~/.zshrc"
  cp "$SCRIPT_DIR/.zshrc" "$USER_HOME/.zshrc"
  echo "NOTE: run 'p10k configure' interactively afterward to generate ~/.p10k.zsh"
}

# ---------------------------------------------------------------------------
section_repos() {
  [ "$DO_CLONE_REPOS" = true ] || return 0
  log "Cloning dev repos into ~/Development"

  clone_if_missing() {
    local url="$1" dest="$2"
    if [ -d "$dest" ]; then
      echo "  $dest already exists, skipping clone."
    else
      git clone "$url" "$dest"
    fi
  }

  # --- WildWestRocketry ---
  clone_if_missing https://github.com/AarC10/Frontier "$DEV/WildWestRocketry/Frontier"
  if [ ! -d "$DEV/WildWestRocketry/.west" ]; then
    ( cd "$DEV/WildWestRocketry" && west init -l Frontier && west update )
  fi

  clone_if_missing https://github.com/AarC10/Dispatch-GSW "$DEV/WildWestRocketry/Dispatch-GSW"

  # --- Launch ---
  clone_if_missing https://github.com/RIT-Launch-Initiative/FSW "$DEV/Launch/FSW"
  if [ ! -d "$DEV/Launch/.west" ]; then
    ( cd "$DEV/Launch" && west init -l FSW && west update )
  fi

  clone_if_missing https://github.com/RIT-Launch-Initiative/GSW "$DEV/Launch/GSW"

  # --- AarC10 ---
  clone_if_missing https://github.com/AarC10/personal-site "$DEV/AarC10/personal-site"

  # --- minegrub theme (top-level, it's a system theme not a project) ---
  clone_if_missing https://github.com/Lxtharia/minegrub-theme "$DEV/minegrub-theme"

  echo "NOTE: repo deps are NOT auto-installed here (npm install / pnpm install /"
  echo "      go build) - run those per-repo once cloned. See CHECKLIST.md."
}

# ---------------------------------------------------------------------------
section_grub_theme() {
  [ "$DO_GRUB_THEME" = true ] || return 0
  log "Installing minegrub GRUB theme"
  local theme_src="$DEV/minegrub-theme"
  if [ ! -d "$theme_src" ]; then
    echo "  minegrub-theme not cloned yet, skipping (run section_repos first)."
    return
  fi
  if [ -f /boot/grub2/themes/minegrub/theme.txt ]; then
    echo "  Theme already installed, skipping."
    return
  fi

  sudo cp /etc/default/grub "/etc/default/grub.bak.$(date +%Y%m%d%H%M%S)"
  sudo mkdir -p /boot/grub2/themes
  sudo cp -r "$theme_src/minegrub" /boot/grub2/themes/minegrub

  # GRUB_TERMINAL_OUTPUT="console" (present by default on this install) blocks
  # any graphical theme from rendering at all - it must be commented out.
  sudo sed -i 's/^GRUB_TERMINAL_OUTPUT=/#GRUB_TERMINAL_OUTPUT=/' /etc/default/grub

  if grep -q '^GRUB_THEME=' /etc/default/grub; then
    sudo sed -i 's|^GRUB_THEME=.*|GRUB_THEME=/boot/grub2/themes/minegrub/theme.txt|' /etc/default/grub
  else
    echo 'GRUB_THEME=/boot/grub2/themes/minegrub/theme.txt' | sudo tee -a /etc/default/grub >/dev/null
  fi
  if grep -q '^GRUB_TIMEOUT_STYLE=' /etc/default/grub; then
    sudo sed -i 's/^GRUB_TIMEOUT_STYLE=.*/GRUB_TIMEOUT_STYLE=menu/' /etc/default/grub
  else
    echo 'GRUB_TIMEOUT_STYLE=menu' | sudo tee -a /etc/default/grub >/dev/null
  fi

  # /etc/grub2-efi.cfg is a symlink to the real grub.cfg regardless of
  # UEFI/BIOS boot mode - safe regen target on Fedora either way.
  sudo grub2-mkconfig -o /etc/grub2-efi.cfg
  echo "Reboot to see the new theme."
}

# ---------------------------------------------------------------------------
section_desktop_layout() {
  [ "$DO_DESKTOP_LAYOUT" = true ] || return 0
  log "Applying Plasma panel layout + KWin window button order"
  # This uses plasmashell's D-Bus scripting API (evaluateScript). On this
  # Fedora build, org.kde.plasma.appmenu and org.kde.plasma.panelspacer fail
  # to load (Qt ABI mismatch between plasma-workspace-libs 6.7.4 and
  # qt6-qtbase 6.11.1 - a Fedora packaging bug, confirmed via rpm -V that the
  # shipped files aren't locally corrupted). Everything below works around
  # that by avoiding those two plugins.
  #
  # NOTE: calling plasmashell's refreshCurrentShell once caused it to exit
  # without auto-restarting. If your panels disappear after this runs,
  # relaunch manually: `nohup /usr/bin/plasmashell >/dev/null 2>&1 & disown`

  if ! command -v qdbus-qt6 &>/dev/null; then
    echo "  qdbus-qt6 not found, skipping desktop layout."
    return
  fi
  if ! qdbus-qt6 org.kde.plasmashell /PlasmaShell &>/dev/null; then
    echo "  plasmashell not running, skipping desktop layout."
    return
  fi

  qdbus-qt6 org.kde.plasmashell /PlasmaShell org.kde.PlasmaShell.evaluateScript "
    var existingPanels = panels();
    for (var i = 0; i < existingPanels.length; i++) { existingPanels[i].remove(); }

    var topPanel = new Panel;
    topPanel.location = 'top';
    topPanel.addWidget('org.kde.plasma.kickoff');
    topPanel.addWidget('org.kde.plasma.digitalclock');
    topPanel.addWidget('org.kde.plasma.systemtray');
    topPanel.alignment = 'center';

    var bottomPanel = new Panel;
    bottomPanel.location = 'bottom';
    bottomPanel.lengthMode = 'fit';
    bottomPanel.alignment = 'center';
    bottomPanel.height = 56;
    bottomPanel.hiding = 'autohide';
    bottomPanel.writeConfig('PanelOpacity', 1);

    var dock = bottomPanel.addWidget('org.kde.plasma.icontasks');
    dock.currentConfigGroup = ['General'];
    dock.writeConfig('launchers', 'applications:org.kde.dolphin.desktop,applications:org.kde.konsole.desktop,preferred://browser,applications:com.spotify.Client.desktop,applications:com.slack.Slack.desktop,applications:com.discordapp.Discord.desktop');
    dock.reloadConfig();
  "

  # Window titlebar buttons: Close, Maximize/Restore, Minimize - on the left.
  # Must be under [org.kde.kdecoration2], NOT [Windows] (easy mistake - that's
  # the wrong group and KWin silently ignores it).
  if ! grep -q '^\[org.kde.kdecoration2\]' "$USER_HOME/.config/kwinrc" 2>/dev/null; then
    printf '\n[org.kde.kdecoration2]\nButtonsOnLeft=XAI\nButtonsOnRight=\n' >> "$USER_HOME/.config/kwinrc"
  else
    sed -i '/^\[org.kde.kdecoration2\]/,/^\[/{s/^ButtonsOnLeft=.*/ButtonsOnLeft=XAI/; s/^ButtonsOnRight=.*/ButtonsOnRight=/}' "$USER_HOME/.config/kwinrc"
  fi
  qdbus-qt6 org.kde.KWin /KWin org.kde.KWin.reconfigure &>/dev/null || true

  echo "NOTE: split-view shortcut (Ctrl+Shift+S) and Konsole color scheme are"
  echo "      NOT scripted here - set those by hand once in Konsole's"
  echo "      Settings > Configure Keyboard Shortcuts (search 'split')."
}

# ---------------------------------------------------------------------------
main() {
  section_packages
  section_flatpaks
  section_vscode
  section_vscode_extensions
  section_jetbrains_toolbox
  section_docker
  section_zsh
  section_konsole
  section_rsed
  section_eza_aliases
  section_git_extras
  section_gdb_dashboard
  section_dev_folders
  section_rust
  section_go
  section_node
  section_just
  section_probe_rs
  section_ai_clis
  section_lazygit
  section_python_modern
  section_zoxide_delta_config
  section_lazyvim
  section_spectacle
  section_zephyr
  section_python_ml
  section_embedded_pip
  section_esp_idf
  section_android_studio
  section_spicetify
  section_zshrc
  section_repos
  section_grub_theme
  section_desktop_layout

  log "Done. Log out and back in (or reboot) to pick up: default shell, docker group, dialout group."
  echo "NOT scripted, still need manual steps:"
  echo "  - JetBrains IDEs (CLion, GoLand, IntelliJ IDEA, PyCharm, RustRover,"
  echo "    WebStorm): install each via the Toolbox GUI - no reliable scripted"
  echo "    install path found for Toolbox itself."
  echo "  - SEGGER J-Link: license-gated download at https://www.segger.com/downloads/jlink/"
  echo "  - STM32CubeProgrammer / STM32CubeMX: license-gated download at https://www.st.com/en/development-tools/stm32cubeprog.html"
  echo "    and https://www.st.com/en/development-tools/stm32cubemx.html (free ST account required)"
  echo "  - OPENAI_API_KEY: not embedded in this script on purpose (avoid"
  echo "    secrets in git history) - add it to ~/.config/secrets/env.zsh by hand."
}

if [ $# -gt 0 ]; then
  for fn in "$@"; do
    "section_$fn"
  done
else
  main
fi
