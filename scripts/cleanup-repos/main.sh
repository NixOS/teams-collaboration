#!/usr/bin/env bash

set -euo pipefail
set -x

cleanupMessage='Hi,

As part of https://github.com/NixOS/teams-collaboration/issues/1, I am trying to clarify the status of the repositories under the NixOS organisation.

This repository seems to be unmaintained or obsolete, so it will be archived in a month.

If you think it warrants staying here or should be moved to another organization instead, please answer this issue.'

readarray -t REPOS_TO_ASK_FOR < <(nix shell nixpkgs#miller --command mlr --icsv --ojsonl cat scripts/cleanup-repos/repos.csv  | nix run nixpkgs#jq '. | select(.Alive != "Yes" and .Post_comment == "Yes") | .URL' -- -r)

for REPO in "${REPOS_TO_ASK_FOR[@]}"; do
  # echo "$REPO"
   gh --repo "$REPO" issue create --title "Status of the repository?" --body "$cleanupMessage"
done
