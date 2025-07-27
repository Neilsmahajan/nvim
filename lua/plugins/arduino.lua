-- ~/.config/nvim/lua/plugins/arduino.lua

return {
    -- Arduino syntax highlighting (reliable repository)
    {
        "vim-scripts/Arduino-syntax-file",
        ft = "arduino",
    },

    -- Arduino filetype detection and LSP configuration
    {
        "nvim-lua/plenary.nvim",
        config = function()
            -- Set up Arduino filetype detection early
            vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
                pattern = "*.ino",
                callback = function()
                    -- Set filetype to arduino to prevent clangd issues
                    vim.bo.filetype = "arduino"
                    
                    -- Disable LSP for Arduino files to prevent compilation errors
                    -- Arduino files should be handled by Arduino CLI, not clangd
                    vim.b.lsp_ignore = true
                    
                    -- Set syntax highlighting to C++ for better highlighting
                    vim.cmd("set syntax=cpp")
                end,
            })

            -- Only set up Arduino functions when we're editing Arduino files
            vim.api.nvim_create_autocmd("FileType", {
                pattern = "arduino",
                callback = function()
                    -- Disable LSP diagnostics for Arduino files (using updated API)
                    vim.diagnostic.config({
                        virtual_text = false,
                        signs = false,
                        underline = false,
                        update_in_insert = false,
                    }, vim.api.nvim_get_current_buf())
                    
                    -- Simple Arduino CLI wrapper functions
                    local function arduino_compile()
                        local file = vim.fn.expand("%:p")
                        local dir = vim.fn.expand("%:p:h")
                        vim.cmd("!" .. "cd " .. vim.fn.shellescape(dir) .. " && arduino-cli compile --fqbn arduino:avr:uno " .. vim.fn.shellescape(file))
                    end
                    
                    local function arduino_upload()
                        local file = vim.fn.expand("%:p") 
                        local dir = vim.fn.expand("%:p:h")
                        vim.cmd("!" .. "cd " .. vim.fn.shellescape(dir) .. " && arduino-cli upload -p /dev/cu.usbmodem* --fqbn arduino:avr:uno " .. vim.fn.shellescape(file))
                    end
                    
                    local function arduino_serial()
                        vim.cmd("!" .. "arduino-cli monitor -p /dev/cu.usbmodem*")
                    end
                    
                    local function arduino_board_list()
                        vim.cmd("!" .. "arduino-cli board list")
                    end
                    
                    -- Create user commands
                    vim.api.nvim_buf_create_user_command(0, "ArduinoCompile", arduino_compile, {})
                    vim.api.nvim_buf_create_user_command(0, "ArduinoUpload", arduino_upload, {})
                    vim.api.nvim_buf_create_user_command(0, "ArduinoSerial", arduino_serial, {})
                    vim.api.nvim_buf_create_user_command(0, "ArduinoBoardList", arduino_board_list, {})
                    
                    -- Set up keymaps
                    local opts = { buffer = true }
                    vim.keymap.set("n", "<leader>av", arduino_compile, vim.tbl_extend("force", opts, { desc = "Verify Arduino Code" }))
                    vim.keymap.set("n", "<leader>au", arduino_upload, vim.tbl_extend("force", opts, { desc = "Upload to Arduino" }))
                    vim.keymap.set("n", "<leader>as", arduino_serial, vim.tbl_extend("force", opts, { desc = "Open Serial Monitor" }))
                    vim.keymap.set("n", "<leader>ab", arduino_board_list, vim.tbl_extend("force", opts, { desc = "List Arduino Boards" }))
                    vim.keymap.set("n", "<leader>cc", arduino_compile, vim.tbl_extend("force", opts, { desc = "Quick Compile Check" }))
                    
                    -- Show helpful message (deferred to avoid blocking)
                    vim.defer_fn(function()
                        vim.notify("Arduino mode activated! Use <leader>av to compile, <leader>au to upload", vim.log.levels.INFO, {
                            title = "Arduino",
                            timeout = 3000,
                        })
                    end, 100)
                end,
            })
        end,
    },
}
