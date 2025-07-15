-- ~/.config/nvim/lua/plugins/lualine.lua

require("lualine").setup({
    options = {
        theme = "auto",
        icons_enabled = true,
        section_separators = "",
        component_separators = "",
    },
    sections = {
        lualine_c = {
            {
                'filename',
                path = 1 -- 0 = just file name, 1 = relative path, 2 = absolute path
            }
        }
    }
})
