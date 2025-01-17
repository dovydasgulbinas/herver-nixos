#!/usr/bin/env bash

pushd $HOME/dotfiles/stow
# stow --verbose --target=$HOME --no-folding scripts
stow --verbose --target=$HOME --no-folding nvim
stow --verbose --target=$HOME --no-folding git
stow --verbose --target=$HOME --no-folding ssh
popd
