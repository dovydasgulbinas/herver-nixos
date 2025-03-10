{
  description = "Herbook Darwin sys flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:LnL7/nix-darwin/master";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    mac-app-util.url = "github:hraban/mac-app-util";
    nix-homebrew.url = "github:zhaofengli-wip/nix-homebrew";

    # Optional: Declarative tap management
    homebrew-core = {
      url = "github:homebrew/homebrew-core";
      flake = false;
    };
    homebrew-cask = {
      url = "github:homebrew/homebrew-cask";
      flake = false;
    };
    homebrew-bundle = {
      url = "github:homebrew/homebrew-bundle";
      flake = false;
    };
    home-manager.url = "github:nix-community/home-manager";
  };

  outputs = inputs @ {
    self,
    nix-darwin,
    nixpkgs,
    mac-app-util,
    nix-homebrew,
    homebrew-core,
    homebrew-cask,
    homebrew-bundle,
    home-manager,
    ...
  }: let
    homeManagerConfig = import ./modules/shared/default.nix;
    configuration = {
      pkgs,
      config,
      ...
    }: {
      # List packages installed in system profile. To search by name, run:
      # $ nix-env -qaP | grep wget
      environment.systemPackages = [
        pkgs.nil
        pkgs.typescript-language-server
        pkgs.vue-language-server
        pkgs.pyright
        pkgs.alejandra
        pkgs.alacritty
        pkgs.mkalias
        pkgs.keepassxc
        pkgs.tmux
        pkgs.neovim
        pkgs.stow
        pkgs.age
        pkgs.chezmoi
        pkgs.ripgrep
        pkgs.fzf
      ];
      homebrew = {
        enable = true;
        brews = [
          "mas" # allows to search and install app store apps
        ];
        casks = [
          "firefox"
          "proton-drive"
          "spotify"
        ];

        # app store apps
        # masApps =  {"Yoink" = 4676...; };
        onActivation.cleanup = "zap";
        onActivation.autoUpdate = true;
        onActivation.upgrade = true;
      };

      fonts.packages = [
        pkgs.nerd-fonts.jetbrains-mono
      ];

      # Necessary for using flakes on this system.
      nix.settings.experimental-features = "nix-command flakes";

      # Enable alternative shell support in nix-darwin.
      # programs.fish.enable = true;

      # Set Git commit hash for darwin-version.
      system.configurationRevision = self.rev or self.dirtyRev or null;

      # Used for backwards compatibility, please read the changelog before changing.
      # $ darwin-rebuild changelog
      system.stateVersion = 6;

      # System settings
      # Options can be found at: https://mynixos.com/nix-darwin/options/system.defaults
      system.defaults = {
        dock = {
          autohide = true;
          persistent-apps = [
            "${pkgs.alacritty}/Applications/Alacritty.app"
            "${pkgs.keepassxc}/Applications/KeePassXC.app"
            "/Applications/Firefox.app"
            "/System/Applications/Mail.app"
            "/System/Applications/Calendar.app"
          ];
        };

        finder.FXPreferredViewStyle = "clmv";
        loginwindow.GuestEnabled = true;
        NSGlobalDomain = {
          AppleICUForce24HourTime = true;
          AppleInterfaceStyle = "Dark";
          KeyRepeat = 2;
        };
      };

      # The platform the configuration will be used on.
      nixpkgs.hostPlatform = "aarch64-darwin";
    };
  in {
    # Build darwin flake using:
    # $ darwin-rebuild build --flake .#herbook
    darwinConfigurations = {
      herbook = nix-darwin.lib.darwinSystem {
        modules = [
          home-manager.darwinModules.home-manager
          homeManagerConfig
          mac-app-util.darwinModules.default
          configuration
          nix-homebrew.darwinModules.nix-homebrew
          {
            nix-homebrew = {
              # Install Homebrew under the default prefix
              enable = true;

              # Apple Silicon Only: Also install Homebrew under the default Intel prefix for Rosetta 2
              enableRosetta = true;

              # User owning the Homebrew prefix
              user = "hermes";

              # Optional: Declarative tap management
              taps = {
                "homebrew/homebrew-core" = homebrew-core;
                "homebrew/homebrew-cask" = homebrew-cask;
                "homebrew/homebrew-bundle" = homebrew-bundle;
              };

              # Optional: Enable fully-declarative tap management
              # With mutableTaps disabled, taps can no longer be added imperatively with `brew tap`.
              mutableTaps = false;
            };
          } # nix-homebrew ends
        ];
      }; # herbook ends
    };
  };
}
