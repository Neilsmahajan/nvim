-- ~/.config/nvim/lua/plugins/cmp.lua

return {
    "hrsh7th/nvim-cmp",
    dependencies = {
        "hrsh7th/cmp-nvim-lsp",
        "L3MON4D3/LuaSnip",
        "saadparwaiz1/cmp_luasnip",
    },
    config = function()
        local cmp = require("cmp")
        local luasnip = require("luasnip")

        -- Load Arduino snippets only when needed
        vim.api.nvim_create_autocmd("FileType", {
            pattern = "arduino",
            callback = function()
                local ok, arduino_snippets = pcall(require, "snippets.arduino")
                if ok and arduino_snippets then
                    luasnip.add_snippets("arduino", arduino_snippets)
                end
            end,
        })

        cmp.setup({
            snippet = {
                expand = function(args)
                    luasnip.lsp_expand(args.body)
                end,
            },
            mapping = cmp.mapping.preset.insert({
                ["<Up>"]      = cmp.mapping.select_prev_item(),  -- navigate list ↑
                ["<Down>"]    = cmp.mapping.select_next_item(),  -- navigate list ↓
                ["<CR>"]      = cmp.mapping.confirm({ select = true }), -- accept item
                ["<C-Space>"] = cmp.mapping.complete(),          -- manual completion
                -- leave <Tab> & <S-Tab> unmapped; Copilot will grab <Tab>    }),
            }),
            sources = cmp.config.sources({
                { name = "nvim_lsp" },
                { name = "luasnip" },
            }),
        })
    end,
}
