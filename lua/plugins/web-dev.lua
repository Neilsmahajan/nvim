-- ~/.config/nvim/lua/plugins/web-dev.lua

return {
    -- Enhanced TypeScript integration and utilities
    {
        "jose-elias-alvarez/typescript.nvim",
        dependencies = { "nvim-lspconfig" },
        ft = { "typescript", "typescriptreact", "javascript", "javascriptreact" },
        config = function()
            require("typescript").setup({
                disable_commands = false,
                debug = false,
                go_to_source_definition = {
                    fallback = true,
                },
                server = {
                    on_attach = function(client, bufnr)
                        -- Disable formatting since we use prettier via conform.nvim
                        client.server_capabilities.documentFormattingProvider = false
                        client.server_capabilities.documentRangeFormattingProvider = false
                    end,
                    settings = {
                        typescript = {
                            inlayHints = {
                                includeInlayParameterNameHints = "all",
                                includeInlayParameterNameHintsWhenArgumentMatchesName = false,
                                includeInlayFunctionParameterTypeHints = true,
                                includeInlayVariableTypeHints = true,
                                includeInlayPropertyDeclarationTypeHints = true,
                                includeInlayFunctionLikeReturnTypeHints = true,
                                includeInlayEnumMemberValueHints = true,
                            },
                        },
                        javascript = {
                            inlayHints = {
                                includeInlayParameterNameHints = "all",
                                includeInlayParameterNameHintsWhenArgumentMatchesName = false,
                                includeInlayFunctionParameterTypeHints = true,
                                includeInlayVariableTypeHints = true,
                                includeInlayPropertyDeclarationTypeHints = true,
                                includeInlayFunctionLikeReturnTypeHints = true,
                                includeInlayEnumMemberValueHints = true,
                            },
                        },
                    },
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
