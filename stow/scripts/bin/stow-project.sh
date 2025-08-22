#!/usr/bin/env bash
# PROJECT='Workis'
#
# pushd $HOME/Documents/Work
# stow --verbose --target=$HOME "$PROJECT"
# popd

#!/usr/bin/env bash
set -euo pipefail

WORKDIR="$HOME/Documents/Work"
cd "$WORKDIR"

PROJECT=$(ls -d */ | sed 's:/$::' | fzf --prompt="Pick a project: ")

if [[ -n "$PROJECT" ]]; then
    echo "You picked: $PROJECT"
    stow --verbose --target="$HOME" "$PROJECT"
else
    echo "No project selected."
    exit 1
fi
