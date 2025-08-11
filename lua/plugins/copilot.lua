-- ~/.config/nvim/lua/plugins/copilot.lua

return {
  "github/copilot.vim",
  config = function()
    -- Enable Copilot for all file types
    vim.g.copilot_enabled = true
    
    -- Disable Tab mapping - keep Tab for indenting
    vim.g.copilot_no_tab_map = true
    
    -- Use Copilot's default Alt+] to accept suggestions
    -- Or Ctrl+] as alternative
    vim.keymap.set('i', '<C-]>', 'copilot#Accept("\\<CR>")', {
      expr = true,
      replace_keycodes = false
    })
  end,
}
