{pkgs ? import <nixpkgs> {}}:
pkgs.mkShell {
  packages = [
    pkgs.python3
    pkgs.uv
    pkgs.shellcheck
    pkgs.alejandra
    pkgs.pre-commit
    pkgs.rustup
    pkgs.rustc
    pkgs.cargo
    pkgs.bashate
    pkgs.git
    pkgs.neovim
  ];

  shellHook = ''
    echo "DEV shell was invoked"
  '';

  LD_LIBRARY_PATH = "${pkgs.lib.makeLibraryPath [pkgs.ncurses]}";
}
