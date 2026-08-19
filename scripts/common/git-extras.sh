#!/bin/bash
# Git aliases + nvim as default editor
set -euo pipefail
source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/../lib/common.sh"

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
