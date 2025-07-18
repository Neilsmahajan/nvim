-- ~/.config/nvim/lua/core/plugins.lua

return require("lazy").setup({
    -- Fuzzy Finder
    { "nvim-telescope/telescope.nvim",   dependencies = { "nvim-lua/plenary.nvim" } },

    -- Syntax Highlighting
    { "nvim-treesitter/nvim-treesitter", build = ":TSUpdate" },

    -- Harpoon
    { "ThePrimeagen/harpoon" },

    -- LSP Configuration
    { "neovim/nvim-lspconfig" },

    -- Autocompletion
    { "hrsh7th/nvim-cmp" },
    { "hrsh7th/cmp-nvim-lsp" },
    { "L3MON4D3/LuaSnip" },
    { "saadparwaiz1/cmp_luasnip" },

    -- Useful Lua Functions
    { "nvim-lua/plenary.nvim" },

    { "nvim-lualine/lualine.nvim" },

    -- ── Formatter: Prettier via conform.nvim ─────────────────────────────
    {
        "stevearc/conform.nvim",

        -- Load as soon as you open a real file (fast startup, still lazy)
        event = { "BufReadPre", "BufNewFile" },

        opts = {
            formatters_by_ft = {
                javascript      = { "prettier" },
                javascriptreact = { "prettier" },
                typescript      = { "prettier" },
                typescriptreact = { "prettier" },
                json            = { "prettier" },
                html            = { "prettier" },
                css             = { "prettier" },
                scss            = { "prettier" },
                markdown        = { "prettier" }, -- add / remove as you wish
            },
            -- Don’t auto-format huge files (>256 KiB)
            format_on_save = function(bufnr)
                local ok, stat = pcall(vim.loop.fs_stat,
                    vim.api.nvim_buf_get_name(bufnr))
                return ok and stat and stat.size < 256 * 1024
            end,
        },

        -- Define <leader>f *after* the plugin is available
        config = function()
            vim.keymap.set(
                "n", "<leader>f",
                function()
                    require("conform").format({ lsp_fallback = true })
                end,
                { desc = "Format buffer with conform.nvim" }
            )
        end,
    },

    -- Markdown preview
    {
        "iamcco/markdown-preview.nvim",
        build = "cd app && npm install",
        ft = { "markdown" },
        config = function()
            vim.g.mkdp_auto_start = 0
            vim.g.mkdp_auto_close = 1
            vim.g.mkdp_open_to_the_world = 0
            vim.g.mkdp_browser = ""    -- leave empty to use default browser
            vim.g.mkdp_theme = "light" -- or "dark"
        end,
    },

    -- GitHub Copilot
    {
        "github/copilot.vim",
        lazy = false,
    }
})
