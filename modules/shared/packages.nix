{pkgs}:
with pkgs; [
  # shared packages
  # SKIP 3

  # Office & Productivity
  # flameshot
  libqalculate
  qrencode
  drawio
  pandoc
  diff-pdf
  #  protonmail-bridge

  # SA unixODBCDrivers.msodbcsql18
  unixODBCDrivers.psql
  unixODBC
  uwsgi
  gobject-introspection
  glib

  # General packages for development and system management

  # openssh
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
  zip
  wget

  # development # TODO: move the separate dev file and exclude from servers
  gitleaks
  awscli2
  #  SSM is needed for interactive execution in AWS
  ssm-session-manager-plugin
  sqlite
  litecli
  pgcli
  hurl
  httpie
  bruno
  ripgrep
  jetbrains.pycharm

  # Encryption and security tools
  age
  gnupg
  libfido2
  # dbeaver-bin

  # Corporate
  #localstack

  # Cloud-related tools and SDKs
  # docker
  lazydocker

  # Media-related packages
  # imagemagick
  qpdf
  poppler-utils # used for cli pdfinfo tool
  ffmpeg
  fd
  dejavu_fonts
  font-awesome
  hack-font
  noto-fonts
  noto-fonts-color-emoji
  meslo-lgs-nf

  # IDE
  opencode
  # xmlstarlet
  nixpacks
  nodePackages.tailwindcss
  nodePackages.prettier
  nodejs
  # dockerfile-language-server-nodejs # deprecated name
  dockerfile-language-server
  nil
  ltex-ls
  tailwindcss-language-server
  bash-language-server
  lua-language-server
  typescript-language-server
  vue-language-server
  alejandra
  neovim
  tmux
  fzf
  zoxide # cd replacement
  ripgrep # grep replacement
  eza # ls replacement
  fd # find replacement
  bat # cat replacement
  yazi

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
  # poetry
  # poetryPlugins.poetry-plugin-export
  python312Packages.python-dotenv
  python3
  uv
  gettext
  basedpyright
  # pyright
  black
  ruff
]
