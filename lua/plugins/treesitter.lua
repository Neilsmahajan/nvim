-- ~/.config/nvim/lua/plugins/treesitter.lua

return {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
        require("nvim-treesitter.configs").setup({
            ensure_installed = {
                "lua", "vim", "vimdoc", "bash", "python", "javascript", "typescript", 
                "json", "html", "css", "scss", "markdown", "go", "gomod", "gowork", "gosum",
                -- Enhanced web development support
                "tsx", "yaml", "toml", "prisma", "graphql",
                "jsdoc", "regex", "gitignore", "dockerfile",
                -- HTMX and template support  
                "xml", "http", "query",
                -- C/C++ and Arduino development support
                "c", "cpp", "cmake", "make"
            },
            highlight = {
                enable = true,
                additional_vim_regex_highlighting = false,
            },
            indent = {
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
