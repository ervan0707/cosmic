{ pkgs, ... }:
{
  colorschemes.catppuccin = {
    enable = false;
    settings = {
      flavour = "frappe";
      background = {
        light = "latte";
        dark = "mocha";
      };
      transparent_background = false;
      show_end_of_buffer = false;
      term_colors = false;
      dim_inactive = {
        enabled = false;
        shade = "dark";
        percentage = 0.15;
      };
      no_italic = false;
      no_bold = false;
      no_underline = false;
      styles = {
        comments = [ "italic" ];
        conditionals = [ "italic" ];

      };

      default_integrations = true;
      integrations = {
        cmp = true;
        gitsigns = true;
        nvimtree = true;
        treesitter = true;
        notify = true;
        which_key = true;
        mini = {
          enabled = true;
          indentscope_color = "";
        };
      };
    };
  };

  colorschemes.gruvbox.enable = true;

  plugins.colorizer = {
    enable = true;
    settings = {
      filetypes = {
        __unkeyed-1 = "*";
        __unkeyed-2 = "!vim";
        css = {
          rgb_fn = true;
        };
        html = {
          names = false;
        };
      };
      user_commands = [
        "ColorizerToggle"
        "ColorizerReloadAllBuffers"
      ];
      user_default_options = {
        mode = "virtualtext";
        names = false;
        virtualtext = "■ ";
      };
    };
  };
  plugins.cursorline.enable = true;
}
