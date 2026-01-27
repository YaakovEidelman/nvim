-- Highlight when yanking text
vim.api.nvim_create_autocmd("TextYankPost", {
	desc = "Highlight when yanking (copying) text",
	group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
	callback = function()
		vim.highlight.on_yank()
	end,
})

-- Add all diagnostics to quick fix list
vim.api.nvim_create_autocmd("DiagnosticChanged", {
	callback = function()
		vim.diagnostic.setqflist({
			-- severity = { min = vim.diagnostic.severity.WARN },
			-- bufnr = vim.api.nvim_get_current_buf(),
			open = false,
		})
	end,
})
