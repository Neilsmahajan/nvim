-- ~/.config/nvim/lua/plugins/arduino.lua

return {
    -- Arduino syntax highlighting (reliable repository)
    {
        "vim-scripts/Arduino-syntax-file",
        ft = "arduino",
    },

    -- Simple Arduino development functions (using terminal commands)
    {
        "nvim-lua/plenary.nvim",
        config = function()
            -- Only set up Arduino functions when we're editing Arduino files
            vim.api.nvim_create_autocmd("FileType", {
                pattern = "arduino",
                callback = function()
                    -- Simple Arduino CLI wrapper functions
                    local function arduino_compile()
                        local file = vim.fn.expand("%:p")
                        vim.cmd("!" .. "arduino-cli compile --fqbn arduino:avr:uno " .. vim.fn.shellescape(file))
                    end
                    
                    local function arduino_upload()
                        local file = vim.fn.expand("%:p") 
                        vim.cmd("!" .. "arduino-cli upload -p /dev/cu.usbmodem* --fqbn arduino:avr:uno " .. vim.fn.shellescape(file))
                    end
                    
                    local function arduino_serial()
                        vim.cmd("!" .. "arduino-cli monitor -p /dev/cu.usbmodem*")
                    end
                    
                    -- Create user commands
                    vim.api.nvim_buf_create_user_command(0, "ArduinoCompile", arduino_compile, {})
                    vim.api.nvim_buf_create_user_command(0, "ArduinoUpload", arduino_upload, {})
                    vim.api.nvim_buf_create_user_command(0, "ArduinoSerial", arduino_serial, {})
                    
                    -- Set up keymaps
                    local opts = { buffer = true }
                    vim.keymap.set("n", "<leader>av", arduino_compile, vim.tbl_extend("force", opts, { desc = "Verify Arduino Code" }))
                    vim.keymap.set("n", "<leader>au", arduino_upload, vim.tbl_extend("force", opts, { desc = "Upload to Arduino" }))
                    vim.keymap.set("n", "<leader>as", arduino_serial, vim.tbl_extend("force", opts, { desc = "Open Serial Monitor" }))
                    vim.keymap.set("n", "<leader>cc", arduino_compile, vim.tbl_extend("force", opts, { desc = "Quick Compile Check" }))
                end,
            })
        end,
    },
}
