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
    (/home/hermes/dotfiles/hardware-confs + "/${hostname}.nix")
    (/home/hermes/dotfiles + "/${hostname}.nix")
    /home/hermes/dotfiles/home.nix
  ];
}
