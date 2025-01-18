{ pkgs, ... }:
let

  lua = pkgs.lua54Packages.lua.withPackages (ps: [
    ps.lua
    pkgs.sbarLua
    pkgs.sketchybarConfigLua
  ]);

in
{

  services = {
    sketchybar = {
      enable = false;

      extraPackages = with pkgs; [
        sbar_menus
        sbar_events
      ];

      config = # lua
        ''
          #!${lua}/bin/lua
          package.cpath = package.cpath .. ";${lua}/lib/?.so"
          require("init")
        '';
    };
  };

}
