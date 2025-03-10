#!/usr/bin/env bash
#
# I believe there are a few ways to do this:
#
#    1. My current way, using a minimal /etc/nixos/configuration.nix that just imports my config from my home directory (see it in the gist)
#    2. Symlinking to your own configuration.nix in your home directory (I think I tried and abandoned this and links made relative paths weird)
#    3. My new favourite way: as @clot27 says, you can provide nixos-rebuild with a path to the config, allowing it to be entirely inside your dotfies, with zero bootstrapping of files required.
#       `nixos-rebuild switch -I nixos-config=path/to/configuration.nix`
#    4. If you uses a flake as your primary config, you can specify a path to `configuration.nix` in it and then `nixos-rebuild switch —flake` path/to/directory
# As I hope was clear from the video, I am new to nixos, and there may be other, better, options, in which case I'd love to know them! (I'll update the gist if so)

# A rebuild script that commits on a successful build
set -e
# nix-shell

is_valid_response() {
    local input="$1"
    [[ "$input" =~ ^(y|yes|n|no|Y|YES|N|NO)$ ]]
}


# cd to your config dir
if [ -d "$HOME/dotfiles" ]; then
  pushd "$HOME/dotfiles"
else
  echo "No valid dotfile dir found"
  popd
  exit 1
fi

# Prompt the user for yes/no input
while true; do
    read -p "Do you to pull latest changes from git remote? (y/n): " response

    if is_valid_response "$response"; then
        # Normalize input to lowercase
        response=$(echo "$response" | tr '[:upper:]' '[:lower:]')
        if [[ "$response" == "y" || "$response" == "yes" ]]; then
        	git pull
        	break
        else
            echo "Skipping git pull..."
            break
        fi
        break
    else
        echo "Invalid input. Please enter 'y', 'yes', 'n', or 'no'."
        popd
        exit 1
    fi
done

HOST="${HOSTNAME}"
NIXCONF="configuration/$HOST.nix"

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
sudo THIS_HOSTNAME=$HOST nixos-rebuild switch -I nixos-config=configuration.nix &>nixos-switch.log || (cat nixos-switch.log | grep --color error && exit 1)

# Get current generation metadata
current=$(nixos-rebuild list-generations | grep current)

# Commit all changes witih the generation metadata
git commit -am "$current"


# Notify all OK!
echo "$HOST Rebuilt OK! ${current}"
#
# Prompt the user for yes/no input
while true; do
    read -p "Do you want to push changes git remote? (y/n): " response

    if is_valid_response "$response"; then
        # Normalize input to lowercase
        response=$(echo "$response" | tr '[:upper:]' '[:lower:]')
        if [[ "$response" == "y" || "$response" == "yes" ]]; then
        	git push
        	break
        else
            echo "Skipping push pull..."
            break
        fi
        break
    else
        echo "Invalid input. Please enter 'y', 'yes', 'n', or 'no'."
        popd
        exit 1
    fi
done
