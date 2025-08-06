-- ~/.config/nvim/lua/plugins/go.lua

return {
  "ray-x/go.nvim",
  dependencies = {
    "ray-x/guihua.lua",
    "neovim/nvim-lspconfig",
    "nvim-treesitter/nvim-treesitter",
  },
  ft = { "go", "gomod" },
  config = function()
    require("go").setup({
      goimports = "goimports",
      gofmt = "gofumpt",
      fillstruct = "gopls",
      tag_transform = false,
      verbose = false,
      log_path = vim.fn.expand("$HOME") .. "/tmp/gonvim.log",
      lsp_cfg = false, -- Don't set up gopls here, we do it in lsp.lua
      lsp_gofumpt = true,
      lsp_on_attach = false,
      dap_debug = false,
    })
  end,
  build = ':lua require("go.install").update_all_sync()'
}
