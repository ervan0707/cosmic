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
        phpWithExtensions = php84.withExtensions ({ enabled, all }: enabled ++ [ all.mongodb ]);
        composerWithPhp = php84Packages.composer.override { php = phpWithExtensions; };
      in
      [
        # ruff
        nerd-fonts.jetbrains-mono
        nerd-fonts.zed-mono

        tree
        bat
        devenv

        # fastfetch
        # inputs.nixvim.packages.${pkgs.system}.default
        # pkgs.r-auth

        nodejs_22
        typescript

        # SuperPath local dev (see superpath-mono docs/ONBOARDING.MD §4.1)
        yarn            # Yarn 1.22.x — repo requires Yarn 1 (do NOT use Corepack/Yarn 4)
        google-cloud-sdk # gcloud CLI — KMS decrypt of .env.*.enc + Firestore access
        firebase-tools  # firebase CLI — `firebase use` for the api set-env scripts

        phpWithExtensions
        composerWithPhp

        pnpm
        # rustc
        # cargo
        # rustup
        glab

      ];
  };
}
