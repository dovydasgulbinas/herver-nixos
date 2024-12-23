{
  config,
  pkgs,
  options,
  ...
}: let
  hostname = "herver-nix"; # to alllow per-machine config
in {
  networking.hostName = hostname;

  imports = [
    /etc/nixos/hardware-configuration.nix
    (/home/hermes/dotfiles + "/${hostname}.nix")
    /home/hermes/dotfiles/home.nix
  ];
}
