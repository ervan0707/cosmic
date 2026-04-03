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
        # Start fish with inherited environment and run fish-specific hooks
        exec fish -C '${shellHook}'
      '';
    };
}
