{
  config,
  pkgs,
  options,
  ...
}: let
  hostname = "${builtins.getEnv "THIS_HOSTNAME"}";
  user = "hermes";
  dotdir = "/home/${user}/dotfiles";
in {
  networking.hostName = hostname;
  networking.nameservers = ["1.1.1.1" "8.8.8.8"];

  imports = [
    # DO NOT USE the copied harware conf, use what system has
    /etc/nixos/hardware-configuration.nix
    "${dotdir}/configuration/${hostname}.nix"
    "${dotdir}/home.nix"
  ];
}
