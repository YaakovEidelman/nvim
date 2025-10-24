require("config.lazy")
require("keymaps")
require("options")

-- LSP to show error in code window
vim.diagnostic.config({
	virtual_text = {
		prefix = "●",
	},
})

vim.cmd("highlight MatchParen cterm=bold ctermfg=white guifg=white")

-- Highlight when yanking text
vim.api.nvim_create_autocmd("TextYankPost", {
	desc = "Highlight when yanking (copying) text",
	group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
	callback = function()
		vim.highlight.on_yank()
	end,
})
