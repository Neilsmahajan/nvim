-- ~/.config/nvim/lua/core/options.lua (updated)

local opt = vim.opt

opt.number = true
opt.relativenumber = true
opt.mouse = "a"
opt.clipboard = "unnamedplus"
opt.tabstop = 4
opt.shiftwidth = 4
opt.expandtab = true
opt.autoindent = true
opt.smartindent = true
opt.wrap = false
opt.termguicolors = false
opt.splitright = true
opt.splitbelow = true
opt.scrolloff = 8
opt.signcolumn = "yes"
opt.cursorline = true
opt.updatetime = 250
opt.timeoutlen = 300

-- ── Language-specific indentation ──────────────────────────
-- Any filetype in this list will use 2-space indents;
-- everything else keeps the global 4-space setting above.
vim.api.nvim_create_autocmd("FileType", {
    pattern = {
        "javascript", "javascriptreact",
        "typescript", "typescriptreact",
        "json", "jsonc",
        "css", "scss", "html", "xml", -- add/remove to taste
    },
    callback = function()
        vim.opt_local.tabstop    = 2
        vim.opt_local.shiftwidth = 2
    end,
})
