{ ... }:
{
  nix.optimise.automatic = true;
  nix.settings = {
    experimental-features = [
      "nix-command"
      "flakes"
    ];
    trusted-users = [
      "ervan"
      "ss"
      "nixos"
      "root"
    ];
  };
}
