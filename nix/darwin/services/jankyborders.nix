{ ... }:
{
  services = {
    jankyborders = {
      enable = true;

      style = "round";
      width = 10.0;
      hidpi = true;
      active_color = "0xffe1e3e4";
      inactive_color = "0xff494d64";

      blacklist = [
        "Loom"
        "Chrome"
      ];
    };
  };
}
