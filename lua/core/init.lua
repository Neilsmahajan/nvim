-- lua/core/init.lua

-- Set leader keys BEFORE loading any plugins
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Add lazy.nvim to runtime path
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    error("lazy.nvim not found! Make sure it was cloned correctly.")
end
vim.opt.rtp:prepend(lazypath)

-- Load plugins (this will automatically load all plugin configs)
require("core.plugins")

-- Load basic settings and keymaps
require("core.options")
require("core.keymaps")
