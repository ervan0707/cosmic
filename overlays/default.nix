{ ... }:
{
  flake.overlays.macos =
    final: prev:
    let
      inherit (prev.lib) attrsets;
      callPackage = prev.newScope { };
      packages = [ ];
    in
    attrsets.genAttrs packages (name: callPackage ./${name}.nix { })
    // {
      gitWithConfig = prev.callPackage ./pkgs/git.nix { };
      sbar_menus = prev.callPackage ../pkgs/sketchybar/helpers/menus { };
      sbar_events = prev.callPackage ../pkgs/sketchybar/helpers/event_providers { };
      sbarLua = prev.callPackage ../pkgs/sketchybar/helpers/sbar.nix { };
      sketchybarConfigLua = prev.callPackage ../pkgs/sketchybar { };
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
    };
}
