{ pkgs, ... }:
{

  plugins.telescope = {
    enable = true;
    settings = {
      defaults = {
        file_ignore_patterns = [
          "^.git/"
          "^.mypy_cache/"
          "^__pycache__/"
          "^output/"
          "^data/"
          "%.ipynb"
        ];
        set_env = {
          COLORTERM = "truecolor";
        };
        vimgrep_arguments = [
          "rg"
          "-L"
          "--color=never"
          "--no-heading"
          "--with-filename"
          "--line-number"
          "--column"
          "--smart-case"
        ];
        prompt_prefix = "  | ";
        sorting_strategy = "ascending";
        selection_caret = "  ";
        entry_prefix = "  ";
        initial_mode = "insert";
        selection_strategy = "reset";
        layout_strategy = "horizontal";
        layout_config = {
          horizontal = {
            prompt_position = "top";
            preview_width = 0.55;
            results_width = 0.8;
          };
          vertical = {
            mirror = false;
          };
          width = 0.87;
          height = 0.80;
          preview_cutoff = 120;
        };

        file_sorter = {
          __raw = ''require("telescope.sorters").get_fuzzy_file'';
        };
        generic_sorter = {
          __raw = ''require("telescope.sorters").get_generic_fuzzy_sorter'';
        };
        path_display = [ "truncate" ];
        winblend = 0;
        border = [ ];
        borderchars = [
          "─"
          "│"
          "─"
          "│"
          "╭"
          "╮"
          "╯"
          "╰"
        ];
        color_devicons = true;

        file_previewer = {
          __raw = ''require("telescope.previewers").vim_buffer_cat.new'';
        };
        grep_previewer = {
          __raw = ''require("telescope.previewers").vim_buffer_vimgrep.new'';
        };
        qflist_previewer = {
          __raw = ''require("telescope.previewers").vim_buffer_qflist.new'';
        };

        buffer_previewer_maker = {
          __raw = ''require("telescope.previewers").buffer_previewer_maker'';
        };
      };
    };
  };
}
