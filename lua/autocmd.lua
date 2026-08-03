-- Highlight when yanking text
vim.api.nvim_create_autocmd("TextYankPost", {
  desc = "Highlight when yanking (copying) text",
  group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
  callback = function()
    vim.hl.on_yank()
  end,
})

-- Add all diagnostics to quick fix list
-- vim.api.nvim_create_autocmd("DiagnosticChanged", {
-- 	group = vim.api.nvim_create_augroup("diagnostic-changed", { clear = true }),
-- 	callback = function()
-- 		vim.diagnostic.setqflist({
-- 			-- severity = { min = vim.diagnostic.severity.WARN },
-- 			-- bufnr = vim.api.nvim_get_current_buf(),
-- 			open = false,
-- 		})
-- 	end,
-- })

-- Redraw the statusline while a language server reports indexing progress
vim.api.nvim_create_autocmd("LspProgress", {
  group = vim.api.nvim_create_augroup("lsp-progress", { clear = true }),
  desc = "Refresh statusline on LSP progress",
  callback = function()
    vim.cmd("redrawstatus")
  end,
})

-- netrw keybindings
-- vim.schedule is required: netrw sets its own buffer-local maps (e.g. <C-l> for refresh)
-- inside NetrwMaps() which fires after the FileType event. Scheduling ensures our maps
-- are applied last and actually stick.
vim.api.nvim_create_autocmd("FileType", {
  pattern = "netrw",
  group = vim.api.nvim_create_augroup("netrw-fixes", { clear = true }),
  desc = "Better mappings for Netrw",
  callback = function()
    vim.schedule(function()
      local bind = function(lhs, rhs, desc)
        vim.keymap.set("n", lhs, rhs, { noremap = true, buffer = true, nowait = true, desc = desc })
      end

      bind("<C-h>", "<C-w>h", "Window: focus left")
      bind("<C-j>", "<C-w>j", "Window: focus down")
      bind("<C-k>", "<C-w>k", "Window: focus up")
      bind("<C-l>", "<C-w>l", "Window: focus right")
    end)
  end,
})
