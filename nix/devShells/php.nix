{ pkgs }:
let
  inherit (import ./lib/shell.nix { inherit pkgs; }) mkShellConfig;
in
mkShellConfig {
  name = "php-dev";

  packages = with pkgs; [
    # PHP with common extensions
    php84
    php84Packages.composer
  ];

  # Environment variables
  env = { };

  shellHook = ''
    echo "Welcome to PHP development environment!"
    echo "  php: "(php -v | head -1)
    echo "  composer: "(composer --version)
  '';
}
