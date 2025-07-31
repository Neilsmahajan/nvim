return {
    "stevearc/conform.nvim",
    lazy = false, -- load at startup
    opts = {
        formatters = {
            -- Ensure clang-format uses 4-space indentation
            ["clang-format"] = {
                prepend_args = { "--style={BasedOnStyle: LLVM, IndentWidth: 4, TabWidth: 4, UseTab: Never}" },
            },
        },
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
            -- HTMX files (treated as HTML)
            templ = { "prettier" },
            -- Go formatting: goimports handles imports + gofmt, gofumpt for stricter formatting
            go = { "goimports", "gofumpt" },
            -- C/C++ and Arduino formatting: using clang-format with consistent 4-space indentation
            c = { "clang-format" },
            cpp = { "clang-format" },
            arduino = { "clang-format" },
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
