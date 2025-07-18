-- ~/.config/nvim/lua/plugins/cmp.lua

local cmp = require("cmp")
local luasnip = require("luasnip")

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
