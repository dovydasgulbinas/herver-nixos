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
  ];

  shellHook = ''
    echo "welcome to the shell!"
  '';

  YOUARE = "hermes";

  LD_LIBRARY_PATH = "${pkgs.lib.makeLibraryPath [pkgs.ncurses]}";
}
