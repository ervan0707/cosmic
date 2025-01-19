{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:

{
  options.modules.packages = {
    enable = lib.mkEnableOption "packages configuration";
  };

  config = lib.mkIf config.modules.packages.enable {
    home.packages = with pkgs; [
      # ruff
      nerd-fonts.jetbrains-mono
      nerd-fonts.zed-mono

      tree
      bat

      fastfetch
      inputs.nixvim.packages.${pkgs.system}.default
    ];
  };
}
