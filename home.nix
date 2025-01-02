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

  programs.zsh = {
    enable = true;

    # opt for zsh-autcompletion rather than default
    enableCompletion = false;
    syntaxHighlighting.enable = true;

    shellAliases = {
      ll = "ls -l";
      g = "git";
      d = "docker";
      dcc = "docker compose";
    };

    oh-my-zsh = {
      enable = true;
      plugins = ["git" "thefuck" "zoxide" "virtualenv"];
      theme = "robbyrussell";
    };
  };

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
