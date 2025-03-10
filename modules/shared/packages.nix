{pkgs}:
with pkgs; [
  # shared packages

  # Office & Productivity
  libqalculate

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
  aspellDicts.lt
  bash-completion
  btop
  coreutils
  killall
  neofetch
  # openssh
  sqlite
  litecli
  pgcli
  wget
  hurl
  httpie
  bruno
  ripgrep
  zip

  # Encryption and security tools
  age
  gnupg
  libfido2

  # Cloud-related tools and SDKs
  docker
  lazydocker

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
  bash-language-server
  lua-language-server
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
