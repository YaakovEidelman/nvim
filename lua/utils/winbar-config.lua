local M = {}

M.winbarConfig = function()
	local mode = vim.fn.mode()
	local mode_hl = {
		n = "StatuslineGreen",
		i = "StatuslineBlue",
		v = "StatuslinePurple",
		V = "StatuslinePurple",
		[""] = "StatuslinePurple", -- Visual block
		c = "StatuslineRed",
		R = "StatuslineDeepRed",
		t = "StatuslineGreen",
	}
	local hl = mode_hl[mode] or "StatuslineGreen"

	local time = "%#" .. hl .. "#%{strftime('%b %d %Y %I:%M %p')}"
	local sep = "%=" -- right-align rest
	local file = "%F" -- full file path
	local modified = "%{&modified?'*':''}" -- modified flag

	local winbar = table.concat({ time, sep, file, modified }, " ")

	return winbar
end

return M
