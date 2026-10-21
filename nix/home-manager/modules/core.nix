{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:

{
  options.modules.core = {
    enable = lib.mkEnableOption "core configuration";
  };

  config = lib.mkIf config.modules.core.enable {
    programs.home-manager.enable = true;

    nix = {
      settings.experimental-features = [
        "nix-command"
        "flakes"
      ];
      nixPath = [ "nixpkgs=${inputs.nixpkgs}" ];
    };

    home = {
      stateVersion = "24.11";
      file.".hushlogin".text = "";
    };
  };
}
