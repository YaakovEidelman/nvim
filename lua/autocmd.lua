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

-- netrw keybindings
-- vim.schedule is required: netrw sets its own buffer-local maps (e.g. <C-l> for refresh)
-- inside NetrwMaps() which fires after the FileType event. Scheduling ensures our maps
-- are applied last and actually stick.
vim.api.nvim_create_autocmd("FileType", {
  pattern = "netrw",
  desc = "Better mappings for Netrw",
  callback = function()
    vim.schedule(function()
      local bind = function(lhs, rhs)
        vim.keymap.set("n", lhs, rhs, { noremap = true, buffer = true, nowait = true })
      end

      bind("<C-h>", "<C-w>h")
      bind("<C-j>", "<C-w>j")
      bind("<C-k>", "<C-w>k")
      bind("<C-l>", "<C-w>l")
    end)
  end
})
