-- require("supermaven-nvim").setup({
--   keymaps = {
--     accept_suggestion = "<Tab>",
--     clear_suggestion = "<C-]>",
--     accept_word = "<C-j>",
--   },
--   ignore_filetypes = { cpp = true }, -- or { "cpp", }
--   color = {
--     suggestion_color = "#ffffff",
--     cterm = 244,
--   },
--   log_level = "info", -- set to "off" to disable logging completely
--   disable_inline_completion = false, -- disables inline completion for use with cmp
--   disable_keymaps = false, -- disables built in keymaps for more manual control
--   condition = function()
--     return false
--   end, -- condition to check for stopping supermaven, `true` means to stop supermaven when the condition is true.
-- })

-- local function toggle_supermaven()
--   local api = require("supermaven-nvim.api")
--   if api.is_running() then
--     api.stop()
--     require("notify")("Supermaven is stopped")
--   else
--     api.start()
--     require("notify")("Supermaven is started")
--   end
-- end

-- vim.keymap.set("n", "<leader>s", toggle_supermaven, {
--   desc = "Toggle SuperMaven",
-- })

require("nvim-ts-autotag").setup({})

require("nvim-autopairs").setup({
  disable_filetype = { "TelescopePrompt", "vim" },
})

require('codestats').setup({
    api_url = 'https://exp.seni.cloud/api', -- default: 'https://codestats.net/api'
    username = 'ervan', -- Required
    api_key = os.getenv("CODESTATS_API_KEY") or "", -- Required
    excluded_filetypes = { 'log' },
    pulse_interval = 10000, -- milliseconds
})
