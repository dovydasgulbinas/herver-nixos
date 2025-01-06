# herver-nixos setup

## TODO:
    - [ ] Currently ssh keys are picked by using ~/.ssh/config which is very nixy
    - [ ] Create export script:
        - `/root/wd_sa510.key`
        - `/root/hardware-configuration.nix`
    - [x] Root username is also not nixy, see `helpers/01_...sh`
    ```bash
    cd /etc/nixos
    sudo mkdir .git
    sudo chown hermes:users .git
    git config --global init.defaultBranch main
    git config --global user.name "Dovydas Gulbinas"
    git config --global user.email "dovydas.gulbinas@protonmail.com"
    git config --global --add safe.directory /etc/nixos
    git init
    ```

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
