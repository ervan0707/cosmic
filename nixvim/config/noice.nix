{ pkgs, ... }:
{
  plugins.notify.enable = true;
  plugins.noice = {
    enable = true;

    settings = {
      lsp = {
        override = {
          "vim.lsp.util.convert_input_to_markdown_lines" = true;
          "vim.lsp.util.stylize_markdown" = true;
          "cmp.entry.get_documentation" = true;
        };
        hover = {
          enabled = true;
          silent = false;
          view = null;
          opts = {
            border = {
              style = "rounded";
              padding = [
                0
                1
              ];
            };
            position = {
              row = 2;
              col = 0;
            };
            size = {
              max_width = 80;
              max_height = 20;
            };
          };
        };
        signature = {
          enabled = true;
          auto_open = {
            enabled = true;
            trigger = true;
            luasnip = true;
            throttle = 50;
          };
          view = null;
          opts = {
            border = {
              style = "rounded";
              padding = [
                0
                1
              ];
            };
            position = {
              row = 2;
              col = 0;
            };
          };
        };
      };
      presets = {
        bottom_search = true;
        command_palette = true;
        long_message_to_split = true;
        inc_rename = false;
        lsp_doc_border = false;
      };
      hover = {
        border = {
          style = "rounded";
          padding = [
            0
            1
          ];
        };
        position = {
          row = 2;
          col = 0;
        };
        size = {
          width = "auto";
          height = "auto";
          max_width = 80;
          max_height = 20;
        };
        win_options = {
          wrap = true;
          linebreak = true;
          winhighlight = {
            Normal = "Normal";
            FloatBorder = "NoiceCmdlinePopupBorder";
          };
        };
      };
    };

  };
}
