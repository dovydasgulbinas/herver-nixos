{
  config,
  pkgs,
  ...
}: {
  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.initrd.luks.devices."luks-283da75c-5170-44c9-a9ea-8fbce82f7082".device = "/dev/disk/by-uuid/283da75c-5170-44c9-a9ea-8fbce82f7082";
  networking.hostName = "herver-nix";

  # ======= custom ========

  # Moved from hardware configuration
  boot.initrd.kernelModules = ["amdgpu"];

  # hdd for backups
  fileSystems."/mnt/herbook" = {
    device = "/dev/disk/by-uuid/c7386055-ac59-4407-b5f9-4132dba8407f";
    fsType = "ext4";
    options = [
      "nofail"
    ];
  };

  environment.etc.crypttab = {
    mode = "0600";
    text = ''
      # <volume-name> <encrypted-device> [key-file] [options]
      data_disk UUID=5785082d-0616-4506-bc25-4b67aa0698ed /root/wd_sa510.key
    '';
  };
  fileSystems."/mnt/data_disk" = {
    device = "/dev/mapper/data_disk";
    fsType = "ext4";
    options = [
      # If you don't have this options attribute, it'll default to "defaults"
      # boot options for fstab. Search up fstab mount options you can use
      "nofail" # Prevent system from failing if this drive doesn't mount
    ];
  };

  # =======================

  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  hardware.enableAllFirmware = true;

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Vilnius";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.hermes = {
    isNormalUser = true;
    description = "hermes";
    extraGroups = ["networkmanager" "wheel" "docker"];
    packages = with pkgs; [];
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMHq5vwlijTqC6sjOrL9C+Al1OBY8NFXnt4EBwy4PeZZ desktops-ansible"
    ];
  };

  # TODO: not really needed anymore?
  users.users."root".openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMHq5vwlijTqC6sjOrL9C+Al1OBY8NFXnt4EBwy4PeZZ desktops-ansible"
  ];

  programs.neovim.enable = true;
  programs.neovim.defaultEditor = true;
  programs.neovim.viAlias = true;
  programs.neovim.vimAlias = true;

  programs.git = {
    config = {init = {defaultBranch = "main";};};
  };

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
      plugins = ["git" "virtualenv"];
      theme = "robbyrussell";
    };
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;
  environment.systemPackages = with pkgs; [
    bat
    zoxide
    fzf
    zsh-autocomplete
    zsh
    hdparm
    pciutils
    lazydocker
    nodejs
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
    pre-commit
    alejandra
    git
    wget
  ];

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
      configDir = "/mnt/data_disk/cloud/Documents/.host-data/herver-nix/.config/syncthing"; # change this to /home/hermes/Documents/<host-name>/... on normal desktops
      dataDir = "/mnt/data_disk/cloud"; # on a desktop this should be /home/hermes since all dirs are relative to home
      overrideDevices = true; # overrides any devices added or deleted through the WebUI
      overrideFolders = true; # overrides any folders added or deleted through the WebUI
      guiAddress = "0.0.0.0:8384";
      settings = {
        devices = {
          "herbook" = {id = "LRALR6C-3TSPKUG-MLBQGIL-U3L3CYK-EDJQR4S-B27AI3K-CYEMTQR-Q2FDOAI";};
          "herdell" = {id = "DYFKBB2-GCXOYSI-HHWWAXX-67YATXX-HQUU7XS-SBM5TRI-V3AJILW-YAGCHQR";};
          "herixel" = {id = "LIKTR5U-CWBRVZD-L6BVERY-YMWDBYG-KFJTL5D-3USURN7-GTBCRUK-MRRQNQE";};
          "hertab" = {id = "LXOMKEX-XIW6RU6-QCQHKI3-WWP5JZQ-MY5DJLN-NEI2PJF-YOOIRX3-OSGPLQE";};
          "herpc" = {id = "STZYLIM-J23JNCO-FX3FJI2-SEQNWPB-4C36BYK-LMO7JKT-56VWOV4-QXYBCQR";};
        };
        folders = {
          "Desktop" = {
            path = "/mnt/data_disk/cloud/Desktop";
            devices = ["herdell"];
          };
          "Documents" = {
            path = "/mnt/data_disk/cloud/Documents";
            devices = ["herdell" "herbook"];
            ignorePerms = false;
          };
          "Shared" = {
            path = "/mnt/data_disk/cloud/Shared";
            devices = ["herdell" "hertab" "herixel"];
          };
          "Books" = {
            path = "/mnt/data_disk/media/books";
            devices = ["herdell" "hertab" "herixel"];
          };
        };
      };
    };

    samba = {
      settings = {
        "tm_share" = {
          "path" = "/mnt/data_disk/tm_share";
          "valid users" = "hermes";
          "public" = "no";
          "writeable" = "yes";
          "force user" = "hermes";
          "fruit:aapl" = "yes";
          "fruit:time machine" = "yes";
          "vfs objects" = "catia fruit streams_xattr";
        };
      };
    };
  };

  services.samba-wsdd = {
    enable = true;
    openFirewall = true;
  };

  networking.firewall.enable = true;
  networking.firewall.allowPing = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  system.stateVersion = "24.11";
}
