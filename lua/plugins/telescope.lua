-- ~/.config/nvim/lua/plugins/telescope.lua

return {
    "nvim-telescope/telescope.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
        local telescope = require("telescope")

        telescope.setup({
            defaults = {
                layout_config = { prompt_position = "top" },
                sorting_strategy = "ascending",
                prompt_prefix = "🔍 ",
                selection_caret = "➤ ",
            },
        })
    end,
}
