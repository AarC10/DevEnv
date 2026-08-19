#!/bin/bash
# Clone personal project repos into ~/Development
set -euo pipefail
source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/../lib/common.sh"

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
echo "      go build) - run those per-repo once cloned."
