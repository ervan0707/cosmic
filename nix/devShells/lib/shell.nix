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
        # Save nix develop PATH before fish reinitializes it
        export __NIX_DEVELOP_PATH="$PATH"

        # Start fish, restore PATH priority, then run shell-specific hooks
        exec fish -C '
          set -gx PATH (string split ":" $__NIX_DEVELOP_PATH)
          set -e __NIX_DEVELOP_PATH
          ${shellHook}
        '
      '';
    };
}
