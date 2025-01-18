{ pkgs }:
let
  inherit (import ./lib/shell.nix { inherit pkgs; }) mkShellConfig;
in
mkShellConfig {
  name = "nix-dev";

  packages = with pkgs; [
  ];

  shellHook = ''
    echo "🚀 Welcome to Nix development environment!"
  '';
}
