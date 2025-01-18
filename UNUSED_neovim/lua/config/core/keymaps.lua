local wk = require("which-key")
wk.register({
  f = {
    name = "Find/Files",
    f = { "<cmd>Telescope find_files<cr>", "Search for files in project" },
    s = { "<cmd>Telescope current_buffer_fuzzy_find<cr>", "Search text in current file" },
    d = { "<cmd>Telescope diagnostics<cr>", "Browse LSP diagnostics" },
    b = { "<cmd>NvimTreeToggle<cr>", "Toggle file explorer sidebar" },
    r = { "<cmd>Telescope oldfiles<cr>", "Open recent files" },
    w = { "<cmd>Telescope grep_string<cr>", "Search current word" },
    m = { "<cmd>Telescope marks<cr>", "Browse marks" },
    h = { "<cmd>Telescope help_tags<cr>", "Search help documentation" },
  },
  l = {
    name = "Search",
    g = { "<cmd>Telescope live_grep<cr>", "Search text across project (grep)" },
  },
  g = {
    name = "Git",
    b = { "<cmd>Telescope git_branches<cr>", "Switch Git branches" },
    c = { "<cmd>Telescope git_commits<cr>", "Browse git commits" },
    C = { "<cmd>Telescope git_bcommits<cr>", "Browse git commits for current file" },
    s = { "<cmd>Telescope git_status<cr>", "View git status" },
    S = { "<cmd>Telescope git_stash<cr>", "View stash items" },
  },
  s = {
    name = "Search Special",
    b = { "<cmd>Telescope buffers<cr>", "Find open buffers" },
    c = { "<cmd>Telescope commands<cr>", "Search available commands" },
    k = { "<cmd>Telescope keymaps<cr>", "Search keymappings" },
    r = { "<cmd>Telescope registers<cr>", "Search registers" },
    t = { "<cmd>Telescope treesitter<cr>", "Search treesitter symbols" },
    q = { "<cmd>Telescope quickfix<cr>", "Search quickfix list" },
    l = { "<cmd>Telescope loclist<cr>", "Search location list" },
    j = { "<cmd>Telescope jumplist<cr>", "Search jump list" },
  },
  c = {
    name = "Code",
    a = {
      require("actions-preview").code_actions,
      "Preview and apply code actions",
      mode = { "n", "v" },
    },
    s = { "<cmd>Telescope lsp_document_symbols<cr>", "Document symbols" },
    S = { "<cmd>Telescope lsp_workspace_symbols<cr>", "Workspace symbols" },
    r = { "<cmd>Telescope lsp_references<cr>", "Find references" },
    d = { "<cmd>Telescope lsp_definitions<cr>", "Go to definition" },
    i = { "<cmd>Telescope lsp_implementations<cr>", "Go to implementation" },
  },
}, { prefix = "<leader>" })
