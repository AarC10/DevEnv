#!/bin/bash
# VS Code extensions
set -euo pipefail
source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/../lib/common.sh"

log "Installing VS Code extensions"
# If you're signed into VS Code Settings Sync with the same account as the
# main PC, most of this list installs itself automatically - this only
# fills in whatever Settings Sync didn't cover.
exts="ms-vscode.cpptools ms-vscode.cpptools-extension-pack ms-vscode.cpptools-themes \
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
