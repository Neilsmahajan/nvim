-- Minimal Copilot setup: use Ctrl+l to accept, disable Tab mapping
return {
	"github/copilot.vim",
	event = "InsertEnter",
	config = function()
		-- Keep Tab for indentation/completion (nvim-cmp), use Ctrl+l to accept Copilot
		vim.g.copilot_no_tab_map = true
		vim.keymap.set("i", "<C-l>", 'copilot#Accept("\\<CR>")', {
			expr = true,
			replace_keycodes = false,
			silent = true,
			desc = "Copilot: accept suggestion",
		})
	end,
}
