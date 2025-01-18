{ pkgs, config, ... }:
{
  services = {
    yabai = {
      enable = false;
      enableScriptingAddition = false;

      package = pkgs.yabai;
      config.layout = "bsp";
      config.window_placement = "second_child";
      config.window_gap = 15;
      config.top_padding = 12;
      config.bottom_padding = 12;
      config.left_padding = 12;
      config.right_padding = 12;
      config.mouse_follows_focus = "on";
      config.mouse_modifier = "alt";
      config.mouse_action1 = "move";
      config.mouse_action2 = "resize";
      config.mouse_drop_action = "swap";

      extraConfig = ''

        ${config.services.yabai.package}/bin/yabai -m rule --add app="^System Settings$" manage=off
        ${config.services.yabai.package}/bin/yabai -m rule --add app="^Calculator$" manage=off
        ${config.services.yabai.package}/bin/yabai -m rule --add app="^Karabiner-Elements$" manage=off
        ${config.services.yabai.package}/bin/yabai -m rule --add app="^QuickTime Player$" manage=off

      '';
    };
  };
}
