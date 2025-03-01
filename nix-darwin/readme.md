install rosseta 2:

    softwareupdate --install-rosetta

init chezmoi:

   chezmoi init dovydasgulbinas --apply


search for packages
    
    nix search nixpkgs tmux


verify nix installation:

    nix-shell -p nix-info --run "nix-info -m"
    nix-shell -p neofetch --run neofetch

sudo mkdir -p /etc/nix-darwin

init darwin (part of new init script, not needed because we have flake.nix)

    nix flake init -t nix-darwin --extra-experimental-features "nix-command flakes"

print Darwin hostname

    scutil --get LocalHostname

search a nix package:

    nix search nixpkgs tmux

get darwin nix documentation:
    
    darwin-help
