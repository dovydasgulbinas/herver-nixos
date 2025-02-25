#!/usr/bin/env bash


pushd $HOME/Documents/dotfiles/stow

$EDITOR .

stow --verbose --target=$HOME --no-folding scripts
popd
