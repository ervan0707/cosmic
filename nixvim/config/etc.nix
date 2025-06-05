{ pkgs, ... }:
{
  plugins.smear-cursor.enable = true;
  plugins.comment.enable = true;
  plugins.treesitter = {
    enable = true;
    settings = {
      highlight = {
        enable = true;
        additional_vim_regex_highlighting = false;
      };
      indent = {
        enable = true;
      };
      fold = {
        enable = true;
      };
    };
  };

  extraPlugins = with pkgs.vimPlugins; [
    nvim-treesitter.withAllGrammars

    # (pkgs.vimUtils.buildVimPlugin {
    #   name = "codestats";
    #   src = pkgs.fetchFromGitHub {
    #     owner = "ervan0707";
    #     repo = "codestats.nvim";
    #     rev = "v1.1.1";
    #     hash = "sha256-ZV5dEA7YFOOCkXKTFsYTBRJmRQvYZy+AAqsQHWxppa4=";
    #   };
    #   dependencies = with pkgs.vimPlugins; [
    #     plenary-nvim
    #     nui-nvim
    #   ];
    #
    # })
  ];

  # require('codestats').setup({
  #     api_url = 'https://exp.seni.cloud/api',
  #     username = 'ervan',
  #     api_key = os.getenv("CODESTATS_API_KEY") or "",
  #     excluded_filetypes = { 'log' },
  #     pulse_interval = 10000,
  # })

  extraConfigLua = ''
    vim.opt.clipboard:append("unnamedplus")

    -- enable elite mode
    vim.g.elite_mode = 1

    vim.opt.list = true

    vim.opt.listchars = "eol:↩,nbsp:+,tab:⦙ ,trail:-"

    -- Additional folding settings
    vim.opt.foldmethod = "expr"
    vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
    vim.opt.foldenable = false  -- Disable folding at startup
    vim.opt.foldlevel = 99

    -- Custom fold text
    function CustomFoldText()
        -- Get first line of fold
        local firstLine = vim.fn.getline(vim.v.foldstart)

        -- Get the number of folded lines
        local foldedLineCount = vim.v.foldend - vim.v.foldstart + 1

        -- Remove any existing fold markers
        local clean_line = firstLine:gsub("{{{", ""):gsub("}}}", "")

        -- Construct your custom fold text
        local fold_text = string.format("%s [%d lines]",  clean_line, foldedLineCount)

        return fold_text
    end

    -- Set the custom fold text
    vim.opt.foldtext = "v:lua.CustomFoldText()"

    local function close_all_folds()
      vim.api.nvim_exec2("%foldc!", { output = false })
    end
    local function open_all_folds()
      vim.api.nvim_exec2("%foldo!", { output = false })
    end

    vim.keymap.set("n", "<leader>zs", close_all_folds, { desc = "[s]hut all folds" })
    vim.keymap.set("n", "<leader>zo", open_all_folds, { desc = "[o]pen all folds" })


  '';

  plugins.snacks.enable = true;
  plugins.snacks.settings = {
    indent = {
      enable = true;
      char = "│";
      scope = {
        hl = "Normal";
      };
    };
    scope = { };

  };

  plugins.ts-autotag.enable = true;

  plugins.nvim-autopairs = {
    enable = true;
    settings = {
      disable_filetype = [
        "TelescopePrompt"
        "vim"
      ];
    };

  };

}
