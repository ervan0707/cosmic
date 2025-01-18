{ inputs, pkgs }:
{
  utils = import ./utils.nix {
    inherit inputs pkgs;
  };
}
