{ pkgs }:
let
  inherit (pkgs)
    stdenv
    darwin
    symlinkJoin
    makeWrapper
    ;

  # macOS 27's dyld rejects nixpkgs' libffi-trampolines.dylib ("chained fixups,
  # seg_count exceeds number of segments"), so any ctypes callback in a Nix
  # Python aborts with `Assertion failed: (trampoline_handle)` — gcloud dies on
  # startup. Rebuild just that dylib without chained fixups and let each Python
  # find it first via DYLD_LIBRARY_PATH (dyld matches on the leaf name).
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
in
{
  # Wrap every binary in `pkg` so it loads the fixed dylib. No-op off Apple Silicon.
  withLibffiFix =
    pkg:
    if stdenv.hostPlatform.isDarwin && stdenv.hostPlatform.isAarch64 then
      symlinkJoin {
        inherit (pkg) name;
        paths = [ pkg ];
        nativeBuildInputs = [ makeWrapper ];
        postBuild = ''
          for bin in $out/bin/*; do
            [ -f "$bin" ] && [ -x "$bin" ] || continue
            wrapProgram "$bin" --prefix DYLD_LIBRARY_PATH : ${libffiTrampolinesFixed}/lib
          done
        '';
      }
    else
      pkg;
}
