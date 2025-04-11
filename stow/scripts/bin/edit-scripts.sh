#!/usr/bin/env bash


pushd "$HOME/dotfiles/stow" || exit

$EDITOR .

chmod u+x scripts/bin/*
stow --verbose --target="$HOME" --no-folding scripts
popd || exit
