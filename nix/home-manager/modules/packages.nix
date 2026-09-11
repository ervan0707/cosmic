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

        # Node 22.11.0, from the `nixpkgs-node` flake input (see flake.nix).
        # pkgs.nodejs_22 tracks nixpkgs-unstable and is 22.23.x.
        nodejsPinned = inputs.nixpkgs-node.legacyPackages.${pkgs.stdenv.hostPlatform.system}.nodejs_22;
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

        nodejsPinned # Node 22.11.0 — see nodejsPinned above
        typescript

        # SuperPath local dev (see superpath-mono docs/ONBOARDING.MD §4.1)
        # Yarn 1.22.22 (final Yarn Classic release) pinned to the same Node as
        # above — repo engines requires "22", and stock nixpkgs yarn bundles
        # Node 24, which fails the engine check.
        (yarn.override { nodejs = nodejsPinned; })
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
