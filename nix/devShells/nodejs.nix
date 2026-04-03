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
      };

      shellHook = ''
        fish_add_path --prepend ${nodejs}/bin $PWD/node_modules/.bin
        echo "Welcome to ${nodeVersion} development environment!"
        echo "  node: "(node --version)
        echo "  typescript: "(tsc --version)
        echo "  binary: "(which node)
      '';
    };
in
{
  # Default to latest LTS (node 22)
  default = mkNodeShell "nodejs_22";
}
// builtins.listToAttrs (
  map (version: {
    name = version;
    value = mkNodeShell version;
  }) nodejsVersions
)
