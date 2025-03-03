{
  config,
  pkgs,
  isNixDarwin ? false,
  lib ? pkgs.lib,
  ...
}:

{
  imports = [ ./modules ];

  # Enable all modules
  modules = {
    core.enable = true;
    packages.enable = true;
    git.enable = true;
    fish.enable = true;
    tmux.enable = true;
    sops.enable = true;
  };

  # Disable nix package management in home-manager when using nix darin
  nix = lib.mkIf (!(pkgs.stdenv.isDarwin && isNixDarwin)) {
    enable = true;
  };

  home = {
    inherit (config._module.args) username homeDirectory;
  };
}
