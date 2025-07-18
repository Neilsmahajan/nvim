-- ~/.config/nvim/lua/core/keymaps.lua

local map = vim.keymap.set
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Normal mode
map("n", "<leader>w", ":w<CR>", { desc = "Save file" })
map("n", "<leader>q", ":q<CR>", { desc = "Quit window" })
map("n", "<leader>nh", ":nohl<CR>", { desc = "Clear highlights" })

-- Custom page down/up that centers the screen
vim.keymap.set("n", "<C-j>", "<C-d>zz", { desc = "Page down & center" })
vim.keymap.set("n", "<C-k>", "<C-u>zz", { desc = "Page up & center" })

-- Insert mode
map("i", "jk", "<Esc>", { desc = "Exit insert mode" })

-- Terminal mode
map("t", "<Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

-- Diagnostics
map("n", "<leader>e", vim.diagnostic.open_float, { desc = "Show diagnostics (float)" })
map("n", "[d", vim.diagnostic.goto_prev, { desc = "Previous diagnostic" })
map("n", "]d", vim.diagnostic.goto_next, { desc = "Next diagnostic" })

-- File Explorer (netrw)
map("n", "<leader>fe", ":Ex<CR>", { desc = "Open file explorer" })

-- LSP features
map("n", "gd", vim.lsp.buf.definition, { desc = "Go to definition" })
map("n", "K", vim.lsp.buf.hover, { desc = "Hover documentation" })
map("n", "<leader>rn", vim.lsp.buf.rename, { desc = "Rename symbol" })
map("n", "<leader>ca", vim.lsp.buf.code_action, { desc = "Code action" })

-- Telescope
map("n", "<leader>fs", require("telescope.builtin").grep_string, { desc = "Search word under cursor" })
map("n", "<leader>fr", require("telescope.builtin").oldfiles, { desc = "Find recent files" })
map("n", "<leader>fc", require("telescope.builtin").commands, { desc = "Command palette" })

-- Reload config
map("n", "<leader>rr", ":so ~/.config/nvim/init.lua<CR>", { desc = "Reload Neovim config" })

-- Copilot Accept Suggestion
vim.keymap.set("i", "<C-J>", 'copilot#Accept("<CR>")', {
    expr = true,
    replace_keycodes = false,
    silent = true,
    desc = "Accept Copilot suggestion",
})
