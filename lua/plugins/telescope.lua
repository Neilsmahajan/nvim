-- ~/.config/nvim/lua/plugins/telescope.lua

local telescope = require("telescope")
local builtin = require("telescope.builtin")

telescope.setup({
    defaults = {
        layout_config = { prompt_position = "top" },
        sorting_strategy = "ascending",
        prompt_prefix = "🔍 ",
        selection_caret = "➤ ",
    },
})

-- Keymaps for Telescope
local map = vim.keymap.set
map("n", "<leader>ff", builtin.find_files, { desc = "Find Files" })
map("n", "<leader>fg", builtin.live_grep, { desc = "Live Grep" })
map("n", "<leader>fb", builtin.buffers, { desc = "Find Buffers" })
map("n", "<leader>fh", builtin.help_tags, { desc = "Find Help" })
