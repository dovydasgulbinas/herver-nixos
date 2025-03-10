#!/usr/bin/env bash


pushd "$HOME/dotfiles/stow" || exit

$EDITOR .

stow --verbose --target="$HOME" --no-folding scripts
popd || exit
