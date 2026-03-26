local M = {}

local modeMap = {
	n = " Normal ",
	i = " Insert ",
	v = " Visual ",
	V = " Visual Line ",
	[""] = " Visual Block ",
	c = " Command ",
	R = " Replace ",
	t = " Terminal ",
}

local currentModeColor = function(mode)
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
	return hl
end

local highlightColorWrapper = function(highlight)
	return "%#" .. highlight .. "#"
end

local function git_status()
	local status = vim.b.gitsigns_status_dict
	if not status then
		return ""
	end

	local branch = status.head or ""
	local added = status.added or 0
	local changed = status.changed or 0
	local removed = status.removed or 0

	local parts = {}

	if branch ~= "" then
		table.insert(parts, " " .. branch)
	end
	if added > 0 then
		table.insert(parts, "+" .. added)
	end
	if changed > 0 then
		table.insert(parts, "~" .. changed)
	end
	if removed > 0 then
		table.insert(parts, "-" .. removed)
	end

	return table.concat(parts, " ")
end

M.winbarConfig = function()
	local mode = vim.fn.mode()
	local hl = currentModeColor(mode)
	local time = "%#" .. hl .. "#%{strftime('%b %d %Y %I:%M %p')}"
	local sep = "%=" -- right-align rest
	local file = "%F" -- full file path
	local modified = "%{&modified?'*':''}" -- modified flag

	local winbar = table.concat({ time, sep, file, modified }, " ")

	return winbar
end

M.statuslineConfig = function()
	local defaultStatusLineHighlightColorSeperator = highlightColorWrapper("StatusLine")

	local mode = vim.fn.mode()
	local hl = currentModeColor(mode)
	local currentMode = highlightColorWrapper(hl) .. modeMap[mode]

	local git = git_status()
	local gitPart = git ~= "" and git or ""

	local statusline = table.concat({ currentMode, defaultStatusLineHighlightColorSeperator, " ", gitPart })
	return statusline
end

return M
