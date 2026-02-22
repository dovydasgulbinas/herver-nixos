# herver-nixos setup

installation:

	git clone https://github.com/dovydasgulbinas/herver-nixos.git ~/dotfiles && cd ~/dotfiles && ./stow-link.sh

change the remote origin from https to ssh:
    
    git remote set-url origin git@github.com:dovydasgulbinas/herver-nixos.git

## OSX installation

1. install rosseta 2:

    softwareupdate --install-rosetta

2. Install nix
    visit the official docs


3. Fix nix partiion permissions

```
sudo chown -R root:nixbld /nix
sudo chmod 0755 /nix
```

4. Add flake support and certs

    	echo "experimental-features = nix-command flakes" | sudo tee -a ~/.config/nix/nix.conf 
        echo "ssl-cert-file = /etc/ssl/cert.pem" | sudo tee -a ~/.config/nix/nix.conf 

5.  Restart the Daemon

	sudo launchctl kickstart -k system/org.nixos.nix-daemon

init nix flakes and nixos dawrin command:

    nix flake init -t nix-darwin --extra-experimental-features "nix-command flakes"
    # if first fails:  echo "experimental-features = nix-command flakes" | sudo tee -a /etc/nix/nix.conf && sudo launchctl kickstart -k system/org.nixos.nix-daemon
    nix run nix-darwin --extra-experimental-features "nix-command flakes" -- switch --flake ~/.config/nix#herbook

6. Install flake

	nix run .#build-switch

init chezmoi:

   chezmoi init dovydasgulbinas --apply


search for packages
    
    nix search nixpkgs tmux


verify nix installation:

    nix-shell -p nix-info --run "nix-info -m"
    nix-shell -p neofetch --run neofetch

sudo mkdir -p /etc/nix-darwin

init darwin (part of new init script, not needed because we have flake.nix)

    nix flake init -t nix-darwin --extra-experimental-features "nix-command flakes"

print Darwin hostname

    scutil --get LocalHostname

search a nix package:

    nix search nixpkgs tmux

get darwin nix documentation:
    
    darwin-help

stow the files:

     ./projectctl.sh link



## [Luks Encryption](https://nixos.wiki/wiki/Full_Disk_Encryption) on secondary drive:

### Option 2: Unlock after boot using crypttab and a keyfile


    sudo dd bs=512 count=4 if=/dev/random of=/root/wd_sa510.key iflag=fullblock
    sudo chmod 400 /root/wd_sa510.key
    sudo cryptsetup luksAddKey /dev/sda /root/wd_sa510.key

    # sudo blkid device uuid for wd_sa510.key
    # /dev/sda: UUID="5785082d-0616-4506-bc25-4b67aa0698ed" TYPE="crypto_LUKS"


add mount point config in hardware-configuration.nix

```
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
```
