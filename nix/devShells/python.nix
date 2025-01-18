{ pkgs }:
let
  inherit (import ./lib/shell.nix { inherit pkgs; }) mkShellConfig;
  python = pkgs.python39;
  pythonEnv = python.withPackages (
    ps: with ps; [
      # ipython
      # black
      # flake8
      # mypy
      # pytest
      # requests
      # poetry
    ]
  );
in
mkShellConfig {
  name = "python-dev";

  packages = with pkgs; [
    pythonEnv
    poetry

  ];

  shellHook = ''
    echo "🚀 Welcome to Python development environment!"
    echo "Available tools:"
    echo "  - python: $(python --version)"
    echo "  - poetry: $(poetry --version)"
    # echo "  - black: $(black --version)"
  '';
}
