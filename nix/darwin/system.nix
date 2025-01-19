{
  lib,
  pkgs,
  config,
  ...
}:

{
  system = {
    defaults = {
      dock = {
        autohide = true;
        mru-spaces = false;
        minimize-to-application = true;
      };
      NSGlobalDomain = {
        AppleShowAllExtensions = true;
        InitialKeyRepeat = 15;
        KeyRepeat = 2;
      };
    };

  };

  fonts.packages = with pkgs; [
    # sketchybar-app-font
    # sf-mono-liga-bin
    # sf-symbols-font

    # name of nerdfonts see {https://github.com/NixOS/nixpkgs/blob/nixos-24.11/pkgs/data/fonts/nerdfonts/shas.nix}
    nerd-fonts.jetbrains-mono
    nerd-fonts.fira-code
    nerd-fonts.hack
    nerd-fonts.symbols-only
  ];

}
