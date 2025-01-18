vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- optionally enable 24-bit colour
vim.opt.termguicolors = true
vim.cmd([[
  set completeopt=menuone,noinsert,noselect
  highlight! default link CmpItemKind CmpItemMenuDefault
  set number
  set relativenumber
  set shiftwidth=2
]])

require("config.core.options")
require("config.core.ui")
require("config.core.lsp")
require("config.plugins.telescope")
require("config.plugins.nvim-tree")
require("config.plugins.git")
require("config.core.keymaps")
