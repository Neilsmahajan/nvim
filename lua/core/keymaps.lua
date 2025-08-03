-- ~/.config/nvim/lua/core/keymaps.lua

local map = vim.keymap.set

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

-- Harpoon v2
map("n", "<leader>a", function() require("harpoon"):list():add() end, { desc = "Harpoon Add File" })
map("n", "<leader>h", function() 
    local harpoon = require("harpoon")
    harpoon.ui:toggle_quick_menu(harpoon:list()) 
end, { desc = "Harpoon Menu" })
map("n", "<leader>j", function() require("harpoon"):list():select(1) end, { desc = "Go to File 1" })
map("n", "<leader>k", function() require("harpoon"):list():select(2) end, { desc = "Go to File 2" })
map("n", "<leader>l", function() require("harpoon"):list():select(3) end, { desc = "Go to File 3" })
map("n", "<leader>;", function() require("harpoon"):list():select(4) end, { desc = "Go to File 4" })

-- Formatting
map("n", "<leader>f", function() require("conform").format({ lsp_fallback = true }) end, { desc = "Format buffer" })

-- Theme toggle
map("n", "<leader>tt", ":ToggleTheme<CR>", { desc = "Toggle light/dark theme" })
map("n", "<leader>ts", function() 
    local current_bg = vim.o.background
    local theme_name = current_bg == "dark" and "Catppuccin Mocha (Dark)" or "Catppuccin Latte (Light)"
    print("Current theme: " .. theme_name)
end, { desc = "Show current theme" })

-- Arduino project templates
map("n", "<leader>an", function()
    local templates = {
        "basic.ino",
        "blink.ino", 
        "sensor.ino"
    }
    
    vim.ui.select(templates, {
        prompt = "Select Arduino template:",
        format_item = function(item)
            return item:gsub("%.ino$", "")
        end,
    }, function(choice)
        if choice then
            local template_path = vim.fn.expand("~/.config/nvim/templates/arduino/" .. choice)
            local target_name = vim.fn.input("Enter sketch name: ", choice:gsub("%.ino$", ""))
            if target_name and target_name ~= "" then
                local target_path = target_name .. ".ino"
                vim.cmd("edit " .. target_path)
                vim.cmd("0read " .. template_path)
                vim.cmd("normal! gg")
                print("Created new Arduino sketch: " .. target_path)
            end
        end
    end)
end, { desc = "New Arduino sketch from template" })

-- Python-specific keymaps (only active in Python files)
vim.api.nvim_create_autocmd("FileType", {
    pattern = "python",
    callback = function()
        local opts = { buffer = true }
        
        -- Python testing with neotest
        map("n", "<leader>tn", function() require("neotest").run.run() end, vim.tbl_extend("force", opts, { desc = "Run nearest test" }))
        map("n", "<leader>tf", function() require("neotest").run.run(vim.fn.expand("%")) end, vim.tbl_extend("force", opts, { desc = "Run file tests" }))
        map("n", "<leader>ts", function() require("neotest").summary.toggle() end, vim.tbl_extend("force", opts, { desc = "Toggle test summary" }))
        map("n", "<leader>to", function() require("neotest").output.open({ enter = true }) end, vim.tbl_extend("force", opts, { desc = "Open test output" }))
        
        -- Python debugging with dap
        map("n", "<leader>db", function() require("dap").toggle_breakpoint() end, vim.tbl_extend("force", opts, { desc = "Toggle breakpoint" }))
        map("n", "<leader>dc", function() require("dap").continue() end, vim.tbl_extend("force", opts, { desc = "Continue debugging" }))
        map("n", "<leader>ds", function() require("dap").step_over() end, vim.tbl_extend("force", opts, { desc = "Step over" }))
        map("n", "<leader>di", function() require("dap").step_into() end, vim.tbl_extend("force", opts, { desc = "Step into" }))
        map("n", "<leader>do", function() require("dap").step_out() end, vim.tbl_extend("force", opts, { desc = "Step out" }))
        map("n", "<leader>dt", function() require("dap").terminate() end, vim.tbl_extend("force", opts, { desc = "Terminate debug session" }))
        map("n", "<leader>du", function() require("dapui").toggle() end, vim.tbl_extend("force", opts, { desc = "Toggle debug UI" }))
        
        -- Python-specific LSP commands
        map("n", "<leader>po", ":PyrightOrganizeImports<CR>", vim.tbl_extend("force", opts, { desc = "Organize imports" }))
        
        -- Python REPL integration (Iron.nvim keymaps are defined in the plugin config)
        -- Virtual environment selection keymaps are defined in the plugin config
    end,
})

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

