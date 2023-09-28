#!/bin/bash

# If you're not able to clone private repos, make sure to login to GH through the CLI dummy
gh repo list AarC10 | while read -r repo _; do
  gh repo clone "$repo" "$repo" & # Can't wait for GitHub to ban me for bombing their servers
done
