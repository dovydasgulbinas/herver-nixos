#! /usr/bin/env bash


# Directory to search for private SSH keys
SEARCH_DIR=${1:-~/dotfiles/stow/ssh/.ssh/}
pushd $SEARCH_DIR


# Find all potential private SSH key files, ignoring 'config' and 'known_hosts'
find "$SEARCH_DIR" -type f ! -name "*.pub" \
    ! -name "config" \
    ! -name "known_hosts" | while read -r key_file; do

  # Check if it's a valid private key
  if ssh-keygen -lf "$key_file" &>/dev/null; then
    echo "Checking key: $key_file"
    chmod 600 "$key_file"
    # TODO: not the best command for the job
    ssh-keygen -lf "$key_file"
    echo
  else
    echo "Skipping invalid key file: $key_file"
  fi
done


popd
