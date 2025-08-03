-- ~/.config/nvim/ftplugin/python.lua
-- Python-specific settings

-- Python PEP 8 indentation
vim.opt_local.tabstop = 4
vim.opt_local.shiftwidth = 4
vim.opt_local.softtabstop = 4
vim.opt_local.expandtab = true

-- Python-specific options
vim.opt_local.textwidth = 88  -- Black's default line length
vim.opt_local.colorcolumn = "88"
vim.opt_local.foldmethod = "indent"
vim.opt_local.foldlevel = 99

-- Enable spell checking for comments and strings
vim.opt_local.spell = true
vim.opt_local.spelllang = "en_us"

-- Python-specific abbreviations for common patterns
vim.cmd([[
    iabbrev <buffer> pdb import pdb; pdb.set_trace()
    iabbrev <buffer> ipdb import ipdb; ipdb.set_trace()
    iabbrev <buffer> pudb import pudb; pudb.set_trace()
    iabbrev <buffer> ifmain if __name__ == "__main__":
    iabbrev <buffer> #! #!/usr/bin/env python3
]])

-- Set up Python-specific keymaps that don't conflict with global ones
local map = vim.keymap.set
local opts = { buffer = true, silent = true }

-- Quick run Python file
map("n", "<leader>pr", ":!python3 %<CR>", vim.tbl_extend("force", opts, { desc = "Run Python file" }))

-- Quick pytest commands
map("n", "<leader>pt", ":!python3 -m pytest %<CR>", vim.tbl_extend("force", opts, { desc = "Run pytest on current file" }))
map("n", "<leader>pT", ":!python3 -m pytest<CR>", vim.tbl_extend("force", opts, { desc = "Run all pytest" }))

-- Python imports
map("n", "<leader>pi", "oimport ", vim.tbl_extend("force", opts, { desc = "Add import line" }))
map("n", "<leader>pf", "ofrom  import ", vim.tbl_extend("force", opts, { desc = "Add from import line" }))
