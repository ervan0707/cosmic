{ pkgs, ... }:
{

  plugins.which-key = {
    enable = true;
  };
  extraConfigLua = ''
    local wk = require("which-key")

    wk.add({
      -- Find/Files group
      { "<leader>f", group = "Find/Files" },
      { "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "Search for files in project", mode = "n" },
      { "<leader>fs", "<cmd>Telescope current_buffer_fuzzy_find<cr>", desc = "Search text in current file", mode = "n" },
      { "<leader>fd", "<cmd>Telescope diagnostics<cr>", desc = "Browse LSP diagnostics", mode = "n" },
      { "<leader>fb", "<cmd>NvimTreeToggle<cr>", desc = "Toggle file explorer sidebar", mode = "n" },
      { "<leader>fr", "<cmd>Telescope oldfiles<cr>", desc = "Open recent files", mode = "n" },
      { "<leader>fw", "<cmd>Telescope grep_string<cr>", desc = "Search current word", mode = "n" },
      { "<leader>fm", "<cmd>Telescope marks<cr>", desc = "Browse marks", mode = "n" },
      { "<leader>fh", "<cmd>Telescope help_tags<cr>", desc = "Search help documentation", mode = "n" },

      -- Search group
      { "<leader>l", group = "Search" },
      { "<leader>lg", "<cmd>Telescope live_grep<cr>", desc = "Search text across project (grep)", mode = "n" },

      -- Git group
      { "<leader>g", group = "Git" },
      { "<leader>gb", "<cmd>Telescope git_branches<cr>", desc = "Switch Git branches", mode = "n" },
      { "<leader>gc", "<cmd>Telescope git_commits<cr>", desc = "Browse git commits", mode = "n" },
      { "<leader>gC", "<cmd>Telescope git_bcommits<cr>", desc = "Browse git commits for current file", mode = "n" },
      { "<leader>gs", "<cmd>Telescope git_status<cr>", desc = "View git status", mode = "n" },
      { "<leader>gS", "<cmd>Telescope git_stash<cr>", desc = "View stash items", mode = "n" },

      -- Search Special group
      { "<leader>s", group = "Search Special" },
      { "<leader>sb", "<cmd>Telescope buffers<cr>", desc = "Find open buffers", mode = "n" },
      { "<leader>sc", "<cmd>Telescope commands<cr>", desc = "Search available commands", mode = "n" },
      { "<leader>sk", "<cmd>Telescope keymaps<cr>", desc = "Search keymappings", mode = "n" },
      { "<leader>sr", "<cmd>Telescope registers<cr>", desc = "Search registers", mode = "n" },
      { "<leader>st", "<cmd>Telescope treesitter<cr>", desc = "Search treesitter symbols", mode = "n" },
      { "<leader>sq", "<cmd>Telescope quickfix<cr>", desc = "Search quickfix list", mode = "n" },
      { "<leader>sl", "<cmd>Telescope loclist<cr>", desc = "Search location list", mode = "n" },
      { "<leader>sj", "<cmd>Telescope jumplist<cr>", desc = "Search jump list", mode = "n" },

      -- Code group
      { "<leader>c", group = "Code" },
      { "<leader>ca", require("actions-preview").code_actions, desc = "Preview and apply code actions", mode = { "n", "v" } },
      { "<leader>cs", "<cmd>Telescope lsp_document_symbols<cr>", desc = "Document symbols", mode = "n" },
      { "<leader>cS", "<cmd>Telescope lsp_workspace_symbols<cr>", desc = "Workspace symbols", mode = "n" },
      { "<leader>cr", "<cmd>Telescope lsp_references<cr>", desc = "Find references", mode = "n" },
      { "<leader>cd", "<cmd>Telescope lsp_definitions<cr>", desc = "Go to definition", mode = "n" },
      { "<leader>ci", "<cmd>Telescope lsp_implementations<cr>", desc = "Go to implementation", mode = "n" },
    })
  '';
}
