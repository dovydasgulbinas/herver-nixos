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

stow --verbose --target=$HOME --no-folding nvim
stow --verbose --target=$HOME --no-folding git
stow --verbose --target=$HOME --no-folding scripts
stow --verbose --target=$HOME --no-folding keepassxc
stow --verbose --target=$HOME logseq
stow --verbose --target=$HOME --no-folding zsh
stow --verbose --target=$HOME --no-folding ssh
popd
