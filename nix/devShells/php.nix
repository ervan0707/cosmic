{ pkgs }:
let
  inherit (import ./lib/shell.nix { inherit pkgs; }) mkShellConfig;
in
mkShellConfig {
  name = "php-dev";

  packages = with pkgs; [
    # PHP with common extensions
    php82
    php82Packages.composer
  ];

  # Environment variables
  env = { };

  shellHook = ''
    echo "🐘 Welcome to PHP development environment!"
    echo "Available tools:"
    echo "  - php: " (php -v)
    echo "  - composer: " (composer --version)
    echo ""
    echo "Xdebug is available for debugging"
    echo "PHP Language Server available via phpactor"
  '';
}
