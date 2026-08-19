#!/bin/bash
# Install the minegrub GRUB theme
set -euo pipefail
source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/../lib/common.sh"

log "Installing minegrub GRUB theme"
theme_src="$DEV/minegrub-theme"
if [ ! -d "$theme_src" ]; then
  echo "  minegrub-theme not cloned yet, skipping (run scripts/common/repos.sh first)."
  exit 0
fi
if [ -f /boot/grub2/themes/minegrub/theme.txt ]; then
  echo "  Theme already installed, skipping."
  exit 0
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
