cd /etc/nixos
sudo mkdir .git
sudo chown hermes:users .git
git config --global init.defaultBranch main
git config --global user.name "Dovydas Gulbinas"
git config --global user.email "dovydas.gulbinas@protonmail.com"
git config --global --add safe.directory /etc/nixos
git init
