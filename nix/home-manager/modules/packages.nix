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

        # macOS 27's dyld rejects nixpkgs' libffi-trampolines.dylib ("chained fixups,
        # seg_count exceeds number of segments"), so any ctypes callback in a Nix
        # Python aborts with `Assertion failed: (trampoline_handle)` — gcloud dies on
        # startup. Rebuild just that dylib without chained fixups and let gcloud's
        # Python find it first via DYLD_LIBRARY_PATH (dyld matches on the leaf name).
        # Drop this once nixpkgs' darwin libffi links it with -no_fixup_chains.
        libffiTrampolinesFixed = stdenv.mkDerivation {
          pname = "libffi-trampolines-no-fixup-chains";
          inherit (darwin.libffi) version src;
          buildPhase = ''
            cp darwin/include/fficonfig_arm64.h fficonfig.h
            $CC -Os -Wl,-allowable_client,! -Wl,-not_for_dyld_shared_cache -Wl,-no_compact_unwind \
              -Wl,-no_fixup_chains src/aarch64/trampoline.S -dynamiclib -o libffi-trampolines.dylib \
              -I. -Iinclude -Idarwin/include -I${darwin.libffi.dev}/include \
              -install_name "$out/lib/libffi-trampolines.dylib" \
              -Wl,-compatibility_version,1 -Wl,-current_version,1
          '';
          installPhase = "install -Dm755 libffi-trampolines.dylib $out/lib/libffi-trampolines.dylib";
        };
        gcloudFixed =
          if stdenv.hostPlatform.isDarwin && stdenv.hostPlatform.isAarch64 then
            symlinkJoin {
              name = "google-cloud-sdk-${google-cloud-sdk.version}";
              paths = [ google-cloud-sdk ];
              nativeBuildInputs = [ makeWrapper ];
              postBuild = ''
                for bin in $out/bin/*; do
                  [ -f "$bin" ] && [ -x "$bin" ] || continue
                  wrapProgram "$bin" --prefix DYLD_LIBRARY_PATH : ${libffiTrampolinesFixed}/lib
                done
              '';
            }
          else
            google-cloud-sdk;
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
        gcloudFixed # gcloud CLI (macOS 27 libffi fix above) — KMS decrypt of .env.*.enc + Firestore access
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
