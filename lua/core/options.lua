-- ~/.config/nvim/lua/core/options.lua (updated)

local opt = vim.opt

opt.number = true
opt.relativenumber = true
opt.mouse = "a"
opt.clipboard = "unnamedplus"
opt.tabstop = 4
opt.shiftwidth = 4
opt.expandtab = true
opt.autoindent = true
opt.smartindent = true
opt.wrap = false
opt.termguicolors = false
opt.splitright = true
opt.splitbelow = true
opt.scrolloff = 8
opt.signcolumn = "yes"
opt.cursorline = true
opt.updatetime = 250
opt.timeoutlen = 300

-- ── Language-specific indentation ──────────────────────────
-- Any filetype in this list will use 2-space indents;
-- everything else keeps the global 4-space setting above.
vim.api.nvim_create_autocmd("FileType", {
    pattern = {
        "javascript", "javascriptreact",
        "typescript", "typescriptreact",
        "json", "jsonc",
        "css", "scss", "html", "xml",
        "c", "cpp", "h", "hpp", -- C/C++ files use 2-space indentation (common standard)
        "cmake", -- CMake files also use 2 spaces
    },
    callback = function()
        vim.opt_local.tabstop     = 2
        vim.opt_local.shiftwidth  = 2
        vim.opt_local.softtabstop = 2  -- This helps with backspace and mixed indentation
        vim.opt_local.expandtab   = true  -- Ensure spaces are used, not tabs
    end,
})

-- ── Ensure Copilot uses correct indentation ──────────────────────────
-- This autocmd runs after plugins are loaded to ensure Copilot sees the right settings
vim.api.nvim_create_autocmd({ "FileType", "BufEnter" }, {
    pattern = { "c", "cpp", "h", "hpp" },
    callback = function()
        -- Set indentation options that Copilot will read
        vim.bo.tabstop = 2
        vim.bo.shiftwidth = 2
        vim.bo.softtabstop = 2
        vim.bo.expandtab = true
        
        -- Also set these for the window to be extra sure
        vim.opt_local.tabstop = 2
        vim.opt_local.shiftwidth = 2
        vim.opt_local.softtabstop = 2
        vim.opt_local.expandtab = true
    end,
})
