-- ~/.config/nvim/lua/plugins/harpoon.lua

return {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
        local harpoon = require("harpoon")
        
        -- REQUIRED: Setup harpoon
        harpoon:setup()
    end,
    -- Keymaps are defined in lua/core/keymaps.lua
}
