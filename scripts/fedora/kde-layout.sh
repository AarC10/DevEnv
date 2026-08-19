#!/bin/bash
# Plasma panel layout + KWin window button order
set -euo pipefail
source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/../lib/common.sh"

log "Applying Plasma panel layout + KWin window button order"
# Uses plasmashell's D-Bus scripting API. org.kde.plasma.appmenu and
# org.kde.plasma.panelspacer are both broken on this Fedora build (Qt ABI
# mismatch, a packaging bug not a local issue) so this avoids them - no
# global menu bar, spacing done via panel alignment instead of a spacer.
#
# If panels vanish after running this (plasmashell can exit without
# restarting on a config reload): nohup /usr/bin/plasmashell >/dev/null 2>&1 & disown

if ! command -v qdbus-qt6 &>/dev/null; then
  echo "  qdbus-qt6 not found, skipping desktop layout."
  exit 0
fi
if ! qdbus-qt6 org.kde.plasmashell /PlasmaShell &>/dev/null; then
  echo "  plasmashell not running, skipping desktop layout."
  exit 0
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
