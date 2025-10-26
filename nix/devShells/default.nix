{
  pkgs,
  lib ? pkgs.lib,
  ...
}:
let
  inherit (import ./lib/shell.nix { inherit pkgs; }) mkShellConfig;
  nodeEnvs = import ./nodejs.nix { inherit pkgs; };

  # Get all nodejs versions directly
  nodejsVersions = builtins.filter (lib.strings.hasPrefix "nodejs_") (builtins.attrNames pkgs);
in
{
  go = import ./go.nix { inherit pkgs; };
  python = import ./python.nix { inherit pkgs; };
  rust = import ./rust.nix { inherit pkgs; };
  lua = import ./lua.nix { inherit pkgs; };
  php = import ./php.nix { inherit pkgs; };
  nix = import ./nix.nix { inherit pkgs; };
  nodejs = nodeEnvs.default;
}
// builtins.listToAttrs (
  map (version: {
    name = version;
    value = nodeEnvs.${version};
  }) nodejsVersions
)
// {
  # Combined development environment with all tools
  default = mkShellConfig {
    name = "full-dev";

    packages = with pkgs; [ ];

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
