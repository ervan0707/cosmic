{
  pkgs,
  inputs,
  lib ? pkgs.lib,
  ...
}:
let
  inherit (import ./lib/shell.nix { inherit pkgs; }) mkShellConfig;

  # Node 22.11.0, from the `nixpkgs-node` flake input (see flake.nix).
  # pkgs.nodejs_22 tracks nixpkgs-unstable and is 22.23.x.
  nodejsPinned = inputs.nixpkgs-node.legacyPackages.${pkgs.stdenv.hostPlatform.system}.nodejs_22;

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

  pinnedShell = mkNodeShell "nodejs-22.11.0" nodejsPinned;
in
builtins.listToAttrs (
  map (version: {
    name = version;
    value = mkNodeShell version pkgs.${version};
  }) nodejsVersions
)
// {
  # Node 22 is pinned to 22.11.0 rather than tracking nixpkgs-unstable, so both
  # the default shell and `nodejs_22` come from the pinned input.
  nodejs_22 = pinnedShell;
  default = pinnedShell;
}
