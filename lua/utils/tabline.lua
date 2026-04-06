local M = {}

function M.run()
	local s = ""
	local current = vim.fn.tabpagenr()

	for i = 1, vim.fn.tabpagenr("$") do
		local bufnr = vim.fn.tabpagebuflist(i)[vim.fn.tabpagewinnr(i)]
		local name = vim.fn.fnamemodify(vim.fn.bufname(bufnr), ":t")
		if name == "" then
			name = "[No Name]"
		end

		-- Highlight active vs inactive tab
		if i == current then
			s = s .. "%#TabLineSel#"
		else
			s = s .. "%#TabLine#"
		end

		-- Tab click target + label
		s = s .. "%" .. i .. "T " .. name .. " "
        local modified = vim.bo[bufnr].modified
        if modified then
            s = s .. "[+]"
        end

		-- Separator (not after last tab)
		if i < vim.fn.tabpagenr("$") then
			s = s .. "%#TabLineFill#|"
		end
	end

	-- Reset highlight + end clickable area
	s = s .. "%#TabLineFill#%T"

	return s
end

return M
