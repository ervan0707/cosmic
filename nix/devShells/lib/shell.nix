{ pkgs }:
{
  # Common shell configuration
  mkShellConfig =
    {
      name,
      packages ? [ ],
      env ? { },
      shellHook ? "",
      inputsFrom ? [ ],
    }:
    pkgs.mkShell {
      inherit name env inputsFrom;

      packages = [ pkgs.fish ] ++ packages;

      # Use fish as default shell
      shellHook = ''
        # Preserve all environment variables before switching to fish
        ${shellHook}

        # Start fish with inherited environment
        exec fish
      '';
    };
}
