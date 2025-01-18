{ pkgs, ... }:
{

  plugins.bufferline = {
    enable = true;
    settings = {
      options = {
        mode = "buffers";
        offsets = [
          {
            filetype = "NvimTree";
            highlight = "Directory";
            text = "File Explorer";
            text_align = "center";
            separator = true;
          }
        ];
      };
    };
  };
}
