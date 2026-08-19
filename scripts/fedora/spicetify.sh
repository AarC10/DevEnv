#!/bin/bash
# Spicetify (Spotify theming, assumes flatpak Spotify)
set -euo pipefail
source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/../lib/common.sh"

log "Installing Spicetify (Spotify theming)"
# Spotify here is a flatpak, not a native install - spicetify needs to be
# pointed at the flatpak's internal paths and given filesystem access via
# a flatpak override. This is best-effort based on spicetify's documented
# flatpak support; verify it actually themes Spotify after running, the
# flatpak's internal layout can shift between Spotify versions.
curl -fsSL https://raw.githubusercontent.com/spicetify/cli/main/install.sh | sh
export PATH="$PATH:$USER_HOME/.spicetify"
spotify_files="/var/lib/flatpak/app/com.spotify.Client/current/active/files/extra/share/spotify"
flatpak override --user com.spotify.Client --filesystem="$spotify_files"
spicetify config spotify_path "$spotify_files"
spicetify config prefs_path "$USER_HOME/.var/app/com.spotify.Client/config/spotify/prefs"
echo "NOTE: run 'spicetify backup apply' by hand after confirming the paths"
echo "      above are still correct for the installed Spotify flatpak version."
