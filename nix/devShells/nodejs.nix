{
  pkgs,
  inputs,
  lib ? pkgs.lib,
  ...
}:
let
  inherit (import ./lib/shell.nix { inherit pkgs; }) mkShellConfig;

  # Get available Node.js versions
  nodejsVersions = builtins.filter (lib.strings.hasPrefix "nodejs_") (builtins.attrNames pkgs);

  # Helper function to create Node.js development shell
  mkNodeShell =
    name: nodejs:
    mkShellConfig {
      name = "${name}-dev";

      packages = with pkgs; [
        nodejs
        typescript
      ];

      env = {
        NODE_ENV = "development";
        NPM_CONFIG_PREFIX = "$PWD/.npm-global";
      };

      shellHook = ''
        fish_add_path --prepend ${nodejs}/bin $PWD/node_modules/.bin
        echo "Welcome to ${name} development environment!"
        echo "  node: "(node --version)
        echo "  typescript: "(tsc --version)
        echo "  binary: "(which node)
      '';
    };
in
builtins.listToAttrs (
  map (version: {
    name = version;
    value = mkNodeShell version pkgs.${version};
  }) nodejsVersions
)
// {
  default = mkNodeShell "nodejs_22" pkgs.nodejs_22;
}
