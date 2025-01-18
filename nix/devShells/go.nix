{ pkgs }:
let
  inherit (import ./lib/shell.nix { inherit pkgs; }) mkShellConfig;
in
mkShellConfig {
  name = "go-dev";

  packages = with pkgs; [
    go
    gopls

    delve
    gotools
    air # Live reload
  ];

  shellHook = ''
    echo "🚀 Welcome to Go development environment!"
    echo "Available tools:"
    echo "  - go: $(go version)"
    echo "  - gopls: $(gopls version)"
    echo "  - dlv: $(dlv version)"
    echo "  - golangci-lint: $(golangci-lint --version)"
  '';
}
