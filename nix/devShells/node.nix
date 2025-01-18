{ pkgs }:
let
  inherit (import ./lib/shell.nix { inherit pkgs; }) mkShellConfig;
  inherit (import ./lib/versions.nix) nodeVersions;

  # Helper function to create Node.js development shell
  mkNodeShell =
    nodeVersion:
    let
      nodejs = pkgs."nodejs_${nodeVersion}";
    in
    mkShellConfig {
      name = "node-${nodeVersion}-dev";

      packages = with pkgs; [
        nodejs
        nodePackages.pnpm
        nodePackages.typescript
      ];

      env = {
        NODE_ENV = "development";
        NPM_CONFIG_PREFIX = "$PWD/.npm-global";
        PATH = "$PWD/node_modules/.bin:$PATH";
      };

      shellHook = ''
        echo "🚀 Welcome to Node.js ${nodeVersion} development environment!"
        echo "Available tools:"
        echo "  - node:" (node --version)
        echo "  - pnpm:" (pnpm --version)
        echo "  - typescript:" (tsc --version)
      '';
    };
in
{
  # Default to latest LTS (node 20)
  default = mkNodeShell "20";
}
// builtins.listToAttrs (
  map (version: {
    name = "node_${version}";
    value = mkNodeShell version;
  }) nodeVersions
)
