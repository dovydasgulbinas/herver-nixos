{
  config,
  pkgs,
  ...
}: let
  stuff = "nothing";
in {
  imports = [
    <home-manager/nixos>
    # ./sources/logseq/logseq.nix
  ];

  home-manager.backupFileExtension = "baknix";
  home-manager.users.hermes = {
    home.stateVersion = "24.11";
    home.file = {
      ".ssh/config" = {source = ./sources/ssh/config;};
      ".ssh/id_ed25519" = {source = ./sources/ssh/id_ed25519_servers;};
      ".ssh/id_ed25519.pub" = {source = ./sources/ssh/id_ed25519_servers.pub;};
      ".gitconfig" = {source = ./sources/git/.gitconfig;};
      ".gitignore_global" = {source = ./sources/git/.gitignore_global;};
      ".zsh_functions" = {source = ./sources/zsh/.zsh_functions;};
      ".zsh_aliases" = {source = ./sources/zsh/.zsh_aliases;};
      ".config/alacritty/alacritty.toml" = {source = ./sources/alacritty/alacritty.toml;};
    };

    programs.neovim = {
      withNodeJs = true;
      withPython3 = true;
    };

    programs.git.lfs.enable = true;

    programs.zsh = {
      enable = true;
      # opt for zsh-autcompletion rather than default
      enableCompletion = false;
      syntaxHighlighting.enable = true;

      shellAliases = {
        g = "git";
        ll = "ls -alh";
        d = "docker";
        dcc = "docker compose";
      };

      oh-my-zsh = {
        enable = true;
        plugins = ["git" "zoxide" "virtualenv" "python"];
        theme = "dst";
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