-- HTMX/HTML specific keymaps
vim.api.nvim_create_autocmd("FileType", {
    pattern = { "html", "htmldjango", "templ", "php", "blade", "twig", "handlebars", "mustache" },
    callback = function()
        local opts = { buffer = true }
        
        -- Live server keymaps (if available)
        map("n", "<leader>lo", ":LiveServerStart<CR>", vim.tbl_extend("force", opts, { desc = "Start Live Server" }))
        map("n", "<leader>lc", ":LiveServerStop<CR>", vim.tbl_extend("force", opts, { desc = "Stop Live Server" }))
        
        -- HTML tag navigation
        map("n", "<leader>hf", ":/<\\w\\+<CR>", vim.tbl_extend("force", opts, { desc = "Find next HTML tag" }))
        map("n", "<leader>hc", ":/<\\/\\w\\+><CR>", vim.tbl_extend("force", opts, { desc = "Find next closing tag" }))
        
        -- HTMX specific snippets (manual insertion)
        map("n", "<leader>hg", "ihx-get=\"\"<Left>", vim.tbl_extend("force", opts, { desc = "Insert hx-get" }))
        map("n", "<leader>hp", "ihx-post=\"\"<Left>", vim.tbl_extend("force", opts, { desc = "Insert hx-post" }))
        map("n", "<leader>hs", "ihx-swap=\"\"<Left>", vim.tbl_extend("force", opts, { desc = "Insert hx-swap" }))
        map("n", "<leader>hT", "ihx-trigger=\"\"<Left>", vim.tbl_extend("force", opts, { desc = "Insert hx-trigger" }))
        map("n", "<leader>ht", "ihx-target=\"\"<Left>", vim.tbl_extend("force", opts, { desc = "Insert hx-target" }))
    end,
})

-- TypeScript/JavaScript specific keymaps
vim.api.nvim_create_autocmd("FileType", {
    pattern = { "typescript", "typescriptreact", "javascript", "javascriptreact" },
    callback = function()
        local opts = { buffer = true }
        
        -- TypeScript specific commands
        map("n", "<leader>to", ":TSToolsOrganizeImports<CR>", vim.tbl_extend("force", opts, { desc = "Organize imports" }))
        map("n", "<leader>tr", ":TSToolsRenameFile<CR>", vim.tbl_extend("force", opts, { desc = "Rename file" }))
        map("n", "<leader>ti", ":TSToolsAddMissingImports<CR>", vim.tbl_extend("force", opts, { desc = "Add missing imports" }))
        map("n", "<leader>tu", ":TSToolsRemoveUnusedImports<CR>", vim.tbl_extend("force", opts, { desc = "Remove unused imports" }))
        map("n", "<leader>tf", ":TSToolsFixAll<CR>", vim.tbl_extend("force", opts, { desc = "Fix all issues" }))
        map("n", "<leader>tg", ":TSToolsGoToSourceDefinition<CR>", vim.tbl_extend("force", opts, { desc = "Go to source definition" }))
    end,
})

-- Package.json specific keymaps
vim.api.nvim_create_autocmd("FileType", {
    pattern = "json",
    callback = function()
        local opts = { buffer = true }
        
        -- Only for package.json files
        if vim.fn.expand("%:t") == "package.json" then
            map("n", "<leader>ps", function() require("package-info").show() end, vim.tbl_extend("force", opts, { desc = "Show package info" }))
            map("n", "<leader>ph", function() require("package-info").hide() end, vim.tbl_extend("force", opts, { desc = "Hide package info" }))
            map("n", "<leader>pt", function() require("package-info").toggle() end, vim.tbl_extend("force", opts, { desc = "Toggle package info" }))
            map("n", "<leader>pu", function() require("package-info").update() end, vim.tbl_extend("force", opts, { desc = "Update package" }))
            map("n", "<leader>pd", function() require("package-info").delete() end, vim.tbl_extend("force", opts, { desc = "Delete package" }))
            map("n", "<leader>pi", function() require("package-info").install() end, vim.tbl_extend("force", opts, { desc = "Install package" }))
            map("n", "<leader>pc", function() require("package-info").change_version() end, vim.tbl_extend("force", opts, { desc = "Change package version" }))
        end
    end,
})

