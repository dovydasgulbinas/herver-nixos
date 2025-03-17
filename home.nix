{
  config,
  pkgs,
  ...
}: let
  stuff = "nothing";
in {
  imports = [
    <home-manager/nixos>
  ];

  home-manager.backupFileExtension = "baknix";
  home-manager.users.hermes = {
    home.stateVersion = "24.11";
    home.file = {
      ".config/alacritty/alacritty.toml" = {source = ./stow/alacritty/.config/alacritty/alacritty.toml;};
    };

    programs.neovim = {
      withNodeJs = true;
      withPython3 = true;
    };

    programs.git.lfs.enable = true;

    programs.ghostty.enableBashIntegration = true;
    programs.ghostty.enableZshIntegration = true;
    programs.firefox.enableGnomeExtensions = true;

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
        vim = "nvim";
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
