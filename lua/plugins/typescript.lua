-- ~/.config/nvim/lua/plugins/typescript.lua

return {
  "pmizio/typescript-tools.nvim",
  dependencies = { "nvim-lspconfig", "nvim-lua/plenary.nvim" },
  ft = { "typescript", "typescriptreact", "javascript", "javascriptreact" },
  config = function()
    require("typescript-tools").setup({
      -- Use tsserver from PATH (works with pnpm global installation)
      tsserver_path = "tsserver",
      on_attach = function(client, bufnr)
        -- Disable formatting since we use prettier
        client.server_capabilities.documentFormattingProvider = false
        client.server_capabilities.documentRangeFormattingProvider = false
        
        -- Enable inlay hints
        if client.server_capabilities.inlayHintProvider and vim.lsp.inlay_hint then
          vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
        end
      end,
      settings = {
        separate_diagnostic_server = true,
        publish_diagnostic_on = "insert_leave",
        expose_as_code_action = { "fix_all", "add_missing_imports", "remove_unused", "organize_imports" },
        tsserver_file_preferences = {
          includeInlayParameterNameHints = "all",
          includeInlayFunctionParameterTypeHints = true,
          includeInlayVariableTypeHints = true,
          includeInlayPropertyDeclarationTypeHints = true,
          includeInlayFunctionLikeReturnTypeHints = true,
        },
      },
    })
  end,
}
