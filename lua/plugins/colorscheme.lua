-- ~/.config/nvim/lua/plugins/colorscheme.lua

return {
  "catppuccin/nvim",
  name = "catppuccin",
  priority = 1000,
  config = function()
    require("catppuccin").setup({
      flavour = "mocha", -- or "latte" for light theme
      transparent_background = false,
      integrations = {
        cmp = true,
        telescope = true,
        treesitter = true,
      },
    })
    vim.cmd.colorscheme "catppuccin"
  end,
}
