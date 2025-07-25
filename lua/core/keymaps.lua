-- ~/.config/nvim/lua/core/keymaps.lua

local map = vim.keymap.set
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Normal mode
map("n", "<leader>w", ":w<CR>", { desc = "Save file" })
map("n", "<leader>q", ":q<CR>", { desc = "Quit window" })
map("n", "<leader>nh", ":nohl<CR>", { desc = "Clear highlights" })

-- Custom page down/up that centers the screen
vim.keymap.set("n", "<PageDown>", "<C-d>zz", { desc = "Page down & center" })
vim.keymap.set("n", "<PageUp>", "<C-u>zz", { desc = "Page up & center" })

-- Insert mode
map("i", "jk", "<Esc>", { desc = "Exit insert mode" })

-- Terminal mode
map("t", "<Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

-- Diagnostics
map("n", "<leader>e", vim.diagnostic.open_float, { desc = "Show diagnostics (float)" })
map("n", "[d", vim.diagnostic.goto_prev, { desc = "Previous diagnostic" })
map("n", "]d", vim.diagnostic.goto_next, { desc = "Next diagnostic" })

-- File Explorer (netrw)
map("n", "<leader>fe", ":Ex<CR>", { desc = "Open file explorer" })

-- LSP features
map("n", "gd", vim.lsp.buf.definition, { desc = "Go to definition" })
map("n", "K", vim.lsp.buf.hover, { desc = "Hover documentation" })
map("n", "<leader>rn", vim.lsp.buf.rename, { desc = "Rename symbol" })
map("n", "<leader>ca", vim.lsp.buf.code_action, { desc = "Code action" })

-- Telescope
map("n", "<leader>ff", function() require("telescope.builtin").find_files() end, { desc = "Find Files" })
map("n", "<leader>fg", function() require("telescope.builtin").live_grep() end, { desc = "Live Grep" })
map("n", "<leader>fb", function() require("telescope.builtin").buffers() end, { desc = "Find Buffers" })
map("n", "<leader>fh", function() require("telescope.builtin").help_tags() end, { desc = "Find Help" })
map("n", "<leader>fs", function() require("telescope.builtin").grep_string() end, { desc = "Search word under cursor" })
map("n", "<leader>fr", function() require("telescope.builtin").oldfiles() end, { desc = "Find recent files" })
map("n", "<leader>fc", function() require("telescope.builtin").commands() end, { desc = "Command palette" })

-- Harpoon
map("n", "<leader>a", function() require("harpoon.mark").add_file() end, { desc = "Harpoon Add File" })
map("n", "<leader>h", function() require("harpoon.ui").toggle_quick_menu() end, { desc = "Harpoon Menu" })
map("n", "<leader>j", function() require("harpoon.ui").nav_file(1) end, { desc = "Go to File 1" })
map("n", "<leader>k", function() require("harpoon.ui").nav_file(2) end, { desc = "Go to File 2" })
map("n", "<leader>l", function() require("harpoon.ui").nav_file(3) end, { desc = "Go to File 3" })
map("n", "<leader>;", function() require("harpoon.ui").nav_file(4) end, { desc = "Go to File 4" })

-- Formatting
map("n", "<leader>f", function() require("conform").format({ lsp_fallback = true }) end, { desc = "Format buffer" })

-- Go-specific keymaps (only active in Go files)
vim.api.nvim_create_autocmd("FileType", {
    pattern = "go",
    callback = function()
        local opts = { buffer = true }
        
        -- Go.nvim commands
        map("n", "<leader>gt", ":GoTest<CR>", vim.tbl_extend("force", opts, { desc = "Run Go tests" }))
        map("n", "<leader>gtf", ":GoTestFunc<CR>", vim.tbl_extend("force", opts, { desc = "Run Go test function" }))
        map("n", "<leader>gtp", ":GoTestPkg<CR>", vim.tbl_extend("force", opts, { desc = "Run Go test package" }))
        map("n", "<leader>gc", ":GoCoverage<CR>", vim.tbl_extend("force", opts, { desc = "Go coverage" }))
        map("n", "<leader>gbt", ":GoBuild<CR>", vim.tbl_extend("force", opts, { desc = "Go build" }))
        map("n", "<leader>gr", ":GoRun<CR>", vim.tbl_extend("force", opts, { desc = "Go run" }))
        map("n", "<leader>gi", ":GoImports<CR>", vim.tbl_extend("force", opts, { desc = "Go imports" }))
        map("n", "<leader>gfs", ":GoFillStruct<CR>", vim.tbl_extend("force", opts, { desc = "Go fill struct" }))
        map("n", "<leader>gie", ":GoIfErr<CR>", vim.tbl_extend("force", opts, { desc = "Go if err" }))
        map("n", "<leader>gat", ":GoAddTag<CR>", vim.tbl_extend("force", opts, { desc = "Go add tag" }))
        map("n", "<leader>grt", ":GoRmTag<CR>", vim.tbl_extend("force", opts, { desc = "Go remove tag" }))
        
        -- Debug keymaps
        map("n", "<leader>db", function() require("dap").toggle_breakpoint() end, vim.tbl_extend("force", opts, { desc = "Toggle breakpoint" }))
        map("n", "<leader>dc", function() require("dap").continue() end, vim.tbl_extend("force", opts, { desc = "Continue debugging" }))
        map("n", "<leader>ds", function() require("dap").step_over() end, vim.tbl_extend("force", opts, { desc = "Step over" }))
        map("n", "<leader>di", function() require("dap").step_into() end, vim.tbl_extend("force", opts, { desc = "Step into" }))
        map("n", "<leader>do", function() require("dap").step_out() end, vim.tbl_extend("force", opts, { desc = "Step out" }))
        map("n", "<leader>dt", function() require("dap").terminate() end, vim.tbl_extend("force", opts, { desc = "Terminate debug session" }))
        map("n", "<leader>du", function() require("dapui").toggle() end, vim.tbl_extend("force", opts, { desc = "Toggle debug UI" }))
        
        -- Neotest keymaps
        map("n", "<leader>tn", function() require("neotest").run.run() end, vim.tbl_extend("force", opts, { desc = "Run nearest test" }))
        map("n", "<leader>tf", function() require("neotest").run.run(vim.fn.expand("%")) end, vim.tbl_extend("force", opts, { desc = "Run file tests" }))
        map("n", "<leader>ts", function() require("neotest").summary.toggle() end, vim.tbl_extend("force", opts, { desc = "Toggle test summary" }))
        map("n", "<leader>to", function() require("neotest").output.open({ enter = true }) end, vim.tbl_extend("force", opts, { desc = "Open test output" }))
    end,
})

-- Reload config
map("n", "<leader>rr", ":so ~/.config/nvim/init.lua<CR>", { desc = "Reload Neovim config" })

-- Normal mode: <leader>/
vim.keymap.set("n", "<leader>/", function()
    require("Comment.api").toggle.linewise.current()
end, { desc = "Toggle comment (normal)", noremap = true })

-- Visual mode: <leader>/
vim.keymap.set("v", "<leader>/", function()
    local esc = vim.api.nvim_replace_termcodes("<Esc>", true, false, true)
    vim.api.nvim_feedkeys(esc, "nx", false)
    local api = require("Comment.api")
    local srow = vim.fn.line("'<")
    local erow = vim.fn.line("'>")
    api.toggle.linewise(vim.fn.visualmode(), { srow, erow })
end, { desc = "Toggle comment (visual)", noremap = true })

-- Copilot Accept Suggestion
vim.keymap.set("i", "<Tab>", function()
    -- prefer Copilot if a suggestion is visible
    local ok, copilot = pcall(require, "copilot.suggestion")
    if ok and copilot.is_visible() then
        copilot.accept()
        return
    end

    -- otherwise hand <Tab> back to Neovim (indent or jump-out)
    local keys = vim.api.nvim_replace_termcodes("<Tab>", true, false, true)
    vim.api.nvim_feedkeys(keys, "i", false)
end, { desc = "Accept Copilot suggestion / fallback to Tab", silent = true })
