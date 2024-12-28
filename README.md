# herver-nixos setup

## TODO:
    - [ ] Currently ssh keys are picked by using ~/.ssh/config which is very nixy
    - [ ] Root username is also not nixy, see `helpers/01_...sh`
    - [ ] Create export script:
        - `/root/wd_sa510.key`
        - `/root/hardware-configuration.nix`

## [Luks Encryption](https://nixos.wiki/wiki/Full_Disk_Encryption) on secondary drive:

### Option 2: Unlock after boot using crypttab and a keyfile

    
    sudo dd bs=512 count=4 if=/dev/random of=/root/wd_sa510.key iflag=fullblock
    sudo chmod 400 /root/wd_sa510.key
    sudo cryptsetup luksAddKey /dev/sda /root/wd_sa510.key

    # sudo blkid device uuid for wd_sa510.key
    # /dev/sda: UUID="5785082d-0616-4506-bc25-4b67aa0698ed" TYPE="crypto_LUKS"

