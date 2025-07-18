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
            html = { "prettier" },
            css = { "prettier" },
            scss = { "prettier" },
            -- add others (markdown, yaml, astro…) as you like
        },
        -- Run Prettier **after** your FileType autocommand sets tabstop/shiftwidth,
        -- so they stay in sync with Prettier's defaults or your .prettierrc.
        format_on_save = function(bufnr)
            -- Disable for large files or special buffers if you wish:
            local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(bufnr))
            return ok and stats and stats.size < 256 * 1024 -- <256 KiB
        end,
    },
}
