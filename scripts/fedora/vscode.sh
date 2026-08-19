#!/bin/bash
# Install VS Code (direct RPM download, dnf repo is flaky here)
set -euo pipefail
source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/../lib/common.sh"

log "Installing VS Code"
# dnf's own repo download of the VS Code RPM has repeatedly failed
# mid-transfer (Curl error 56, connection reset ~330MB in) on this network.
# Downloading directly with curl (resumable, retries) and installing the
# local RPM sidesteps it.
if rpm -q code &>/dev/null; then
  echo "VS Code already installed, skipping."
  exit 0
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
tmp="/tmp/vscode.rpm"
curl -fL --retry 10 --retry-delay 3 --retry-all-errors -C - \
  -o "$tmp" \
  "https://code.visualstudio.com/sha/download?build=stable&os=linux-rpm-x64"
sudo dnf5 install -y "$tmp"
rm -f "$tmp"
