-- ~/.config/nvim/lua/plugins/theme.lua

return {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    config = function()
        require("catppuccin").setup({
            flavour = "auto",
            background = {
                light = "latte",
                dark = "mocha",
            },
            transparent_background = false,
            show_end_of_buffer = false,
            term_colors = true,
            dim_inactive = {
                enabled = false,
            },
            no_italic = false,
            no_bold = false,
            no_underline = false,
            styles = {
                comments = { "italic" },
                conditionals = { "italic" },
                loops = {},
                functions = {},
                keywords = {},
                strings = {},
                variables = {},
                numbers = {},
                booleans = {},
                properties = {},
                types = {},
                operators = {},
            },
            integrations = {
                cmp = true,
                treesitter = true,
                telescope = true,
                harpoon = true,
                markdown = true,
                native_lsp = {
                    enabled = true,
                    virtual_text = {
                        errors = { "italic" },
                        hints = { "italic" },
                        warnings = { "italic" },
                        information = { "italic" },
                    },
                    underlines = {
                        errors = { "underline" },
                        hints = { "underline" },
                        warnings = { "underline" },
                        information = { "underline" },
                    },
                },
                dap = true,
                dap_ui = true,
            },
        })

        -- Function to detect system appearance on macOS
        local function get_system_appearance()
            local handle = io.popen("defaults read -g AppleInterfaceStyle 2>/dev/null")
            if handle then
                local result = handle:read("*a")
                handle:close()
                return result:match("Dark") and "dark" or "light"
            end
            return "light"
        end

        -- Function to apply theme
        local function apply_theme()
            local appearance = get_system_appearance()
            vim.o.background = appearance
            
            -- Clear any existing colorscheme
            vim.cmd("hi clear")
            if vim.fn.exists("syntax_on") then
                vim.cmd("syntax reset")
            end
            
            -- Apply catppuccin
            vim.cmd.colorscheme("catppuccin")
            
            -- Force treesitter highlight refresh
            vim.schedule(function()
                if vim.bo.filetype ~= "" then
                    vim.cmd("doautocmd FileType " .. vim.bo.filetype)
                end
            end)
        end

        -- Apply initial theme
        apply_theme()

        -- Create autocmd for system theme changes
        vim.api.nvim_create_autocmd({ "FocusGained", "VimEnter" }, {
            group = vim.api.nvim_create_augroup("ThemeSync", { clear = true }),
            callback = function()
                vim.defer_fn(function()
                    local current_bg = vim.o.background
                    local system_appearance = get_system_appearance()
                    
                    if current_bg ~= system_appearance then
                        apply_theme()
                        local theme_name = system_appearance == "dark" and "Catppuccin Mocha" or "Catppuccin Latte"
                        vim.notify("Theme switched to " .. theme_name)
                    end
                end, 100)
            end,
        })

        -- Manual toggle command
        vim.api.nvim_create_user_command("ToggleTheme", function()
            local current = vim.o.background
            vim.o.background = current == "dark" and "light" or "dark"
            apply_theme()
            local theme_name = vim.o.background == "dark" and "Catppuccin Mocha" or "Catppuccin Latte"
            vim.notify("Theme manually switched to " .. theme_name)
        end, { desc = "Toggle between light and dark theme" })
    end,
}
