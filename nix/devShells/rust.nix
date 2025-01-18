{ pkgs }:
let
  inherit (import ./lib/shell.nix { inherit pkgs; }) mkShellConfig;
in
mkShellConfig {
  name = "rust-dev";

  packages = with pkgs; [
    cargo
    rustc
  ];

  shellHook = ''
    echo "🚀 Welcome to Rust development environment!"
    echo "Available tools:"
    echo "  - rustc: $(rustc --version)"
    echo "  - cargo: $(cargo --version)"
    echo "  - rust-analyzer: $(rust-analyzer --version)"
  '';

}
