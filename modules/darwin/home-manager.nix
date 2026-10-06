{
  config,
  pkgs,
  lib,
  home-manager,
  ...
}: let
  user = "hermes";
  # Define the content of your file as a derivation
  sharedFiles = import ../shared/files.nix {inherit config pkgs;};
  additionalFiles = import ./files.nix {inherit user config pkgs;};
in {
  imports = [
    ./dock
  ];

  # It me
  users.users.${user} = {
    name = "${user}";
    home = "/Users/${user}";
    isHidden = false;
    shell = pkgs.zsh;
  };

  homebrew = {
    enable = true;
    # Declare nix-homebrew's taps in the Brewfile; otherwise `brew bundle --cleanup`
    # untaps them, force-uninstalling every cask/formula that came from them.
    taps = builtins.attrNames config.nix-homebrew.taps;
    casks = pkgs.callPackage ./casks.nix {};
    brews = [
      # Work Specific
      "freetype"
      "imagemagick"
      "zbar"
      "weasyprint"
      "esphome"
      "avivsinai/tap/bitbucket-cli"
      # "msodbcsql18"
      # "mssql-tools18"
    ];
    # extraConfig = ''
    #   module Utils
    #     ENV['HOMEBREW_ACCEPT_EULA']='y'
    #   end
    #   brew "mssql-tools"
    # '';

    # https://mynixos.com/nix-darwin/option/homebrew.onActivation.cleanup
    onActivation.cleanup = "zap";
    onActivation.autoUpdate = true;
    onActivation.upgrade = true;

    # These app IDs are from using the mas CLI app
    # mas = mac app store
    # https://github.com/mas-cli/mas
    #
    # $ nix shell nixpkgs#mas
    # $ mas search <app name>
    #
    # If you have previously added these apps to your Mac App Store profile (but not installed them on this system),
    # you may receive an error message "Redownload Unavailable with This Apple ID".
    # This message is safe to ignore. (https://github.com/dustinlyons/nixos-config/issues/83)

    # masApps = {
    #   "1password" = 1333542190;
    #   "wireguard" = 1451685025;
    # };
  };

  # Enable home-manager
  home-manager = {
    useGlobalPkgs = true;
    users.${user} = {
      pkgs,
      config,
      lib,
      ...
    }: {
      home = {
        enableNixpkgsReleaseCheck = false;
        packages = pkgs.callPackage ./packages.nix {};
        file = lib.mkMerge [
          sharedFiles
          additionalFiles
        ];

        stateVersion = "25.05";
      };
      # Copy (not symlink) apps into ~/Applications/Home Manager Apps so Spotlight indexes them.
      targets.darwin = {
        linkApps.enable = false;
        copyApps.enable = true;
      };
      programs = {} // import ../shared/home-manager.nix {inherit config pkgs lib;};

      # Marked broken Oct 20, 2022 check later to remove this
      # https://github.com/nix-community/home-manager/issues/3344
      manual.manpages.enable = false;
    };
  };

  # Fully declarative dock (Nix apps via home-manager copyApps)
  local = {
    dock = {
      enable = true;
      entries = [
        {path = "/Applications/Firefox.app";}
        {path = "/Applications/Obsidian.app";}
        {path = "/Applications/Ghostty.app";}
        {path = "/Applications/Claude.app";}
        {path = "${config.users.users.${user}.home}/Applications/Home Manager Apps/PyCharm.app";}
        {path = "${config.users.users.${user}.home}/Applications/Home Manager Apps/KeePassXC.app";}
        {path = "/System/Applications/Calendar.app";}
        {path = "/System/Applications/Mail.app";}
        {path = "/Applications/Spotify.app";}
        {path = "/Applications/Signal.app";}
        {path = "/System/Applications/Apps.app";}
        {
          path = "${config.users.users.${user}.home}/Documents/";
          section = "others";
          options = "--sort name --view list --display folder";
        }
        {
          path = "${config.users.users.${user}.home}/Downloads/";
          section = "others";
          options = "--sort dateadded --view fan --display folder";
        }
        {
          path = "${config.users.users.${user}.home}";
          section = "others";
          options = "--sort name --view list --display folder";
        }
      ];
    };
  };
}
