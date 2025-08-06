-- ~/.config/nvim/lua/plugins/web-dev.lua

return {
    -- Enhanced TypeScript integration and utilities
    {
        "pmizio/typescript-tools.nvim",
        dependencies = { "nvim-lspconfig", "nvim-lua/plenary.nvim" },
        ft = { "typescript", "typescriptreact", "javascript", "javascriptreact" },
        config = function()
            require("typescript-tools").setup({
                on_attach = function(client, bufnr)
                    -- Disable formatting since we use prettier via conform.nvim
                    client.server_capabilities.documentFormattingProvider = false
                    client.server_capabilities.documentRangeFormattingProvider = false
                    
                    -- Enable inlay hints if available
                    if client.server_capabilities.inlayHintProvider and vim.lsp.inlay_hint then
                        vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
                    end
                end,
                settings = {
                    -- spawn additional tsserver instance to calculate diagnostics on it
                    separate_diagnostic_server = true,
                    -- "change"|"insert_leave" determine when the client asks the server about diagnostic
                    publish_diagnostic_on = "insert_leave",
                    -- specify commands exposed as code_actions
                    expose_as_code_action = { "fix_all", "add_missing_imports", "remove_unused", "organize_imports" },
                    -- Use pnpm as the package manager if available
                    root_dir = function(fname)
                        local util = require("lspconfig.util")
                        return util.root_pattern("pnpm-lock.yaml", "package.json", "tsconfig.json", ".git")(fname)
                    end,
                    -- memory limit in megabytes or "auto"(basically no limit)
                    tsserver_max_memory = "auto",
                    tsserver_file_preferences = {
                        includeInlayParameterNameHints = "all",
                        includeInlayParameterNameHintsWhenArgumentMatchesName = false,
                        includeInlayFunctionParameterTypeHints = true,
                        includeInlayVariableTypeHints = true,
                        includeInlayPropertyDeclarationTypeHints = true,
                        includeInlayFunctionLikeReturnTypeHints = true,
                        includeInlayEnumMemberValueHints = true,
                    },
                    -- locale of all tsserver messages
                    tsserver_locale = "en",
                    -- mirror of VSCode's `typescript.suggest.completeFunctionCalls`
                    complete_function_calls = false,
                    include_completions_with_insert_text = true,
                    -- CodeLens - disabled for performance
                    code_lens = "off",
                    disable_member_code_lens = true,
                    -- JSXCloseTag - disabled to prevent conflicts with nvim-ts-autotag
                    jsx_close_tag = {
                        enable = false,
                        filetypes = { "javascriptreact", "typescriptreact" },
                    }
                },
            })
        end,
    },

    -- Package.json management
    {
        "vuki656/package-info.nvim",
        dependencies = "MunifTanjim/nui.nvim",
        ft = "json",
        config = function()
            require("package-info").setup({
                colors = {
                    up_to_date = "#3C4048",
                    outdated = "#d19a66",
                },
                icons = {
                    enable = true,
                    style = {
                        up_to_date = "|  ",
                        outdated = "|  ",
                    },
                },
                autostart = true,
                hide_up_to_date = false,
                hide_unstable_versions = false,
            })
        end,
    },

    -- React/JSX enhancements
    {
        "windwp/nvim-ts-autotag",
        ft = { "html", "javascript", "javascriptreact", "typescript", "typescriptreact", "svelte", "vue" },
        config = function()
            require("nvim-ts-autotag").setup({
                opts = {
                    enable_close = true,
                    enable_rename = true,
                    enable_close_on_slash = false,
                },
                per_filetype = {
                    ["html"] = {
                        enable_close = false,
                    },
                },
            })
        end,
    },

    -- Better JSON support for config files
    {
        "b0o/schemastore.nvim",
        ft = { "json", "jsonc" },
    },
}
