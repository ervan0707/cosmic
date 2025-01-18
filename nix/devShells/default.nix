{ pkgs }:
let
  inherit (import ./lib/shell.nix { inherit pkgs; }) mkShellConfig;
  inherit (import ./lib/versions.nix) nodeVersions;
  nodeEnvs = import ./node.nix { inherit pkgs; };

  # Helper function to create node environment attributes
  mkNodeAttrs =
    node:
    {
      "node" = node.default;
    }
    // builtins.listToAttrs (
      map (version: {
        name = "node_${version}";
        value = node."node_${version}";
      }) nodeVersions
    );
in
{
  go = import ./go.nix { inherit pkgs; };
  python = import ./python.nix { inherit pkgs; };
  rust = import ./rust.nix { inherit pkgs; };
  lua = import ./lua.nix { inherit pkgs; };
  php = import ./php.nix { inherit pkgs; };
  nix = import ./nix.nix { inherit pkgs; };
}
// mkNodeAttrs nodeEnvs
// {
  # Combined development environment with all tools
  default = mkShellConfig {
    name = "full-dev";

    packages = with pkgs; [

    ];

    inputsFrom = [
      (import ./go.nix { inherit pkgs; })
      nodeEnvs.default # Use default Node.js version
      (import ./python.nix { inherit pkgs; })
      (import ./rust.nix { inherit pkgs; })
      (import ./lua.nix { inherit pkgs; })
      (import ./php.nix { inherit pkgs; })
      (import ./nix.nix { inherit pkgs; })

    ];

    shellHook = ''
      echo "🚀 Welcome to the full development environment!"
      echo "All development tools are available."
    '';
  };
}
