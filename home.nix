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
    # your `configuration.nix` file.
    home.stateVersion = "24.11";

    home.file = {
      ".ssh/config" = {
        text = ''
          Host *
           AddKeysToAgent yes
           IdentityFile ~/.ssh/id_ed25519_servers
        '';
      };
    };
  };
}
