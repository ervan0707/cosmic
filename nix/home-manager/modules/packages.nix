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

        inherit (import ../../lib/libffi-fix.nix { inherit pkgs; }) withLibffiFix;
        gcloudFixed = withLibffiFix google-cloud-sdk;
        pythonFixed = withLibffiFix python314;
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

        nodejs_22 # tracks nixpkgs-unstable; superpath-mono deps need >=22.22.0
        typescript

        # SuperPath local dev (see superpath-mono docs/ONBOARDING.MD §4.1)
        # Yarn 1.22.22 (final Yarn Classic release) pinned to the same Node as
        # above — repo engines requires "22", and stock nixpkgs yarn bundles
        # Node 24, which fails the engine check.
        (yarn.override { nodejs = nodejs_22; })
        gcloudFixed # gcloud CLI (macOS 27 libffi fix, see nix/lib/libffi-fix.nix) — KMS decrypt of .env.*.enc + Firestore access
        firebase-tools  # firebase CLI — `firebase use` for the api set-env scripts

        phpWithExtensions
        composerWithPhp

        pythonFixed # Python 3.14 (macOS 27 libffi fix, see nix/lib/libffi-fix.nix) — `python` / `python3`

        pnpm
        # rustc
        # cargo
        # rustup
        glab

      ];
  };
}
