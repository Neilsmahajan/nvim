-- ~/.config/nvim/lua/plugins/go.lua

return {
    -- Go development enhancements
    {
        "ray-x/go.nvim",
        dependencies = {
            "ray-x/guihua.lua",
            "neovim/nvim-lspconfig",
            "nvim-treesitter/nvim-treesitter",
        },
        config = function()
            require("go").setup({
                -- Disable format on save since we handle it with conform.nvim
                goimports = "goimports",  -- use goimports command
                gofmt = "gofumpt",        -- use gofumpt for stricter formatting
                fillstruct = "gopls",     -- use gopls to fill struct
                tag_transform = false,    -- tag transformation
                test_template = "",       -- default test template
                test_template_dir = "",   -- default test template directory
                comment_placeholder = "", -- comment placeholder
                icons = { breakpoint = "🧘", currentpos = "🏃" },
                verbose = false,          -- output loginf in messages
                log_path = vim.fn.expand("$HOME") .. "/tmp/gonvim.log",
                lsp_cfg = false,          -- false: do nothing, true: apply non-default gopls setup
                lsp_gofumpt = false,      -- true: set default gofmt in gopls format to gofumpt
                lsp_on_attach = false,    -- false: do nothing, function: on_attach function
                lsp_keymaps = false,      -- false: do nothing, true: apply default lsp keymaps
                lsp_codelens = true,      -- true: apply default lsp codelens
                diagnostic = {            -- set diagnostic to false to disable diagnostic
                    hdlr = false,         -- hook diagnostic handler and send diagnostic to quickfix
                    underline = true,
                    virtual_text = { spacing = 0, prefix = "■" },
                    signs = true,
                    update_in_insert = false,
                },
                lsp_document_formatting = false, -- true: use gopls to format, false: do nothing
                lsp_inlay_hints = {
                    enable = true,
                    only_current_line = false,
                    only_current_line_autocmd = "CursorHold",
                    show_variable_name = true,
                    parameter_hints_prefix = "󰊕 ",
                    show_parameter_hints = true,
                    other_hints_prefix = "=> ",
                },
                gopls_cmd = nil,          -- if you need to specify gopls path and cmd, e.g {"/home/user/lsp/gopls", "-logfile", "/var/log/gopls.log"}
                gopls_remote_auto = true, -- add -remote=auto to gopls
                gocoverage_sign = "█",
                sign_priority = 5,        -- change to a higher number to override other signs
                dap_debug = true,         -- set to false to disable dap
                dap_debug_keymap = false, -- true: use keymap for debugger defined in go/dap.lua
                dap_debug_gui = {},       -- bool|table put your dap-ui setup here set to false to disable
                dap_debug_vt = { enabled_commands = true, all_frames = true }, -- bool|table put your dap-virtual-text setup here set to false to disable
                build_tags = "",          -- set default build tags
                textobjects = true,       -- enable default text objects through treesittter-text-objects
                test_runner = "go",       -- one of {`go`, `richgo`, `dlv`, `ginkgo`, `gotestsum`}
                verbose_tests = true,     -- set to add verbose flag to tests
                run_in_floaterm = false,  -- set to true to run in float window.
                floaterm = {              -- position
                    posititon = "auto",   -- one of {`top`, `bottom`, `left`, `right`, `center`, `auto`}
                    width = 0.45,         -- width of float window if not auto
                    height = 0.98,        -- height of float window if not auto
                },
                trouble = false,          -- true: use trouble to open quickfix
                test_efm = false,         -- errorfomat for quickfix, default mix mode, set to true will be efm only
                luasnip = true,           -- enable included luasnip snippets. By default snippets are included
                iferr_vertical_shift = 4  -- define where the cursor will end up vertically from the begining of if err statement
            })
        end,
        event = { "CmdlineEnter" },
        ft = { "go", "gomod" },
        build = ':lua require("go.install").update_all_sync()' -- if you need to install/update all binaries
    },
    
    -- Go debugging support
    {
        "mfussenegger/nvim-dap",
        dependencies = {
            "rcarriga/nvim-dap-ui",
            "theHamsta/nvim-dap-virtual-text",
            "nvim-neotest/nvim-nio",
            "williamboman/mason.nvim",
        },
        config = function()
            local dap = require("dap")
            local dapui = require("dapui")
            
            -- Setup DAP UI
            dapui.setup()
            
            -- Setup virtual text
            require("nvim-dap-virtual-text").setup()
            
            -- Auto open/close DAP UI
            dap.listeners.after.event_initialized["dapui_config"] = function()
                dapui.open()
            end
            dap.listeners.before.event_terminated["dapui_config"] = function()
                dapui.close()
            end
            dap.listeners.before.event_exited["dapui_config"] = function()
                dapui.close()
            end
        end,
        ft = { "go" },
    },
    
    -- Better Go syntax highlighting and text objects
    {
        "nvim-treesitter/nvim-treesitter-textobjects",
        dependencies = "nvim-treesitter/nvim-treesitter",
        config = function()
            require("nvim-treesitter.configs").setup({
                textobjects = {
                    select = {
                        enable = true,
                        lookahead = true,
                        keymaps = {
                            ["af"] = "@function.outer",
                            ["if"] = "@function.inner",
                            ["ac"] = "@class.outer",
                            ["ic"] = "@class.inner",
                            ["as"] = "@struct.outer",
                            ["is"] = "@struct.inner",
                        },
                    },
                    move = {
                        enable = true,
                        set_jumps = true,
                        goto_next_start = {
                            ["]f"] = "@function.outer",
                            ["]c"] = "@class.outer",
                            ["]s"] = "@struct.outer",
                        },
                        goto_next_end = {
                            ["]F"] = "@function.outer",
                            ["]C"] = "@class.outer",
                            ["]S"] = "@struct.outer",
                        },
                        goto_previous_start = {
                            ["[f"] = "@function.outer",
                            ["[c"] = "@class.outer",
                            ["[s"] = "@struct.outer",
                        },
                        goto_previous_end = {
                            ["[F"] = "@function.outer",
                            ["[C"] = "@class.outer",
                            ["[S"] = "@struct.outer",
                        },
                    },
                },
            })
        end,
        ft = { "go" },
    },
    
    -- Go testing integration
    {
        "nvim-neotest/neotest",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-treesitter/nvim-treesitter",
            "antoinemadec/FixCursorHold.nvim",
            "nvim-neotest/neotest-go",
        },
        config = function()
            require("neotest").setup({
                adapters = {
                    require("neotest-go")({
                        experimental = {
                            test_table = true,
                        },
                        args = { "-count=1", "-timeout=60s" }
                    }),
                },
            })
        end,
        ft = { "go" },
    },
}
