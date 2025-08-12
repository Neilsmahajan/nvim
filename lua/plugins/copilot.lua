-- ~/.config/nvim/lua/plugins/copilot.lua

return {
  "github/copilot.vim",
  event = "InsertEnter",
  config = function()
    -- Enable Copilot for all file types
    vim.g.copilot_enabled = true
    
    -- Ensure Copilot uses the correct Node.js binary (common WSL issue)
    -- Copilot requires Node >= 18 and sometimes Neovim's PATH differs from your shell's.
    local node_cmd = vim.fn.exepath("node")
    if node_cmd ~= nil and node_cmd ~= "" then
      vim.g.copilot_node_command = node_cmd
      -- Soft-check Node version and warn if < 18
      local ok, out = pcall(function()
        return vim.fn.systemlist(node_cmd .. " -v")[1] or ""
      end)
      if ok and type(out) == "string" then
        local major = out:match("v(%d+)")
        if major and tonumber(major) and tonumber(major) < 18 then
          vim.schedule(function()
            vim.notify(
              "GitHub Copilot: Detected Node " .. out .. ". Please upgrade to Node >= 18 for Copilot to work.",
              vim.log.levels.WARN
            )
          end)
        end
      end
    else
      -- If Node isn't found, notify so you can install it (e.g., via nvm/asdf) and restart Neovim
      vim.schedule(function()
        vim.notify(
          "GitHub Copilot: Node.js not found in PATH. Install Node >= 18 and restart Neovim (WSL often needs explicit setup).",
          vim.log.levels.WARN
        )
      end)
    end

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
