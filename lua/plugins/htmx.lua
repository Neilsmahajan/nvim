-- ~/.config/nvim/lua/plugins/htmx.lua

return {
    -- Auto-closing HTML/XML tags with HTMX support
    {
        "windwp/nvim-ts-autotag",
        ft = { 
            "html", "xml", "tsx", "jsx", "vue", "svelte", 
            "php", "blade", "twig", "handlebars", "mustache",
            "htmldjango", "templ" 
        },
        config = function()
            require("nvim-ts-autotag").setup({
                opts = {
                    enable_close = true,
                    enable_rename = true,
                    enable_close_on_slash = false,
                },
                per_filetype = {
                    ["html"] = {
                        enable_close = true,
                    },
                    ["templ"] = {
                        enable_close = true,
                    },
                },
            })
        end,
    },

    -- Enhanced HTML support with auto-pairs
    {
        "windwp/nvim-autopairs",
        config = function()
            local npairs = require("nvim-autopairs")
            local Rule = require("nvim-autopairs.rule")
            local cond = require("nvim-autopairs.conds")

            -- Add HTMX attribute completions
            npairs.add_rules({
                Rule("hx-", "\"", { "html", "templ", "php", "blade" })
                    :with_pair(cond.before_regex("%w")),
                Rule("\"", "\"", { "html", "templ", "php", "blade" })
                    :with_pair(cond.before_regex("hx%-[%w%-]*=")),
            })
        end,
    },

    -- Emmet for HTML/CSS shortcuts
    {
        "mattn/emmet-vim",
        ft = { 
            "html", "css", "scss", "less", "xml", "vue", "svelte",
            "php", "blade", "twig", "handlebars", "mustache",
            "htmldjango", "templ", "javascript", "javascriptreact",
            "typescript", "typescriptreact"
        },
        config = function()
            -- Enable Emmet for HTMX and template files
            vim.g.user_emmet_settings = {
                variables = {
                    lang = "en"
                },
                html = {
                    default_attributes = {
                        option = { value = nil },
                        textarea = { id = nil, name = nil, cols = "30", rows = "10" },
                    },
                    snippets = {
                        ["html:5"] = "<!DOCTYPE html>\n"
                                   .. "<html lang=\"en\">\n"
                                   .. "<head>\n"
                                   .. "\t<meta charset=\"UTF-8\">\n"
                                   .. "\t<meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0\">\n"
                                   .. "\t<title>${1:Document}</title>\n"
                                   .. "\t<script src=\"https://unpkg.com/htmx.org@1.9.10\"></script>\n"
                                   .. "</head>\n"
                                   .. "<body>\n"
                                   .. "\t${2}\n"
                                   .. "</body>\n"
                                   .. "</html>",
                        ["htmx:get"] = "<${1:div} hx-get=\"${2:/api/endpoint}\" hx-target=\"${3:#target}\">${4}</${1}>",
                        ["htmx:post"] = "<${1:form} hx-post=\"${2:/api/endpoint}\" hx-target=\"${3:#target}\">${4}</${1}>",
                        ["htmx:swap"] = "<${1:div} hx-get=\"${2:/api/endpoint}\" hx-swap=\"${3:innerHTML}\">${4}</${1}>",
                        ["htmx:trigger"] = "<${1:button} hx-get=\"${2:/api/endpoint}\" hx-trigger=\"${3:click}\">${4}</${1}>",
                    },
                },
            }
            
            -- Set leader key for Emmet
            vim.g.user_emmet_leader_key = "<C-z>"
        end,
    },

    -- Live Server functionality
    {
        "barrett-ruth/live-server.nvim",
        ft = { "html", "css", "javascript" },
        build = "npm install -g live-server",
        config = function()
            require("live-server").setup({
                port = 8080,
                browser_command = "", -- Empty means use default browser
                quiet = false,
                no_css_inject = false, -- Set to true to disable CSS injection
            })
        end,
    },

    -- HTMX-specific configuration
    {
        "nvim-lua/plenary.nvim",
        config = function()
            -- HTMX filetype detection and configuration
            vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
                pattern = { "*.htmx", "*.hx" },
                callback = function()
                    vim.bo.filetype = "html"
                end,
            })

            -- HTMX template detection for Go's templ
            vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
                pattern = "*.templ",
                callback = function()
                    vim.bo.filetype = "templ"
                end,
            })

            -- HTMX-specific settings for HTML files
            vim.api.nvim_create_autocmd("FileType", {
                pattern = { "html", "templ", "htmldjango", "php", "blade" },
                callback = function()
                    -- Set up HTMX-specific options
                    vim.opt_local.iskeyword:append("-") -- For hx-* attributes
                    
                    -- HTMX common snippets via abbreviations
                    vim.cmd([[
                        iabbrev <buffer> hxget hx-get=""<Left>
                        iabbrev <buffer> hxpost hx-post=""<Left>
                        iabbrev <buffer> hxput hx-put=""<Left>
                        iabbrev <buffer> hxdelete hx-delete=""<Left>
                        iabbrev <buffer> hxpatch hx-patch=""<Left>
                        iabbrev <buffer> hxtarget hx-target=""<Left>
                        iabbrev <buffer> hxswap hx-swap=""<Left>
                        iabbrev <buffer> hxtrigger hx-trigger=""<Left>
                        iabbrev <buffer> hxvals hx-vals=""<Left>
                        iabbrev <buffer> hxconfirm hx-confirm=""<Left>
                        iabbrev <buffer> hxpushurl hx-push-url=""<Left>
                        iabbrev <buffer> hxreplace hx-replace-url=""<Left>
                        iabbrev <buffer> hxselect hx-select=""<Left>
                        iabbrev <buffer> hxinclude hx-include=""<Left>
                        iabbrev <buffer> hxboost hx-boost="true"
                        iabbrev <buffer> hxindicator hx-indicator=""<Left>
                    ]])
                end,
            })

            -- Create user commands for HTMX
            vim.api.nvim_create_user_command("HTMXDoc", function()
                vim.cmd("help htmx")
                vim.notify("Check https://htmx.org/docs/ for complete documentation", vim.log.levels.INFO)
            end, { desc = "Open HTMX documentation" })

            vim.api.nvim_create_user_command("HTMXValidate", function()
                local current_line = vim.api.nvim_get_current_line()
                local htmx_attrs = {
                    "hx-get", "hx-post", "hx-put", "hx-delete", "hx-patch",
                    "hx-target", "hx-swap", "hx-trigger", "hx-vals",
                    "hx-confirm", "hx-push-url", "hx-replace-url",
                    "hx-select", "hx-include", "hx-boost", "hx-indicator"
                }
                
                local found_attrs = {}
                for _, attr in ipairs(htmx_attrs) do
                    if current_line:find(attr) then
                        table.insert(found_attrs, attr)
                    end
                end
                
                if #found_attrs > 0 then
                    vim.notify("Found HTMX attributes: " .. table.concat(found_attrs, ", "), vim.log.levels.INFO)
                else
                    vim.notify("No HTMX attributes found in current line", vim.log.levels.WARN)
                end
            end, { desc = "Validate HTMX attributes in current line" })
        end,
    },
}
