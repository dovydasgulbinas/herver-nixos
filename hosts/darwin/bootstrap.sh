# nix flake init -t nix-darwin --extra-experimental-features "nix-command flakes"
nix run nix-darwin --extra-experimental-features "nix-command flakes" -- switch --flake ~/.config/nix#herbook
