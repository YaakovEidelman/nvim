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

local function is_dapui()
	local ft = vim.bo.filetype
	return ft:match("^dapui") or ft == "dap-repl"
end

-- Change winbar on mode changed
vim.api.nvim_create_autocmd({ "ModeChanged", "BufEnter" }, {
	pattern = "*",
	callback = function()
		if is_dapui() then
			return
		end
		local wb = require("utils.winbar-config")
		vim.wo.winbar = wb.winbarConfig()
	end,
})

vim.api.nvim_create_autocmd({
	"ModeChanged",
	"BufEnter",
	"BufWinEnter",
	"VimEnter",
	"DirChanged",
	"User",
}, {
	pattern = "*",
	callback = function()
		if is_dapui() then
			return
		end
		local wb = require("utils.winbar-config")
		vim.wo.statusline = wb.statuslineConfig()
	end,
})
