# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{
  config,
  pkgs,
  ...
}: {
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
    dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
    localNetworkGameTransfers.openFirewall = true; # Open ports in the firewall for Steam Local Network Game Transfers
    gamescopeSession.enable = true;
  };

  networking.extraHosts = ''
    192.168.52.210  gitlab.snx.lt
    192.168.52.175  mex.snx.lt
    192.168.6.175   mex.snx.lv
    192.168.152.175 mex.snx.ee
    172.30.255.229  sentry.snx.lt
    192.168.152.210 rabbitmq.snx.ee
    192.168.52.217  rabbitmq.snx.lt
    192.168.52.220  rabbitmq-stg.snx.lt
    192.168.52.220  rabbitmq-stg-n1.snx.lt
    192.168.6.210   rabbitmq.snx.lv
    192.168.6.210   rabbitmq-n1.snx.lv
    192.168.6.211   rabbitmq-n2.snx.lv
    192.168.6.212   rabbitmq-n3.snx.lv
    192.168.152.215 rabbitmq-stg.snx.ee
    192.168.152.213 rabbitmq-stg-n1.snx.ee
    192.168.6.215   rabbitmq-stg.snx.lv
    192.168.6.213   rabbitmq-stg-n1.snx.lv
    192.168.6.214   rabbitmq-stg-n2.snx.lv
    192.168.6.215   rabbitmq-stg-n3.snx.lv
    192.168.52.185  asn.snx.lt
    192.168.52.189 snxdb
    192.168.52.164 mapper.snx.lt
    192.168.52.162 testing.snx.lt
  '';

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.initrd.luks.devices."luks-85b6b09e-b92a-445c-9e17-18812e0be54c".device = "/dev/disk/by-uuid/85b6b09e-b92a-445c-9e17-18812e0be54c";
  networking.hostName = "herpc"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # GPU
  # https://wiki.nixos.org/wiki/AMD_GPU
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  systemd.tmpfiles.rules = let
    rocmEnv = pkgs.symlinkJoin {
      name = "rocm-combined";
      paths = with pkgs.rocmPackages; [
        rocblas
        hipblas
        clr
      ];
    };
  in [
    "L+    /opt/rocm   -    -    -     -    ${rocmEnv}"
  ];

  hardware.graphics.extraPackages = with pkgs; [
    amdvlk
    rocmPackages.clr.icd
  ];
  # For 32 bit applications
  hardware.graphics.extraPackages32 = with pkgs; [
    driversi686Linux.amdvlk
  ];

  systemd.packages = with pkgs; [lact];
  systemd.services.lactd.wantedBy = ["multi-user.target"];
  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  #networking.enableIPv6 = false;
  # Firefox issue with slow resolution
  #boot.kernelParams = ["ipv6.disable=1"];
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Vilnius";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the GNOME Desktop Environment.
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;
  services.gnome.sushi.enable = true;

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  # move this to home.nix ???
  users.users.hermes = {
    isNormalUser = true;
    description = "hermes";
    extraGroups = ["networkmanager" "wheel" "docker"];
    packages = with pkgs; [
      davinci-resolve
      gnome-pomodoro
      discord
      pika-backup
      inkscape
      ghostty
      wl-clipboard
      spotify
      jetbrains.pycharm-professional
      keepassxc
      logseq
      alacritty
    ];
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMHq5vwlijTqC6sjOrL9C+Al1OBY8NFXnt4EBwy4PeZZ desktops-ansible"
    ];
  };

  # Install firefox.
  programs.firefox.enable = true;
  programs.neovim.enable = true;
  programs.neovim.defaultEditor = true;
  programs.neovim.viAlias = true;
  programs.neovim.vimAlias = true;

  programs.git.lfs.enable = true;
  programs.git = {
    config = {init = {defaultBranch = "main";};};
  };

  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [
    # Add any missing dynamic libraries for unpackaged programs
    # here, NOT in environment.systemPackages
    # packages needed for lua
    # libm.so.6
    # libdl.so.2
    # libgcc_s.so.1
    # libpthread.so.0
    # libc.so.6
    # ld-linux-x86-64.so.2
  ];

  # Enable zsh Shell more config is in home.nix
  users.defaultUserShell = pkgs.zsh;
  programs.zsh = {
    enable = true;
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
      plugins = ["git"];
      theme = "robbyrussell";
    };
  };

  # font list from: https://github.com/NixOS/nixpkgs/commit/de4dbc58fdeb84694d47d6c3f7b9f04a57cc4231
  fonts.packages = with pkgs; [
    (nerdfonts.override {fonts = ["FiraCode" "JetBrainsMono" "UbuntuMono"];})
  ];

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;
  environment.systemPackages = with pkgs; [
    nh
    lact
    python312Full
    python312Packages.pyodbc
    unixODBCDrivers.msodbcsql18
    unixODBCDrivers.psql
    unixODBC
    nix-index
    dig
    bat
    zoxide
    fzf
    zsh-autocomplete
    zsh
    hdparm
    pciutils
    lazydocker
    borgbackup
    tmux
    unzip
    ripgrep
    gcc
    gnumake
    neovim
    docker
    stow
    htop
    neofetch
    uv
    python3Full
    pre-commit
    alejandra
    git-lfs
    git
    wget
  ];

  # Automatic updating
  system.autoUpgrade.enable = true;
  system.autoUpgrade.dates = "weekly";

  # Experimental Features
  nix.settings.experimental-features = ["nix-command" "flakes"];

  # Automatic cleanup
  nix.gc.automatic = true;
  nix.gc.dates = "daily";
  nix.gc.options = "--delete-older-than 14d";
  nix.settings.auto-optimise-store = true;

  # Docker
  virtualisation.docker.enable = true;
  virtualisation.docker.daemon.settings = {dns = ["8.8.8.8" "1.1.1.1"];};

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  programs.mtr.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  # Enable the OpenSSH daemon.
  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = false;
      PermitRootLogin = "no";
    };
  };

  # https://search.nixos.org/options?channel=24.11&show=services.syncthing.settings.folders.%3Cname%3E.path&from=0&size=50&sort=relevance&type=packages&query=syncthing
  services = {
    syncthing = {
      enable = true;
      group = "users";
      user = "hermes";
      configDir = "/home/hermes/Documents/.host-data/herpc/.config/syncthing";
      dataDir = "/home/hermes";
      overrideDevices = true; # overrides any devices added or deleted through the WebUI
      overrideFolders = true; # overrides any folders added or deleted through the WebUI
      guiAddress = "0.0.0.0:8384";
      settings = {
        devices = {
          "herdell" = {id = "DYFKBB2-GCXOYSI-HHWWAXX-67YATXX-HQUU7XS-SBM5TRI-V3AJILW-YAGCHQR";};
          "herixel" = {id = "LIKTR5U-CWBRVZD-L6BVERY-YMWDBYG-KFJTL5D-3USURN7-GTBCRUK-MRRQNQE";};
          "hertab" = {id = "LXOMKEX-XIW6RU6-QCQHKI3-WWP5JZQ-MY5DJLN-NEI2PJF-YOOIRX3-OSGPLQE";};
          "herver" = {id = "F6MSVWZ-T6OMFMP-IES5HG2-DWQYQWK-GW6PIZV-OYJFWL6-O5BB3LB-7WPOWAU";};
        };
        folders = {
          "Desktop" = {
            id = "Desktop";
            path = "/home/hermes/Desktop";
            devices = ["herdell" "herver"];
          };
          "Documents" = {
            id = "Documents";
            path = "/home/hermes/Documents";
            devices = ["herdell" "herver"];
            ignorePerms = false;
          };
          "Shared" = {
            id = "Shared";
            path = "/home/hermes/Shared";
            devices = ["herdell" "hertab" "herixel" "herver"];
          };
          "Books" = {
            id = "Books";
            path = "/home/hermes/Books";
            devices = ["herdell" "hertab" "herixel" "herver"];
          };
        };
      };
    };
  };

  nixpkgs.config.permittedInsecurePackages = [
    "electron-27.3.11" # needed for logseq 0.10.9
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.11"; # Did you read the comment?
}
