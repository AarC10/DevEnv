#!/bin/bash
# gdb-dashboard (~/.gdbinit)
set -euo pipefail
source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/../lib/common.sh"

log "Installing gdb-dashboard (~/.gdbinit)"
# This is what the main PC's 94KB .gdbinit actually was - not hand-rolled,
# it's https://github.com/cyrus-and/gdb-dashboard, pulled fresh here rather
# than copying the file so it stays current.
curl -fsSL https://raw.githubusercontent.com/cyrus-and/gdb-dashboard/master/.gdbinit \
  -o "$USER_HOME/.gdbinit"
