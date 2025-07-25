-- ~/.config/nvim/lua/plugins/treesitter.lua

return {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
        require("nvim-treesitter.configs").setup({
            ensure_installed = {
                "lua", "vim", "vimdoc", "bash", "python", "javascript", "typescript", 
                "json", "html", "css", "markdown", "go", "gomod", "gowork", "gosum",
                -- Enhanced web development support
                "tsx", "scss", "yaml", "toml", "prisma", "graphql",
                "jsdoc", "regex", "gitignore", "dockerfile"
            },
            highlight = {
                enable = true,
                additional_vim_regex_highlighting = false,
            },
            indent = {
                enable = true,
            },
            autotag = {
                enable = true,
            },
            -- Enhanced Go support
            incremental_selection = {
                enable = true,
                keymaps = {
                    init_selection = "<C-space>",
                    node_incremental = "<C-space>",
                    scope_incremental = false,
                    node_decremental = "<bs>",
                },
            },
        })
    end,
}
