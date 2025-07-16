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
})
