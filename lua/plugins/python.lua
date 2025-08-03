-- ~/.config/nvim/lua/plugins/python.lua

return {
    -- Python LSP and development tools
    {
        "neovim/nvim-lspconfig",
        opts = function(_, opts)
            -- This will be merged with the main LSP config
            return opts
        end,
    },

    -- Python-specific plugins
    {
        "linux-cultist/venv-selector.nvim",
        dependencies = {
            "neovim/nvim-lspconfig",
            "mfussenegger/nvim-dap",
            "mfussenegger/nvim-dap-python",
            { "nvim-telescope/telescope.nvim", branch = "0.1.x", dependencies = { "nvim-lua/plenary.nvim" } },
        },
        lazy = false,
        branch = "regexp", -- Use the regexp branch for better performance
        config = function()
            require("venv-selector").setup({
                settings = {
                    search = {
                        anaconda_base = {
                            command = "fd python$ ~/anaconda3/bin --type file --color never",
                            type = "anaconda"
                        },
                        anaconda_envs = {
                            command = "fd python$ ~/anaconda3/envs/*/bin --type file --color never",
                            type = "anaconda"
                        },
                        pyenv = {
                            command = "fd python$ ~/.pyenv/versions/*/bin --type file --color never",
                            type = "pyenv"
                        },
                        venv = {
                            command = "fd python$ ./venv/bin --type file --color never",
                            type = "venv"
                        },
                        poetry = {
                            command = "poetry env info --executable",
                            type = "poetry"
                        },
                        pipenv = {
                            command = "pipenv --venv",
                            type = "pipenv"
                        },
                        conda = {
                            command = "conda info --envs | grep -v '^#' | awk '{print $2 \"/bin/python\"}'",
                            type = "conda"
                        },
                    },
                    options = {
                        notify_user_on_venv_activation = true,
                        on_venv_activate_callback = function()
                            -- Restart LSP server when virtual environment changes
                            vim.cmd("LspRestart pyright")
                        end,
                    },
                },
            })
        end,
        keys = {
            { "<leader>vs", "<cmd>VenvSelect<cr>", desc = "Select Python Virtual Environment" },
            { "<leader>vc", "<cmd>VenvSelectCached<cr>", desc = "Select Cached Python Virtual Environment" },
        },
    },

    -- Enhanced Python debugging
    {
        "mfussenegger/nvim-dap-python",
        dependencies = {
            "mfussenegger/nvim-dap",
            "rcarriga/nvim-dap-ui",
        },
        config = function()
            -- Setup dap-python
            local dap_python = require("dap-python")
            
            -- Try to find Python executable in common locations
            local python_path = vim.fn.executable("python3") == 1 and "python3" or "python"
            if vim.fn.executable("/usr/bin/python3") == 1 then
                python_path = "/usr/bin/python3"
            elseif vim.fn.executable("/opt/homebrew/bin/python3") == 1 then
                python_path = "/opt/homebrew/bin/python3"
            elseif vim.fn.executable(vim.fn.expand("~/.pyenv/shims/python")) == 1 then
                python_path = vim.fn.expand("~/.pyenv/shims/python")
            end
            
            dap_python.setup(python_path)
            
            -- Add configurations for testing
            dap_python.test_runner = "pytest"
        end,
        ft = "python",
    },

    -- Python testing with neotest
    {
        "nvim-neotest/neotest",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-neotest/neotest-python",
            "antoinemadec/FixCursorHold.nvim",
            "nvim-treesitter/nvim-treesitter",
        },
        config = function()
            require("neotest").setup({
                adapters = {
                    require("neotest-python")({
                        dap = { justMyCode = false },
                        args = { "--log-level", "DEBUG" },
                        runner = "pytest", -- or "unittest"
                        python = function()
                            -- Try to get Python from virtual environment
                            local venv = os.getenv("VIRTUAL_ENV")
                            if venv then
                                return venv .. "/bin/python"
                            end
                            return "python3"
                        end,
                    }),
                },
            })
        end,
        ft = "python",
    },

    -- Python docstring generation
    {
        "danymat/neogen",
        config = function()
            require("neogen").setup({
                enabled = true,
                input_after_comment = true,
                languages = {
                    python = {
                        template = {
                            annotation_convention = "google", -- or "numpydoc", "reST"
                        },
                    },
                },
            })
        end,
        ft = "python",
        keys = {
            { "<leader>nf", "<cmd>Neogen func<cr>", desc = "Generate function docstring", ft = "python" },
            { "<leader>nc", "<cmd>Neogen class<cr>", desc = "Generate class docstring", ft = "python" },
            { "<leader>nm", "<cmd>Neogen file<cr>", desc = "Generate module docstring", ft = "python" },
        },
    },

    -- Python REPL integration
    {
        "Vigemus/iron.nvim",
        config = function()
            local iron = require("iron.core")
            iron.setup({
                config = {
                    scratch_repl = true,
                    repl_definition = {
                        python = {
                            command = { "python3" },
                            format = require("iron.fts.common").bracketed_paste,
                        },
                    },
                    repl_open_cmd = require("iron.view").bottom(20),
                },
                keymaps = {
                    send_motion = "<space>sc",
                    visual_send = "<space>sc",
                    send_file = "<space>sf",
                    send_line = "<space>sl",
                    send_mark = "<space>sm",
                    mark_motion = "<space>mc",
                    mark_visual = "<space>mc",
                    remove_mark = "<space>md",
                    cr = "<space>s<cr>",
                    interrupt = "<space>s<space>",
                    exit = "<space>sq",
                    clear = "<space>cl",
                },
                highlight = {
                    italic = true
                },
                ignore_blank_lines = true,
            })
        end,
        ft = "python",
        keys = {
            { "<leader>rs", "<cmd>IronRepl<cr>", desc = "Start Python REPL", ft = "python" },
            { "<leader>rr", "<cmd>IronRestart<cr>", desc = "Restart Python REPL", ft = "python" },
            { "<leader>rf", "<cmd>IronFocus<cr>", desc = "Focus Python REPL", ft = "python" },
            { "<leader>rh", "<cmd>IronHide<cr>", desc = "Hide Python REPL", ft = "python" },
        },
    },
}
