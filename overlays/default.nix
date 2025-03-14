{ inputs, ... }:
{
  flake.overlays.macos =
    final: prev:
    let
      inherit (prev.lib) attrsets;
      callPackage = prev.newScope { };
      packages = [ "sf-symbols" "r-auth" ];
    in
    attrsets.genAttrs packages (name: callPackage ./${name}.nix { })
    // {
      ruff = prev.ruff.overrideAttrs (old: {
        doCheck = false;
      });
      gitWithConfig = prev.callPackage ./pkgs/git.nix { };
      sbar_menus = prev.callPackage ./pkgs/sketchybar/helpers/menus { };
      sbar_events = prev.callPackage ./pkgs/sketchybar/helpers/event_providers { };
      sbarLua = prev.callPackage ./pkgs/sketchybar/helpers/sbar.nix { };
      sketchybarConfigLua = prev.callPackage ./pkgs/sketchybar { };
      sf-symbols-font = final.sf-symbols.overrideAttrs (old: {
        pname = "sf-symbols-font";
        installPhase = ''
          runHook preInstall
          mkdir -p $out/share/fonts
          cp -a Library/Fonts/* $out/share/fonts/
          runHook postInstall
        '';
        meta = old.meta // {
          description = "sf-symbols-font";
        };
      });
      sf-mono-liga-bin = prev.stdenvNoCC.mkDerivation (finalAttrs: {
        pname = "sf-mono-liga-bin";
        version = "7723040ef50633da5094f01f93b96dae5e9b9299";

        src = prev.fetchFromGitHub {
          owner = "shaunsingh";
          repo = "SFMono-Nerd-Font-Ligaturized";
          rev = finalAttrs.version;
          sha256 = "sha256-vPUl6O/ji4hHIH7/qSbUe7q1QdugE1D1ZRw92QcSSDQ=";
        };

        dontConfigure = true;
        installPhase = ''
          mkdir -p $out/share/fonts/opentype
          cp -R $src/*.otf $out/share/fonts/opentype
        '';
      });
      sketchybar-app-font = prev.stdenv.mkDerivation {
        name = "sketchybar-app-font";
        src = inputs.sketchybar-app-font;
        buildInputs = [
          final.nodejs
          final.nodePackages.svgtofont
        ];
        buildPhase = ''
          ln -s ${final.nodePackages.svgtofont}/lib/node_modules ./node_modules
          node ./build.js
        '';
        installPhase = ''
          mkdir -p $out/share/fonts
          cp -r dist/*.ttf $out/share/fonts
        '';
      };
    };
}
