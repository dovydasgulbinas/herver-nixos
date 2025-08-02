{
  config,
  pkgs,
  lib,
  ...
}: let
  name = "Dovydas Gulbinas";
  user = "hermes";
  email = "dovydas.gulbinas@protonmail.com";
in {
  # Shared shell configuration
  neovim = {
    withNodeJs = true;
    withPython3 = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
  };

  zsh = {
    enable = true;
    autocd = true;
    enableCompletion = false;
    syntaxHighlighting.enable = true;

    oh-my-zsh = {
      enable = true;
      plugins = ["git" "zoxide" "virtualenv" "python"];
      theme = "amuse";
    };

    shellAliases = {
      g = "git";
      ll = "ls -alh";
      d = "docker";
      dcc = "docker compose";
      v = "nvim";
      vim = "nvim";
      search = "rg -p --glob '!node_modules/*'  $@";
      fo = "open \"$(fzf)\"";
    };

    initContent = lib.mkBefore ''
      if [[ -f /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh ]]; then
        . /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
        . /nix/var/nix/profiles/default/etc/profile.d/nix.sh
      fi

      # Define variables for directories
      export PATH=$HOME/.pnpm-packages/bin:$HOME/.pnpm-packages:$PATH
      export PATH=$HOME/.npm-packages/bin:$HOME/bin:$PATH
      export PATH=$HOME/.local/share/bin:$PATH

      # Remove history data we don't want to see
      export HISTIGNORE="pwd:ls:cd:z"

      export EDITOR="nvim"
      export ALTERNATE_EDITOR="vim"
      # export VISUAL=""


      alias nix-shell='nix-shell --run $SHELL'
      nix() {
        if [[ $1 == "develop" ]]; then
          shift
          command nix develop -c $SHELL "$@"
        else
          command nix "$@"
        fi
      }

      # nix shortcuts
      shell() {
          nix-shell '<nixpkgs>' -A "$1"
      }

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

      if [ -f "$HOME/.env-secrets" ]; then
          . "$HOME/.env-secrets"
      fi


      source <(fzf --zsh)
    '';
  };

  git = {
    enable = true;
    ignores = ["*.swp"];
    userName = name;
    userEmail = email;
    lfs = {
      enable = true;
    };
    extraConfig = {
      init.defaultBranch = "main";
      push.autoSetupRemote = true;
      core = {
        editor = "nvim";
        autocrlf = "input";
      };
      commit.gpgsign = false;
      pull.rebase = true;
      rebase.autoStash = true;
    };
  };

  alacritty = {
    enable = true;
    settings = {
      cursor = {
        style = "Block";
      };

      window = {
        dynamic_padding = true;
        opacity = 1.0;
        decorations = "full";
        title = "Terminal";
        padding = {
          x = 12;
          y = 12;
        };

        option_as_alt = lib.mkMerge [
          (lib.mkIf pkgs.stdenv.hostPlatform.isLinux "None")
          (lib.mkIf pkgs.stdenv.hostPlatform.isDarwin "OnlyLeft")
        ];
      };

      font = {
        normal = {
          family = "JetBrainsMono Nerd Font Mono";
          style = "Regular";
        };
        italic = {
          family = "JetBrainsMono Nerd Font Mono";
          style = "Italic";
        };
        bold = {
          family = "JetBrainsMono Nerd Font Mono";
          style = "Bold";
        };
        size = lib.mkMerge [
          (lib.mkIf pkgs.stdenv.hostPlatform.isLinux 10)
          (lib.mkIf pkgs.stdenv.hostPlatform.isDarwin 14)
        ];
      };

      # terminal.shell = {
      #   program = "${pkgs.tmux}";
      #   args = ["-u" "new-session" "-A" "-s" "main"];
      # };

      colors = {
        primary = {
          background = "0x1f2528";
          foreground = "0xc0c5ce";
        };

        normal = {
          black = "0x1f2528";
          red = "0xec5f67";
          green = "0x99c794";
          yellow = "0xfac863";
          blue = "0x6699cc";
          magenta = "0xc594c5";
          cyan = "0x5fb3b3";
          white = "0xc0c5ce";
        };

        bright = {
          black = "0x65737e";
          red = "0xec5f67";
          green = "0x99c794";
          yellow = "0xfac863";
          blue = "0x6699cc";
          magenta = "0xc594c5";
          cyan = "0x5fb3b3";
          white = "0xd8dee9";
        };
      };
    };
  };

  ssh = {
    enable = false;
    includes = [
      (
        lib.mkIf pkgs.stdenv.hostPlatform.isLinux
        "/home/${user}/.ssh/config_external"
      )
      (
        lib.mkIf pkgs.stdenv.hostPlatform.isDarwin
        "/Users/${user}/.ssh/config_external"
      )
    ];
    matchBlocks = {
      "github.com" = {
        identitiesOnly = true;
        identityFile = [
          (
            lib.mkIf pkgs.stdenv.hostPlatform.isLinux
            "/home/${user}/.ssh/id_github"
          )
          (
            lib.mkIf pkgs.stdenv.hostPlatform.isDarwin
            "/Users/${user}/.ssh/id_github"
          )
        ];
      };
    };
  };

  tmux = {
    enable = true;
    terminal = "tmux-256color";
    prefix = "C-b";
    escapeTime = 10;
    historyLimit = 50000;
    baseIndex = 1;
    keyMode = "vi";
    clock24 = true;

    plugins = with pkgs.tmuxPlugins; [
      vim-tmux-navigator
      sensible
      yank
      prefix-highlight
      {
        plugin = catppuccin;
        extraConfig = ''
          set -g @catppuccin_flavour 'mocha'
          set -g @catppuccin_window_status_style "rounded"

          set -g status-right-length 100
          set -g status-left-length 100
          set -g status-left ""
          set -g status-right "#{E:@catppuccin_status_application}"
          set -ag status-right "#{E:@catppuccin_status_session}"
          set -ag status-right "#{E:@catppuccin_status_uptime}"
        '';
      }
      {
        plugin = resurrect; # Used by tmux-continuum
        # Use XDG data directory
        # https://github.com/tmux-plugins/tmux-resurrect/issues/348
        extraConfig = ''
          set -g @resurrect-dir '$HOME/.cache/tmux/resurrect'
          set -g @resurrect-capture-pane-contents 'on'
          set -g @resurrect-pane-contents-area 'visible'
        '';
      }
      {
        plugin = continuum;
        extraConfig = ''
          set -g @continuum-restore 'on'
          set -g @continuum-save-interval '5' # minutes
        '';
      }
    ];
    extraConfig = ''
      # https://github.com/dreamsofcode-io/tmux/blob/main/tmux.conf
      # https://www.youtube.com/watch?v=DzNmUNvnB04
      # set-option -sa terminal-overrides ",xterm*:Tc"

      # set-option -g default-shell $SHELL
      set -g mouse on
      set -s set-clipboard on

      # unbind C-b
      # https://github.com/christoomey/vim-tmux-navigator/issues/9
      # bind C-l send-keys 'C-l'
      # unbind C-l  # allow ctrl+l to clear the screen
      # set -as terminal-overrides ',*:indn@'
      # set -g prefix C-Space
      # bind C-Space send-prefix

      # Vim style pane selection
      bind h select-pane -L
      bind j select-pane -D
      bind k select-pane -U
      bind l select-pane -R

      # Use Alt-arrow keys without prefix key to switch panes
      bind -n M-Left select-pane -L
      bind -n M-Right select-pane -R
      bind -n M-Up select-pane -U
      bind -n M-Down select-pane -D

      # Shift arrow to switch windows
      bind -n S-Left  previous-window
      bind -n S-Right next-window

      # Shift Alt vim keys to switch windows
      bind -n M-H previous-window
      bind -n M-L next-window

      # set -g @catppuccin_flavour 'mocha'
      # set -g @plugin 'tmux-plugins/tpm'
      # set -g @plugin 'tmux-plugins/tmux-sensible'
      # set -g @plugin 'christoomey/vim-tmux-navigator'
      # set -g @plugin 'dreamsofcode-io/catppuccin-tmux'
      # set -g @plugin 'tmux-plugins/tmux-yank'
      # set -g @plugin 'tmux-plugins/tmux-resurrect'
      # set -g @resurrect-strategy-nvim 'session'

      # set vi-mode
      # set-window-option -g mode-keys vi
      # keybindings
      bind-key -T copy-mode-vi v send-keys -X begin-selection
      bind-key -T copy-mode-vi C-v send-keys -X rectangle-toggle
      bind-key -T copy-mode-vi y send-keys -X copy-selection-and-cancel

      bind '"' split-window -v -c "#{pane_current_path}"
      bind % split-window -h -c "#{pane_current_path}"

      # these lines must be last
      set -gu default-command
      set -g default-shell "$SHELL"
    '';
  };
}
