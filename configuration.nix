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
    # TODO: add if import if it does not exist use /etc/nixos conf
    (/home/hermes/dotfiles/hardware-confs + "/${hostname}.nix")
    (/home/hermes/dotfiles + "/${hostname}.nix")
    /home/hermes/dotfiles/home.nix
  ];
}
