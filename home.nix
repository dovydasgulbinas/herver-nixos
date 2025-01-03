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

  home-manager.backupFileExtension = "baknix";
  home-manager.users.hermes = {
    home.stateVersion = "24.11";
    home.file = {
      ".ssh/config" = {source = ./sources/ssh/config;};
      ".ssh/id_ed25519" = {source = ./sources/ssh/id_ed25519_servers;};
      ".ssh/id_ed25519.pub" = {source = ./sources/ssh/id_ed25519_servers.pub;};
      ".zsh_functions" = {source = ./sources/zsh/.zsh_functions;};
      ".zsh_aliases" = {source = ./sources/zsh/.zsh_aliases;};
    };
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

      initExtra = ''
        if [ -d "$HOME/bin" ] ; then
            PATH="$HOME/bin:$PATH"
        fi

        if [ -d "$HOME/.local/bin" ] ; then
            PATH="$HOME/.local/bin:$PATH"
        fi

        if [ -f "$HOME/.zsh_aliases" ]; then
            . "$HOME/.zsh_aliases"
        fi

        if [ -f "$HOME/.zsh_functions" ]; then
            . "$HOME/.zsh_functions"
        fi

        if [ -f "$HOME/.zsh_work" ]; then
            . "$HOME/.zsh_work"
        fi

        if [ -f "$HOME/.env" ]; then
            . "$HOME/.env"
        fi
      '';
    };
  };
}
