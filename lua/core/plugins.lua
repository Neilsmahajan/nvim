-- ~/.config/nvim/lua/core/plugins.lua

return require("lazy").setup({
    -- Import plugin configurations from plugins/ directory
    { import = "plugins" },

    -- Direct plugin definitions for simple plugins
    -- Useful Lua Functions
    { "nvim-lua/plenary.nvim" },

    -- Markdown preview
    {
        "iamcco/markdown-preview.nvim",
        build = "cd app && yarn install --frozen-lockfile",
        ft = { "markdown" },
        config = function()
            vim.g.mkdp_auto_start        = 0
            vim.g.mkdp_auto_close        = 1
            vim.g.mkdp_open_to_the_world = 0
            vim.g.mkdp_browser           = ""      -- default browser
            vim.g.mkdp_theme             = "light" -- or "dark"
        end,
    },

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
                go              = { "goimports", "gofumpt" },
            },
            -- Don't auto-format huge files (>256 KiB)
            format_on_save = function(bufnr)
                local ok, stat = pcall(vim.loop.fs_stat,
                    vim.api.nvim_buf_get_name(bufnr))
                return ok and stat and stat.size < 256 * 1024
            end,
        },
    },

    -- ───────────────── Autopairs ──────────────────────────────
    {
        "windwp/nvim-autopairs",
        event = "InsertEnter", -- load only when you start typing
        opts = {
            check_ts = true,   -- use Treesitter to skip quotes in comments etc.
        },
        config = function(_, opts)
            local npairs = require("nvim-autopairs")
            npairs.setup(opts)

            -- If you use nvim-cmp, hook it so <CR> also inserts pairs correctly
            local ok, cmp = pcall(require, "cmp")
            if ok then
                local cmp_npairs = require("nvim-autopairs.completion.cmp")
                cmp.event:on("confirm_done", cmp_npairs.on_confirm_done())
            end
        end,
    },

    -- ───────────────── Auto-closing HTML / JSX tags ───────────
    {
        "windwp/nvim-ts-autotag",
        event = "InsertEnter",
        opts = {}, -- default settings are fine
        config = function(_, opts)
            require("nvim-ts-autotag").setup(opts)
        end,
    },

    -- GitHub Copilot
    {
        "github/copilot.vim",
        lazy = false,
    },

    -- Commenting
    {
        "numToStr/Comment.nvim",
        event = "VeryLazy",
        config = function()
            require("Comment").setup()
        end,
    }
})