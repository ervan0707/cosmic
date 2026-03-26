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
    home.packages =
      with pkgs;
      let
        phpWithExtensions = php82.withExtensions ({ enabled, all }: enabled ++ [ all.mongodb ]);
        composerWithPhp = php82Packages.composer.override { php = phpWithExtensions; };
      in
      [
        # ruff
        nerd-fonts.jetbrains-mono
        nerd-fonts.zed-mono

        tree
        bat

        # fastfetch
        inputs.nixvim.packages.${pkgs.system}.default
        pkgs.r-auth

        nodejs_20
        typescript

        phpWithExtensions
        composerWithPhp

        pnpm
        # rustc
        # cargo
        # rustup

      ];
  };
}
