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
    casks = pkgs.callPackage ./casks.nix {};
    brews = [
      "localstack"
      "poetry"
      # "msodbcsql18"
      # "mssql-tools18"
    ];
    # extraConfig = ''
    #   module Utils
    #     ENV['HOMEBREW_ACCEPT_EULA']='y'
    #   end
    #   brew "mssql-tools"
    # '';

    onActivation.cleanup = "none";
    onActivation.autoUpdate = true;
    onActivation.upgrade = true;

    # onActivation.cleanup = "uninstall";

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

        stateVersion = "24.11";
      };
      programs = {} // import ../shared/home-manager.nix {inherit config pkgs lib;};

      # backupFileExtension = "hm-backup";
      # Marked broken Oct 20, 2022 check later to remove this
      # https://github.com/nix-community/home-manager/issues/3344
      manual.manpages.enable = false;
    };
  };

  # Fully declarative dock using the latest from Nix Store
  local = {
    dock = {
      enable = true;
      entries = [
        {path = "/Applications/Firefox.app";}
        {path = "/Applications/Ghostty.app";}
        {path = "/Applications/Logseq.app";}
        # {path = "${pkgs.alacritty}/Applications/Alacritty.app";}
        {path = "${pkgs.keepassxc}/Applications/KeePassXC.app";}
        {path = "${pkgs.jetbrains.pycharm-professional}/Applications/PyCharm.app";}
        {path = "/System/Applications/Calendar.app";}
        {path = "/System/Applications/Mail.app";}
        {path = "/Applications/Spotify.app";}
        {path = "/Applications/Signal.app";}
        {path = "/System/Applications/Launchpad.app";}
        {
          path = "${config.users.users.${user}.home}/Documents/";
          section = "others";
          options = "--sort name --view grid --display folder";
        }
        {
          path = "${config.users.users.${user}.home}/Downloads/";
          section = "others";
          options = "--sort dateadded --view fan --display folder";
        }
        {
          path = "${config.users.users.${user}.home}/.local/share/";
          section = "others";
          options = "--sort name --view grid --display folder";
        }
      ];
    };
  };
}
