-- lua/core/init.lua

-- Add lazy.nvim to runtime path
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    error("lazy.nvim not found! Make sure it was cloned correctly.")
end
vim.opt.rtp:prepend(lazypath)

-- Load plugins
require("core.plugins")

-- (Optional) Load basic settings and keymaps here
require("core.options")
require("core.keymaps")
-- Load plugin configs
require("plugins.treesitter")
require("plugins.telescope")
require("plugins.lsp")
require("plugins.cmp")
require("plugins.harpoon")
require("plugins.lualine")
