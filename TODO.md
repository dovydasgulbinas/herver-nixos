# TODO.md
# TODO

## Macbook


- [ ] Add zsh varibales instead of the init script https://mynixos.com/nix-darwin/option/programs.zsh.variables
- [ ] Try removing `hraban/mac-app-util` since the home manager does the trampolines also

# Linux

- [ ] add update script and continue 24:00
- [ ] add dock config settings 00:00
    https://www.youtube.com/watch?v=Z8BL8mdzWHI

- Fix the LD issue https://nix.dev/guides/faq.html
- Create unatended boot using usb stick
- setup backups using borg
    - decide where to backup
    - write timer service
- Create secrets container for dotfiles and symlink all the secrets to it while execluting
- change the encrypted secondary drive key location to somewhere centralized (see hardwar conf) + ssh keyz


- [ ] Currently ssh keys are picked by using ~/.ssh/config which is very nixy
- [ ] Create export script:
    - `/root/wd_sa510.key`
    - `/root/hardware-configuration.nix`

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

