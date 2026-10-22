{ pkgs }:
let
  inherit (import ./lib/shell.nix { inherit pkgs; }) mkShellConfig;
  inherit (import ../lib/libffi-fix.nix { inherit pkgs; }) withLibffiFix;
  python = pkgs.python314;
  pythonEnv = withLibffiFix (python.withPackages (
    ps: with ps; [
      # ruff
      # ipython
      # black
      # flake8
      # mypy
      # pytest
      # requests
      # poetry
    ]
  ));
in
mkShellConfig {
  name = "python-dev";

  packages = with pkgs; [
    pythonEnv
    poetry

  ];

  shellHook = ''
    echo "Welcome to Python development environment!"
    echo "  python: "(python --version)
    echo "  poetry: "(poetry --version)
  '';
}
