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
                end,
                settings = {
                    -- spawn additional tsserver instance to calculate diagnostics on it
                    separate_diagnostic_server = true,
                    -- "change"|"insert_leave" determine when the client asks the server about diagnostic
                    publish_diagnostic_on = "insert_leave",
                    -- array of strings("fix_all"|"add_missing_imports"|"remove_unused"|"remove_unused_imports"|"organize_imports") -- or string "all"
                    -- to include all supported code actions
                    -- specify commands exposed as code_actions
                    expose_as_code_action = {},
                    -- string|nil - specify a custom path to `tsserver.js` file, if this is nil or file under path
                    -- not exists then standard path resolution strategy is applied
                    tsserver_path = nil,
                    -- Use pnpm as the package manager
                    root_dir = function(fname)
                        local util = require("lspconfig.util")
                        return util.root_pattern("pnpm-lock.yaml", "package.json", "tsconfig.json", ".git")(fname)
                    end,
                    -- specify a list of plugins to load by tsserver, e.g., for support `styled-components`
                    -- (see 💅 `styled-components` support section)
                    tsserver_plugins = {},
                    -- this value is passed to: https://nodejs.org/api/cli.html#--max-old-space-sizesize-in-megabytes
                    -- memory limit in megabytes or "auto"(basically no limit)
                    tsserver_max_memory = "auto",
                    -- described below
                    tsserver_format_options = {},
                    tsserver_file_preferences = {
                        includeInlayParameterNameHints = "all",
                        includeInlayParameterNameHintsWhenArgumentMatchesName = false,
                        includeInlayFunctionParameterTypeHints = true,
                        includeInlayVariableTypeHints = true,
                        includeInlayPropertyDeclarationTypeHints = true,
                        includeInlayFunctionLikeReturnTypeHints = true,
                        includeInlayEnumMemberValueHints = true,
                    },
                    -- locale of all tsserver messages, supported locales you can find here:
                    -- https://github.com/microsoft/TypeScript/blob/3c221fc086be52b19801f6e8d82596d04607ede6/src/compiler/utilitiesPublic.ts#L620
                    tsserver_locale = "en",
                    -- mirror of VSCode's `typescript.suggest.completeFunctionCalls`
                    complete_function_calls = false,
                    include_completions_with_insert_text = true,
                    -- CodeLens
                    -- WARNING: Experimental feature also in VSCode, because it might hit performance of server.
                    -- possible values: ("off"|"all"|"implementations_only"|"references_only")
                    code_lens = "off",
                    -- by default code lenses are displayed on all referencable values and for some of you it can
                    -- be too much this option reduce count of them by removing member references from lenses
                    disable_member_code_lens = true,
                    -- JSXCloseTag
                    -- WARNING: it is disabled by default (maybe you configuration or distro already uses nvim-ts-autotag,
                    -- that maybe have a conflict if enable this feature. )
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
