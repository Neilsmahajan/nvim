-- ~/.config/nvim/lua/plugins/lsp.lua

return {
    "neovim/nvim-lspconfig",
    dependencies = { "hrsh7th/cmp-nvim-lsp" },
    config = function()
        local lspconfig = require("lspconfig")

        -- LSP capabilities for nvim-cmp completion
        local capabilities = require("cmp_nvim_lsp").default_capabilities()

        -- LSP servers to configure
        local servers = { "lua_ls", "gopls", "pyright", "ts_ls", "bashls" }

        for _, server in ipairs(servers) do
            lspconfig[server].setup({
                capabilities = capabilities,
                on_attach = function(_, bufnr)
                    -- Format on save
                    vim.api.nvim_create_autocmd("BufWritePre", {
                        buffer = bufnr,
                        callback = function()
                            vim.lsp.buf.format({ async = false })
                        end,
                    })
                end,
            })
        end
    end,
}
