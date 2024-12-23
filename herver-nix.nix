# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
# {
#   config,
#   pkgs,
#   ...
# }: {
#   imports = [
#     # Include the results of the hardware scan.
#     ./hardware-configuration.nix
#     ./home.nix
#   ];
{
  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.initrd.luks.devices."luks-283da75c-5170-44c9-a9ea-8fbce82f7082".device = "/dev/disk/by-uuid/283da75c-5170-44c9-a9ea-8fbce82f7082";
  networking.hostName = "herver-nix";
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

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
    extraGroups = ["networkmanager" "wheel"];
    packages = with pkgs; [];
  };

  programs.nvim = {
    enable = false;
    defaultEditor = true; # Set Neovim as the default editor
    viAlias = true; # Alias `vi` to `nvim`
    vimAlias = true; # Alias `vim` to `nvim`
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    wget
    neovim
    git
    alejandra
    uv
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  programs.mtr.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh = {
    enable = true;
    settings = {
      # TODO: haden the security here
      PasswordAuthentication = true;
      PermitRootLogin = "yes";
    };
  };

  users.users."hermes".openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMHq5vwlijTqC6sjOrL9C+Al1OBY8NFXnt4EBwy4PeZZ desktops-ansible"
  ];

  users.users."root".openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMHq5vwlijTqC6sjOrL9C+Al1OBY8NFXnt4EBwy4PeZZ desktops-ansible"
  ];

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
