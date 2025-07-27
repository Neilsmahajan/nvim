-- ~/.config/nvim/lua/plugins/lsp.lua

return {
    "neovim/nvim-lspconfig",
    dependencies = { "hrsh7th/cmp-nvim-lsp" },
    config = function()
        local lspconfig = require("lspconfig")

        -- LSP capabilities for nvim-cmp completion
        local capabilities = require("cmp_nvim_lsp").default_capabilities()

        -- LSP servers to configure
        local servers = { "lua_ls", "pyright", "bashls" }

        for _, server in ipairs(servers) do
            lspconfig[server].setup({
                capabilities = capabilities,
                on_attach = function(_, bufnr)
                    -- Format on save for non-Go/C/C++ files (Go uses conform.nvim, C/C++ uses clangd)
                    local ft = vim.bo[bufnr].filetype
                    if ft ~= "go" and ft ~= "c" and ft ~= "cpp" then
                        vim.api.nvim_create_autocmd("BufWritePre", {
                            buffer = bufnr,
                            callback = function()
                                vim.lsp.buf.format({ async = false })
                            end,
                        })
                    end
                end,
            })
        end

        -- Enhanced C/C++ and Arduino configuration with clangd
        lspconfig.clangd.setup({
            capabilities = capabilities,
            cmd = {
                "clangd",
                "--background-index",
                "--clang-tidy",
                "--header-insertion=iwyu",
                "--completion-style=detailed",
                "--function-arg-placeholders",
                "--fallback-style=llvm",
            },
            filetypes = { "c", "cpp", "objc", "objcpp", "cuda", "proto", "arduino" },
            init_options = {
                usePlaceholders = true,
                completeUnimported = true,
                clangdFileStatus = true,
            },
            on_attach = function(client, bufnr)
                -- Enable inlay hints if available
                if client.server_capabilities.inlayHintProvider and vim.lsp.inlay_hint then
                    vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
                end
                
                -- Set up clangd specific keymaps
                local opts = { buffer = bufnr }
                vim.keymap.set("n", "<leader>ch", ":ClangdSwitchSourceHeader<CR>", 
                    vim.tbl_extend("force", opts, { desc = "Switch Source/Header" }))
            end,
        })

        -- Enhanced TypeScript/JavaScript configuration
        lspconfig.ts_ls.setup({
            capabilities = capabilities,
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
            filetypes = {
                "javascript",
                "javascriptreact", 
                "typescript",
                "typescriptreact",
            },
        })

        -- JSON LSP with schema support
        lspconfig.jsonls.setup({
            capabilities = capabilities,
            settings = {
                json = {
                    schemas = require("schemastore").json.schemas(),
                    validate = { enable = true },
                },
            },
        })

        -- ESLint integration (if available)
        lspconfig.eslint.setup({
            capabilities = capabilities,
            on_attach = function(client, bufnr)
                vim.api.nvim_create_autocmd("BufWritePre", {
                    buffer = bufnr,
                    command = "EslintFixAll",
                })
            end,
        })

        -- Special configuration for gopls
        lspconfig.gopls.setup({
            capabilities = capabilities,
            settings = {
                gopls = {
                    gofumpt = true,                     -- Use gofumpt formatting
                    codelenses = {
                        gc_details = false,
                        generate = true,
                        regenerate_cgo = true,
                        run_govulncheck = true,
                        test = true,
                        tidy = true,
                        upgrade_dependency = true,
                        vendor = true,
                    },
                    hints = {
                        assignVariableTypes = true,
                        compositeLiteralFields = true,
                        compositeLiteralTypes = true,
                        constantValues = true,
                        functionTypeParameters = true,
                        parameterNames = true,
                        rangeVariableTypes = true,
                    },
                    analyses = {
                        fieldalignment = true,
                        nilness = true,
                        unusedparams = true,
                        unusedwrite = true,
                        useany = true,
                    },
                    usePlaceholders = true,
                    completeUnimported = true,
                    staticcheck = true,
                    directoryFilters = { "-.git", "-.vscode", "-.idea", "-.vscode-test", "-node_modules" },
                    semanticTokens = true,
                },
            },
            on_attach = function(client, bufnr)
                -- Disable gopls formatting since we use conform.nvim
                client.server_capabilities.documentFormattingProvider = false
                client.server_capabilities.documentRangeFormattingProvider = false
                
                -- Enable inlay hints if available
                if client.server_capabilities.inlayHintProvider and vim.lsp.inlay_hint then
                    vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
                end
            end,
        })
    end,
}
