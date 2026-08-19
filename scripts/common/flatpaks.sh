#!/bin/bash
# Flathub + flatpak apps (Spotify, Slack, Discord)
set -euo pipefail
source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/../lib/common.sh"

log "Setting up Flathub + flatpak apps"
# Assumes flatpak itself is already installed. Fedora ships it by default;
# Ubuntu needs `sudo apt install flatpak` first.
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
flatpak install -y --noninteractive flathub \
  com.spotify.Client \
  com.slack.Slack \
  com.discordapp.Discord
