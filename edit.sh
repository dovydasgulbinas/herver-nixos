
#!/usr/bin/env bash

set -e


# cd to your config dir
if [ -d "$HOME/nixos-config" ]; then
  pushd "$HOME/nixos-config"
else
  echo "No valid dotfile dir found"
  popd
  exit 1
fi


# Edit your config
nvim "${NIXCONF}"


# Early return if no changes were detected (thanks @singiamtel!)
if git diff --quiet '*.nix'; then
    echo "No changes detected, exiting."
    popd
    exit 0
fi

# Autoformat your nix files
alejandra . &>/dev/null \
  || ( alejandra . ; echo "formatting failed!" && exit 1)

# Shows your changes
git diff -U0 '*.nix'

echo "NixOS Rebuilding..."

# Rebuild, output simplified errors, log trackebacks
nix run .#build-switch  &>nixos-switch.log || (cat nixos-switch.log | grep --color error && exit 1)


# Commit all changes witih the generation metadata
# git commit -am "$current"

# echo "$HOST Rebuilt OK! ${current}"
echo "$HOST Rebuilt OK!"
popd
done
