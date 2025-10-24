require("config.lazy")
require("keymaps")
require("options")

-- LSP to show error in code window
vim.diagnostic.config({
	virtual_text = {
		prefix = "●",
	},
})

-- Highlight when yanking text
vim.api.nvim_create_autocmd("TextYankPost", {
	desc = "Highlight when yanking (copying) text",
	group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
	callback = function()
		vim.highlight.on_yank()
	end,
})

vim.api.nvim_create_autocmd("CursorHold", {
	callback = function()
		vim.lsp.buf.document_highlight()
	end,
	desc = "Highlight references on cursor hold",
})

vim.api.nvim_create_autocmd("CursorMoved", {
	callback = function()
		vim.lsp.buf.clear_references()
	end,
	desc = "Clear highlight on cursor move",
})

vim.api.nvim_create_autocmd("DiagnosticChanged", {
	callback = function()
		vim.diagnostic.setqflist({
			severity = { min = vim.diagnostic.severity.WARN },
			bufnr = vim.api.nvim_get_current_buf(),
			open = false,
		})
	end,
})
