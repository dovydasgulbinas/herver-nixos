{pkgs}:
with pkgs; [
  # shared packages
  # SKIP 3

  # Office & Productivity
  libqalculate
  qrencode
  # krita
  #  protonmail-bridge

  # SA unixODBCDrivers.msodbcsql18
  unixODBCDrivers.psql
  unixODBC

  # General packages for development and system management
  moreutils
  inetutils
  gnumake
  keepassxc
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

  # Corporate
  #localstack

  # Cloud-related tools and SDKs
  docker
  lazydocker

  # Media-related packages
  imagemagick
  ffmpeg
  fd
  dejavu_fonts
  font-awesome
  hack-font
  noto-fonts
  noto-fonts-emoji
  meslo-lgs-nf

  # IDE
  xmlstarlet
  nixpacks
  nodePackages.tailwindcss
  nodePackages.npm # globally install npm
  nodePackages.prettier
  nodejs
  nil
  ltex-ls
  dockerfile-language-server-nodejs
  tailwindcss-language-server
  bash-language-server
  lua-language-server
  typescript-language-server
  vue-language-server
  alejandra
  black
  pyright
  neovim
  ripgrep
  tmux
  zoxide
  bat
  fzf

  # Text and terminal utilities
  zsh-autocomplete
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
  poetry
  poetryPlugins.poetry-plugin-export
  python312Packages.python-dotenv
  python3
  uv
]
