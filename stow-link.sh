#!/usr/bin/env bash

if [ -d "$HOME/dotfiles/stow" ]; then
  echo "Using $HOME/dotfiles/stow"
  pushd "$HOME/dotfiles/stow"
elif [ -d "$HOME/Documents/dotfiles/stow" ]; then
  echo "Using $HOME/Documents/dotfiles/stow"
  pushd "$HOME/Documents/dotfiles/stow"
else
  echo "No valid stow dir found"
  exit 1
fi

stow --verbose --target=$HOME --no-folding ghostty
stow --verbose --target=$HOME  nvim
# stow --verbose --target=$HOME --no-folding alacritty
# stow --verbose --target=$HOME --no-folding git
stow --verbose --target=$HOME  scripts
stow --verbose --target=$HOME --no-folding keepassxc
stow --verbose --target=$HOME logseq  # i dont want to create many symlinks for plugins
stow --verbose --target=$HOME --no-folding zsh
stow --verbose --target=$HOME --no-folding ssh
popd
