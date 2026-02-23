#!/usr/bin/env zsh

set -e

pushd "$HOME/dotfiles" || exit
git pull

# sudo -v
$EDITOR ./modules/shared/packages.nix


sudo nix --extra-experimental-features 'nix-command flakes' run .#build-switch

pushd "$HOME/dotfiles/stow" || exit
stow --verbose --target=$HOME --no-folding scripts
stow --verbose --target=$HOME --no-folding ghostty
stow --verbose --target=$HOME  nvim
stow --verbose --target=$HOME logseq  # i dont want to create many symlinks for plugins
stow --verbose --target=$HOME --no-folding keepassxc
stow --verbose --target=$HOME --no-folding ideavim
# stow --verbose --target=$HOME --no-folding alacritty
# stow --verbose --target=$HOME --no-folding git
# stow --verbose --target=$HOME --no-folding zsh
# stow --verbose --target=$HOME --no-folding ssh
popd || exit

git add -i
git commit
git push
popd || exit
