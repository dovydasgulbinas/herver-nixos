#!/usr/bin/env zsh


pushd "$HOME/dotfiles" || exit
git pull

# ask for user password
sudo -v
$EDITOR .

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

nix run .#build-switch
git add -i
git commit
git push
popd || exit
