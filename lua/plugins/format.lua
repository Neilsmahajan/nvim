return {
    "stevearc/conform.nvim",
    lazy = false, -- load at startup
    opts = {
        formatters_by_ft = {
            javascript = { "prettier" },
            javascriptreact = { "prettier" },
            typescript = { "prettier" },
            typescriptreact = { "prettier" },
            json = { "prettier" },
            jsonc = { "prettier" },
            html = { "prettier" },
            css = { "prettier" },
            scss = { "prettier" },
            less = { "prettier" },
            markdown = { "prettier" },
            yaml = { "prettier" },
            toml = { "prettier" },
            graphql = { "prettier" },
            -- Go formatting: goimports handles imports + gofmt, gofumpt for stricter formatting
            go = { "goimports", "gofumpt" },
            -- C/C++ formatting: using clang-format
            c = { "clang-format" },
            cpp = { "clang-format" },
        },
        -- Run formatters **after** your FileType autocommand sets tabstop/shiftwidth,
        -- so they stay in sync with formatter defaults or your config files.
        format_on_save = function(bufnr)
            -- Disable for large files or special buffers if you wish:
            local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(bufnr))
            if ok and stats and stats.size < 256 * 1024 then -- <256 KiB
                return {
                    timeout_ms = 500,
                    lsp_fallback = true,
                }
            end
            return false
        end,
    },
}
