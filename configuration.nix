{
  config,
  pkgs,
  options,
  ...
}: let
  hostname = "${builtins.getEnv "THIS_HOSTNAME"}";
in {
  networking.hostName = hostname;
  networking.nameservers = ["1.1.1.1" "1.0.0.1"];

  imports = [
    # TODO: add if import if it does not exist use /etc/nixos conf
    (/home/hermes/dotfiles/hardware + "/${hostname}.nix")
    (/home/hermes/dotfiles/configuration + "/${hostname}.nix")
    /home/hermes/dotfiles/home.nix
  ];
}
