{
  config,
  pkgs,
  ...
}: let
  home-manager = builtins.fetchTarball {
    url = "https://github.com/nix-community/home-manager/archive/release-24.11.tar.gz";
    sha256 = "0b41b251gxbrfrqplp2dkxv00x8ls5x5b3n5izs4nxkcbhkjjadz";
  };
in {
  imports = [
    (import "${home-manager}/nixos")
  ];

  home-manager.users.hermes = {
    # This should be the same value as `system.stateVersion` in
    home.stateVersion = "24.11";

    home.file = {
      ".ssh/config" = {source = ./sources/ssh/config;};
      ".ssh/id_ed25519" = {source = ./sources/ssh/id_ed25519_servers;};
      ".ssh/id_ed25519.pub" = {source = ./sources/ssh/id_ed25519_servers.pub;};
    };
  };
}
