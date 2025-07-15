-- ~/.config/nvim/lua/plugins/harpoon.lua

local mark = require("harpoon.mark")
local ui = require("harpoon.ui")

local map = vim.keymap.set
map("n", "<leader>a", mark.add_file, { desc = "Harpoon Add File" })
map("n", "<leader>h", ui.toggle_quick_menu, { desc = "Harpoon Menu" })
map("n", "<leader>j", function() ui.nav_file(1) end, { desc = "Go to File 1" })
map("n", "<leader>k", function() ui.nav_file(2) end, { desc = "Go to File 2" })
map("n", "<leader>l", function() ui.nav_file(3) end, { desc = "Go to File 3" })
map("n", "<leader>;", function() ui.nav_file(4) end, { desc = "Go to File 4" })
