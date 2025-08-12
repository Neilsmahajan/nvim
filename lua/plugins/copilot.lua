-- ~/.config/nvim/lua/plugins/copilot.lua

return {
  "github/copilot.vim",
  event = "InsertEnter",
  config = function()
    -- Enable Copilot for all file types
    vim.g.copilot_enabled = true
    
    -- Disable Tab mapping - keep Tab for indenting
    vim.g.copilot_no_tab_map = true
    
    -- Use Ctrl+L to accept suggestions
    vim.keymap.set('i', '<C-l>', 'copilot#Accept("\\<CR>")', {
      expr = true,
      replace_keycodes = false
    })
    
    -- Enable Copilot for all filetypes (WSL sometimes has issues with detection)
    vim.g.copilot_filetypes = {
      ["*"] = true,
    }
  end,
}