-- C/C++ specific keymaps
vim.api.nvim_create_autocmd("FileType", {
    pattern = { "c", "cpp" },
    callback = function()
        local opts = { buffer = true }
        
        -- Clangd specific commands
        map("n", "<leader>ch", ":ClangdSwitchSourceHeader<CR>", vim.tbl_extend("force", opts, { desc = "Switch Source/Header" }))
        map("n", "<leader>ct", ":ClangdTypeHierarchy<CR>", vim.tbl_extend("force", opts, { desc = "Type Hierarchy" }))
        map("n", "<leader>cs", ":ClangdSymbolInfo<CR>", vim.tbl_extend("force", opts, { desc = "Symbol Info" }))
        map("n", "<leader>cm", ":ClangdMemoryUsage<CR>", vim.tbl_extend("force", opts, { desc = "Memory Usage" }))
        
        -- Build and run commands
        map("n", "<leader>cb", ":!make<CR>", vim.tbl_extend("force", opts, { desc = "Build (make)" }))
        map("n", "<leader>cc", ":!gcc % -o %:r && ./%:r<CR>", vim.tbl_extend("force", opts, { desc = "Compile & Run (C)" }))
        map("n", "<leader>cp", ":!g++ % -o %:r && ./%:r<CR>", vim.tbl_extend("force", opts, { desc = "Compile & Run (C++)" }))
        map("n", "<leader>cr", ":!./%:r<CR>", vim.tbl_extend("force", opts, { desc = "Run executable" }))
        
        -- Debug keymaps (same as Go, but for C/C++)
        map("n", "<leader>db", function() require("dap").toggle_breakpoint() end, vim.tbl_extend("force", opts, { desc = "Toggle breakpoint" }))
        map("n", "<leader>dc", function() require("dap").continue() end, vim.tbl_extend("force", opts, { desc = "Continue debugging" }))
        map("n", "<leader>ds", function() require("dap").step_over() end, vim.tbl_extend("force", opts, { desc = "Step over" }))
        map("n", "<leader>di", function() require("dap").step_into() end, vim.tbl_extend("force", opts, { desc = "Step into" }))
        map("n", "<leader>do", function() require("dap").step_out() end, vim.tbl_extend("force", opts, { desc = "Step out" }))
        map("n", "<leader>dt", function() require("dap").terminate() end, vim.tbl_extend("force", opts, { desc = "Terminate debug session" }))
        map("n", "<leader>du", function() require("dapui").toggle() end, vim.tbl_extend("force", opts, { desc = "Toggle debug UI" }))
        
        -- Testing keymaps
        map("n", "<leader>tn", function() require("neotest").run.run() end, vim.tbl_extend("force", opts, { desc = "Run nearest test" }))
        map("n", "<leader>tf", function() require("neotest").run.run(vim.fn.expand("%")) end, vim.tbl_extend("force", opts, { desc = "Run file tests" }))
        map("n", "<leader>ts", function() require("neotest").summary.toggle() end, vim.tbl_extend("force", opts, { desc = "Toggle test summary" }))
        map("n", "<leader>to", function() require("neotest").output.open({ enter = true }) end, vim.tbl_extend("force", opts, { desc = "Open test output" }))
    end,
})

-- Arduino specific keymaps
vim.api.nvim_create_autocmd("FileType", {
    pattern = "arduino",
    callback = function()
        local opts = { buffer = true }
        
        -- Arduino CLI commands (defined in arduino.lua plugin)
        -- These keymaps are set up in the plugin file now
        
        -- Generate compile_commands.json for better LSP support
        map("n", "<leader>ag", function()
            local current_dir = vim.fn.expand("%:p:h")
            vim.cmd("!" .. vim.fn.expand("~/.config/nvim/scripts/generate_arduino_compile_commands.sh") .. " " .. current_dir)
        end, vim.tbl_extend("force", opts, { desc = "Generate compile_commands.json" }))
        
        -- Clangd commands (Arduino files are C++ compatible)
        map("n", "<leader>ch", ":ClangdSwitchSourceHeader<CR>", vim.tbl_extend("force", opts, { desc = "Switch Source/Header" }))
        map("n", "<leader>cs", ":ClangdSymbolInfo<CR>", vim.tbl_extend("force", opts, { desc = "Symbol Info" }))
    end,
})

-- CMake specific keymaps
vim.api.nvim_create_autocmd("FileType", {
    pattern = "cmake",
    callback = function()
        local opts = { buffer = true }
        
        -- CMake commands
        map("n", "<leader>cg", ":CMakeGenerate<CR>", vim.tbl_extend("force", opts, { desc = "CMake Generate" }))
        map("n", "<leader>cb", ":CMakeBuild<CR>", vim.tbl_extend("force", opts, { desc = "CMake Build" }))
        map("n", "<leader>cr", ":CMakeRun<CR>", vim.tbl_extend("force", opts, { desc = "CMake Run" }))
        map("n", "<leader>cd", ":CMakeDebug<CR>", vim.tbl_extend("force", opts, { desc = "CMake Debug" }))
        map("n", "<leader>cc", ":CMakeClean<CR>", vim.tbl_extend("force", opts, { desc = "CMake Clean" }))
        map("n", "<leader>cs", ":CMakeSettings<CR>", vim.tbl_extend("force", opts, { desc = "CMake Settings" }))
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
