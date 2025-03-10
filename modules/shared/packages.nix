{pkgs}:
with pkgs; [
  # SA unixODBCDrivers.msodbcsql18
  unixODBCDrivers.psql
  unixODBC

  # General packages for development and system management
  inetutils
  gnumake
  keepassxc
  alacritty
  aspell
  aspellDicts.en
  bash-completion
  btop
  coreutils
  killall
  neofetch
  # openssh
  sqlite
  wget
  ripgrep
  zip

  # Encryption and security tools
  age
  gnupg
  libfido2

  # Cloud-related tools and SDKs
  docker

  # Media-related packages
  dejavu_fonts
  ffmpeg
  fd
  font-awesome
  hack-font
  noto-fonts
  noto-fonts-emoji
  meslo-lgs-nf

  # IDE
  # Node.js development tools
  nodePackages.npm # globally install npm
  nodePackages.prettier
  nodejs
  nil
  ltex-ls
  typescript-language-server
  vue-language-server
  alejandra
  pyright
  neovim
  ripgrep
  tmux
  zoxide
  bat
  fzf

  # Text and terminal utilities
  mkalias
  chezmoi
  stow
  htop
  hunspell
  iftop
  jq
  tree
  unrar
  unzip

  # Python packages
  python3
  uv
]
