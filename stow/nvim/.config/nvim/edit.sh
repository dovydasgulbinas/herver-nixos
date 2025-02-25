#!/bin/bash

pushd "$HOME/.config/nvim"
git pull

nvim .

echo "Starting Neovim Again!"

nvim .

if git diff --quiet; then
    echo "No changes detected, exiting."
    popd
    exit 0
fi

git add -i 

git commit

git push
popd


