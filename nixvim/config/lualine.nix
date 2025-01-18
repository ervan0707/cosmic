{ pkgs, ... }:
{
  plugins.lualine = {
    enable = true;

    settings = {
      options = {
        theme = "gruvbox";
        icons_enabled = true;
        disabled_filetypes = {
          __unkeyed-1 = "startify";
          __unkeyed-2 = "neo-tree";
          statusline = [
            "dap-repl"
          ];
          winbar = [
            "aerial"
            "dap-repl"
            "neotest-summary"
          ];
        };
        globalstatus = true;
        section_separators = {
          left = "";
          right = "";
        };
        component_separators = {
          left = "";
          right = "";
        };
      };
      sections = {
        lualine_a = [
          "mode"
        ];
        lualine_b = [
          "branch"
        ];
        lualine_c = [
          {
            __unkeyed-1 = "filename";
            file_status = true;
            path = 0;
          }
        ];
        lualine_x = [
          "diagnostics"
          {
            __unkeyed-1 = {
              __raw = ''
                function()
                    local msg = ""
                    local buf_ft = vim.api.nvim_buf_get_option(0, 'filetype')
                    local clients = vim.lsp.get_active_clients()
                    if next(clients) == nil then
                        return msg
                    end
                    for _, client in ipairs(clients) do
                        local filetypes = client.config.filetypes
                        if filetypes and vim.fn.index(filetypes, buf_ft) ~= -1 then
                            return client.name
                        end
                    end
                    return msg
                end
              '';
            };
            color = {
              fg = "#a89984"; # gruvbox text color
            };
            icon = " ";
          }
          "encoding"
          "fileformat"
          "filetype"
        ];
        lualine_y = [ "progress" ];
        lualine_z = [ "location" ];
      };
      # tabline = {
      #   lualine_a = [
      #     {
      #       __unkeyed-1 = "buffers";
      #       symbols = {
      #         alternate_file = "";
      #       };
      #     }
      #   ];
      #   lualine_z = [
      #     "tabs"
      #   ];
      # };
      # winbar = {
      #   lualine_c = [
      #     {
      #       __unkeyed-1 = "navic";
      #     }
      #   ];
      #   # lualine_x = [
      #   #   {
      #   #     __unkeyed-1 = "filename";
      #   #     newfile_status = true;
      #   #     path = 3;
      #   #     shorting_target = 150;
      #   #   }
      #   # ];
      # };
    };
  };
}
