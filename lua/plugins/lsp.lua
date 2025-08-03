-- ~/.config/nvim/lua/plugins/lsp.lua

return {
    "neovim/nvim-lspconfig",
    dependencies = { "hrsh7th/cmp-nvim-lsp" },
    config = function()
        local lspconfig = require("lspconfig")

        -- LSP capabilities for nvim-cmp completion
        local capabilities = require("cmp_nvim_lsp").default_capabilities()

        -- LSP servers to configure with basic setup
        local servers = { "lua_ls", "bashls" }

        for _, server in ipairs(servers) do
            lspconfig[server].setup({
                capabilities = capabilities,
                on_attach = function(_, bufnr)
                    -- Format on save for non-Go/C/C++/Python files (these use conform.nvim)
                    local ft = vim.bo[bufnr].filetype
                    if ft ~= "go" and ft ~= "c" and ft ~= "cpp" and ft ~= "python" then
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

        -- Enhanced Python configuration with Pyright
        lspconfig.pyright.setup({
            capabilities = capabilities,
            settings = {
                python = {
                    analysis = {
                        autoSearchPaths = true,
                        useLibraryCodeForTypes = true,
                        diagnosticMode = "workspace", -- or "openFilesOnly"
                        typeCheckingMode = "basic", -- or "strict", "off"
                        autoImportCompletions = true,
                        stubPath = vim.fn.stdpath("data") .. "/lazy/python-type-stubs",
                        diagnosticSeverityOverrides = {
                            reportUnusedImport = "information",
                            reportUnusedFunction = "information",
                            reportUnusedVariable = "information",
                            reportGeneralTypeIssues = "warning",
                            reportOptionalMemberAccess = "warning",
                            reportOptionalSubscript = "warning",
                            reportPrivateImportUsage = "warning",
                        },
                    },
                    linting = {
                        enabled = true,
                    },
                },
            },
            on_attach = function(client, bufnr)
                -- Disable pyright formatting since we use conform.nvim with black/isort
                client.server_capabilities.documentFormattingProvider = false
                client.server_capabilities.documentRangeFormattingProvider = false
                
                -- Enable inlay hints if available
                if client.server_capabilities.inlayHintProvider and vim.lsp.inlay_hint then
                    vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
                end
            end,
            root_dir = function(fname)
                return require("lspconfig.util").root_pattern(
                    "pyproject.toml",
                    "setup.py",
                    "setup.cfg",
                    "requirements.txt",
                    "Pipfile",
                    "pyrightconfig.json",
                    ".git"
                )(fname)
            end,
        })

        -- Enhanced C/C++ configuration with clangd (excluding Arduino files)
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
            filetypes = { "c", "cpp", "objc", "objcpp", "cuda", "proto" }, -- Removed "arduino" to prevent conflicts
            init_options = {
                usePlaceholders = true,
                completeUnimported = true,
                clangdFileStatus = true,
            },
            root_dir = function(fname)
                -- Don't attach to Arduino files (.ino)
                if fname:match("%.ino$") then
                    return nil
                end
                return require("lspconfig.util").root_pattern(
                    ".clangd",
                    ".clang-tidy",
                    ".clang-format",
                    "compile_commands.json",
                    "compile_flags.txt",
                    "configure.ac",
                    ".git"
                )(fname)
            end,
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

        -- HTML Language Server configuration
        lspconfig.html.setup({
            capabilities = capabilities,
            filetypes = { "html", "templ" },
            init_options = {
                configurationSection = { "html", "css", "javascript" },
                embeddedLanguages = {
                    css = true,
                    javascript = true,
                },
                provideFormatter = true,
            },
            settings = {},
        })

        -- HTMX Language Server configuration
        lspconfig.htmx.setup({
            capabilities = capabilities,
            filetypes = { 
                "aspnetcorerazor", "astro", "astro-markdown", "blade", "clojure", "django-html", 
                "htmldjango", "edge", "eelixir", "elixir", "ejs", "erb", "eruby", "gohtml", 
                "gohtmltmpl", "haml", "handlebars", "hbs", "html", "htmlangular", "html-eex", 
                "heex", "jade", "leaf", "liquid", "markdown", "mdx", "mustache", "njk", 
                "nunjucks", "php", "razor", "slim", "twig", "javascript", "javascriptreact", 
                "reason", "rescript", "typescript", "typescriptreact", "vue", "svelte", "templ" 
            },
            on_attach = function(client, bufnr)
                -- Custom HTMX specific commands or keymaps can go here
                vim.notify("HTMX LSP attached to " .. vim.fn.expand("%:t"), vim.log.levels.INFO)
            end,
        })

        -- CSS Language Server configuration  
        lspconfig.cssls.setup({
            capabilities = capabilities,
            filetypes = { "css", "scss", "less" },
            init_options = {
                provideFormatter = true,
            },
            settings = {
                css = { validate = true },
                less = { validate = true },
                scss = { validate = true },
            },
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
