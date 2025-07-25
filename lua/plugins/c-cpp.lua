-- ~/.config/nvim/lua/plugins/c-cpp.lua

return {
    -- Enhanced C/C++ debugging support
    {
        "mfussenegger/nvim-dap",
        dependencies = {
            "rcarriga/nvim-dap-ui",
            "theHamsta/nvim-dap-virtual-text",
            "nvim-neotest/nvim-nio",
        },
        ft = { "c", "cpp" },
        config = function()
            local dap = require("dap")
            
            -- Configure LLDB for C/C++ debugging (works well on macOS)
            dap.adapters.lldb = {
                type = "executable",
                command = "/opt/homebrew/bin/lldb-dap", -- Homebrew LLDB
                name = "lldb",
            }
            
            -- Fallback to system LLDB if Homebrew version not found
            if vim.fn.executable("/opt/homebrew/bin/lldb-dap") == 0 then
                dap.adapters.lldb.command = "/Applications/Xcode.app/Contents/Developer/usr/bin/lldb-dap"
            end
            
            -- C configuration
            dap.configurations.c = {
                {
                    name = "Launch C Program",
                    type = "lldb",
                    request = "launch",
                    program = function()
                        return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
                    end,
                    cwd = "${workspaceFolder}",
                    stopOnEntry = false,
                    args = {},
                    runInTerminal = false,
                },
                {
                    name = "Attach to Process",
                    type = "lldb",
                    request = "attach",
                    pid = require("dap.utils").pick_process,
                    args = {},
                },
            }
            
            -- C++ configuration (same as C)
            dap.configurations.cpp = dap.configurations.c
        end,
    },
    
    -- C/C++ testing integration
    {
        "nvim-neotest/neotest",
        dependencies = {
            "alfaix/neotest-gtest",  -- Google Test support
        },
        ft = { "c", "cpp" },
        config = function()
            require("neotest").setup({
                adapters = {
                    require("neotest-gtest").setup({
                        -- Configure for your build system
                        root_pattern = { "CMakeLists.txt", "Makefile", ".git" },
                    }),
                },
            })
        end,
    },

    -- CMake support
    {
        "Civitasv/cmake-tools.nvim",
        ft = { "cmake" },
        dependencies = { "nvim-lua/plenary.nvim" },
        config = function()
            require("cmake-tools").setup({
                cmake_command = "cmake",
                cmake_build_directory = "build",
                cmake_build_directory_prefix = "",
                cmake_generate_options = { "-D", "CMAKE_EXPORT_COMPILE_COMMANDS=1" },
                cmake_build_options = {},
                cmake_console_size = 10,
                cmake_show_console = "always",
                cmake_dap_configuration = {
                    name = "cpp",
                    type = "lldb",
                    request = "launch",
                },
                cmake_variants_message = {
                    short = { show = true },
                    long = { show = true, max_length = 40 },
                },
            })
        end,
    },
    
    -- Better C/C++ syntax and features
    {
        "p00f/clangd_extensions.nvim",
        ft = { "c", "cpp" },
        config = function()
            require("clangd_extensions").setup({
                inlay_hints = {
                    inline = vim.fn.has("nvim-0.10") == 1,
                    only_current_line = false,
                    only_current_line_autocmd = "CursorHold",
                    show_parameter_hints = true,
                    parameter_hints_prefix = "<- ",
                    other_hints_prefix = "=> ",
                    max_len_align = false,
                    max_len_align_padding = 1,
                    right_align = false,
                    right_align_padding = 7,
                    highlight = "Comment",
                    priority = 100,
                },
                ast = {
                    role_icons = {
                        type = "",
                        declaration = "",
                        expression = "",
                        specifier = "",
                        statement = "",
                        ["template argument"] = "",
                    },
                    kind_icons = {
                        Compound = "",
                        Recovery = "",
                        TranslationUnit = "",
                        PackExpansion = "",
                        TemplateTypeParm = "",
                        TemplateTemplateParm = "",
                        TemplateParamObject = "",
                    },
                },
                memory_usage = {
                    border = "none",
                },
                symbol_info = {
                    border = "none",
                },
            })
        end,
    },
}
