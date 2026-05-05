-- Overseer template provider for .vscode/tasks.json
-- Handles shell, process, and cppbuild task types so that
-- overseer's native DAP integration can resolve preLaunchTask references.

local constants = require("overseer.constants")
local vscode_utils = require("utils.vscode_tasks")
local TAG = constants.TAG

local SUPPORTED_TYPES = { "shell", "process", "cppbuild" }

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
		local raw = vscode_utils.load_tasks()
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
						local cmd = { vscode_utils.expand_vscode_vars(task.command) }
						for _, arg in ipairs(task.args or {}) do
							table.insert(cmd, vscode_utils.expand_vscode_vars(arg))
						end
						return {
							name = task.label,
							cmd = cmd,
							cwd = (task.options and task.options.cwd)
								and vscode_utils.expand_vscode_vars(task.options.cwd)
								or vim.fn.getcwd(),
						}
					end,
				})
			end
		end

		cb(templates)
	end,
}
