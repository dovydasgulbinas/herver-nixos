{
  config,
  pkgs,
  options,
  ...
}: let
  hostname = "${builtins.getEnv "THIS_HOSTNAME"}";
in {
  networking.hostName = hostname;

  networking.nameservers = ["1.1.1.1" "8.8.8.8"];

  imports = [
    /etc/nixos/hardware-configuration.nix
    (/home/hermes/Documents/dotfiles/configuration + "/${hostname}.nix")
    /home/hermes/Documents/dotfiles/home.nix
  ];
}
