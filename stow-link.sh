#!/usr/bin/env bash

if [ -d "$HOME/dotfiles/stow" ]; then
  pushd "$HOME/dotfiles/stow" || exit
else
  echo "No valid stow dir found"
  exit 1
fi

stow --verbose --target=$HOME --no-folding ghostty
stow --verbose --target=$HOME  nvim
# stow --verbose --target=$HOME --no-folding alacritty
# stow --verbose --target=$HOME --no-folding git
stow --verbose --target=$HOME --no-folding scripts
stow --verbose --target=$HOME --no-folding keepassxc
stow --verbose --target=$HOME logseq  # i dont want to create many symlinks for plugins
stow --verbose --target=$HOME --no-folding zsh
stow --verbose --target=$HOME --no-folding ssh
popd || exit
