{
  pkgs,
  lib ? pkgs.lib,
  ...
}:
let
  inherit (import ./lib/shell.nix { inherit pkgs; }) mkShellConfig;

  # Get available Node.js versions
  nodejsVersions = builtins.filter (lib.strings.hasPrefix "nodejs_") (builtins.attrNames pkgs);

  # Helper function to create Node.js development shell
  mkNodeShell =
    nodeVersion:
    let
      nodejs = pkgs.${nodeVersion}; # Use the full package name directly
    in
    mkShellConfig {
      name = "${nodeVersion}-dev";

      packages = with pkgs; [
        nodejs
        nodePackages.typescript
      ];

      env = {
        NODE_ENV = "development";
        NPM_CONFIG_PREFIX = "$PWD/.npm-global";
        PATH = "$PWD/node_modules/.bin:$PATH";
      };

      shellHook = ''
        echo "🚀 Welcome to ${nodeVersion} development environment!"
        echo "Available tools:"
        echo "  - node:" (node --version)
        echo "  - typescript:" (tsc --version)
      '';
    };
in
{
  # Default to latest LTS (node 20)
  default = mkNodeShell "nodejs_20";
}
// builtins.listToAttrs (
  map (version: {
    name = version;
    value = mkNodeShell version;
  }) nodejsVersions
)
