{
  agenix,
  config,
  pkgs,
  ...
}: let
  user = "hermes";
in {
  imports = [
    ../../modules/darwin/secrets.nix
    ../../modules/darwin/home-manager.nix
    ../../modules/shared
    agenix.darwinModules.default
  ];

  # Setup user, packages, programs
  programs = {
    zsh.enable = true;
  };

  nix = {
    package = pkgs.nix;

    settings = {
      trusted-users = ["@admin" "${user}"];
      substituters = ["https://nix-community.cachix.org" "https://cache.nixos.org"];
      trusted-public-keys = ["cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="];
    };

    gc = {
      automatic = true;
      interval = {
        Weekday = 0;
        Hour = 2;
        Minute = 0;
      };
      options = "--delete-older-than 30d";
    };

    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };

  fonts.packages = with pkgs; [
    pkgs.nerd-fonts.jetbrains-mono
  ];

  # Turn off NIX_PATH warnings now that we're using flakes
  system.checks.verifyNixPath = false;

  # Load configuration that is shared across systems
  environment.systemPackages = with pkgs;
    [
      agenix.packages."${pkgs.system}".default
    ]
    ++ (import ../../modules/shared/packages.nix {inherit pkgs;});

  system = {
    stateVersion = 6;
    primaryUser = "root";

    defaults = {
      screencapture.location = "/Users/${user}/Pictures/Screenshots";
      NSGlobalDomain = {
        AppleShowAllExtensions = true;
        ApplePressAndHoldEnabled = false;
        AppleICUForce24HourTime = true;
        AppleInterfaceStyle = "Dark";
        AppleMetricUnits = 1;
        AppleMeasurementUnits = "Centimeters";
        AppleTemperatureUnit = "Celsius";

        # AppleLanguages = ["en" "lt"];
        # AppleLocale = "en_US";
        AppleKeyboardUIMode = 3; # Allow switching layouts with Caps L

        KeyRepeat = 2;
        InitialKeyRepeat = 15;

        "com.apple.mouse.tapBehavior" = 1;
        "com.apple.sound.beep.volume" = 0.0;
        "com.apple.sound.beep.feedback" = 0;
      };

      dock = {
        show-recents = false;
        launchanim = true;
        orientation = "bottom";
        tilesize = 48;
      };

      finder = {
        _FXShowPosixPathInTitle = false;
        FXPreferredViewStyle = "clmv";
        ShowPathbar = true;
        AppleShowAllFiles = true;
      };

      trackpad = {
        Clicking = true;
        TrackpadThreeFingerDrag = true;
      };
      loginwindow.GuestEnabled = true;
    };
  };
}
