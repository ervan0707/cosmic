{
  config,
  pkgs,
  isNixDarwin ? false,
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
  nix.enable = !(pkgs.stdenv.isDarwin && isNixDarwin);

  home = {
    inherit (config._module.args) username homeDirectory;
  };
}
