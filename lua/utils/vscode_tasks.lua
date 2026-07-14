local M = {}

local function expand_vscode_vars(s)
	if type(s) ~= "string" then
		return s
	end
	local cwd = vim.fn.getcwd()
	s = s:gsub("${workspaceFolder}", cwd)
	s = s:gsub("${file}", vim.fn.expand("%:p"))
	s = s:gsub("${fileBasename}", vim.fn.expand("%:t"))
	s = s:gsub("${fileBasenameNoExtension}", vim.fn.expand("%:t:r"))
	s = s:gsub("${fileDirname}", vim.fn.expand("%:p:h"))
	s = s:gsub("${relativeFile}", vim.fn.expand("%:."))
	return s
end
M.expand_vscode_vars = expand_vscode_vars

local function load_tasks()
	local tasks_path = vim.fn.getcwd() .. "/.vscode/tasks.json"
	local f = io.open(tasks_path, "r")
	if not f then
		return nil, "tasks.json not found"
	end
	local content = f:read("*a")
	f:close()

	-- Strip JSONC line and block comments
	content = content:gsub("/%*(.-)%*/", ""):gsub("//[^\n]*", "")

	local ok, data = pcall(vim.json.decode, content)
	if not ok then
		return nil, "Failed to parse tasks.json: " .. data
	end
	return data.tasks or {}, nil
end
M.load_tasks = load_tasks

return M
