-- ~/.config/nvim/lua/plugins/treesitter.lua

require("nvim-treesitter.configs").setup({
    ensure_installed = {
        "lua", "vim", "bash", "python", "javascript", "typescript", "json", "html", "css", "markdown", "go"
    },
    highlight = {
        enable = true,
        additional_vim_regex_highlighting = false,
    },
    indent = {
        enable = true,
    },
})
