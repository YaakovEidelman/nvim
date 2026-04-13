-- Overseer template provider for .vscode/tasks.json
-- Handles shell, process, and cppbuild task types so that
-- overseer's native DAP integration can resolve preLaunchTask references.

local constants = require("overseer.constants")
local TAG = constants.TAG

local SUPPORTED_TYPES = { "shell", "process", "cppbuild" }

local function expand(s)
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

local function load_tasks()
	local path = vim.fn.getcwd() .. "/.vscode/tasks.json"
	local f = io.open(path, "r")
	if not f then
		return nil
	end
	local content = f:read("*a")
	f:close()
	content = content:gsub("/%*(.-)%*/", ""):gsub("//[^\n]*", "")
	local ok, data = pcall(vim.json.decode, content)
	return ok and (data.tasks or {}) or nil
end

local function is_default_build(group)
	if type(group) == "table" then
		return group.kind == "build" and group.isDefault == true
	end
	return false
end

return {
	name = "vscode_tasks",
	condition = {
		callback = function()
			return vim.fn.filereadable(vim.fn.getcwd() .. "/.vscode/tasks.json") == 1
		end,
	},
	generator = function(_, cb)
		local raw = load_tasks()
		if not raw then
			return cb({})
		end

		local templates = {}
		for _, task in ipairs(raw) do
			if vim.tbl_contains(SUPPORTED_TYPES, task.type) and task.label then
				local tags = {}
				if is_default_build(task.group) then
					table.insert(tags, TAG.BUILD)
				end

				table.insert(templates, {
					name = task.label,
					tags = tags,
					builder = function()
						local cmd = { expand(task.command) }
						for _, arg in ipairs(task.args or {}) do
							table.insert(cmd, expand(arg))
						end
						return {
							name = task.label,
							cmd = cmd,
							cwd = (task.options and task.options.cwd)
								and expand(task.options.cwd)
								or vim.fn.getcwd(),
						}
					end,
				})
			end
		end

		cb(templates)
	end,
}
