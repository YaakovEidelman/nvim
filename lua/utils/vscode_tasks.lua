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

-- Run a .vscode/tasks.json task by label via overseer.
-- Calls on_success() when the task exits successfully.
function M.run(task_name, on_success)
	local tasks, err = load_tasks()
	if not tasks then
		vim.notify("[dap] " .. err, vim.log.levels.ERROR)
		return
	end

	local task_def
	for _, t in ipairs(tasks) do
		if t.label == task_name then
			task_def = t
			break
		end
	end

	if not task_def then
		vim.notify("[dap] preLaunchTask not found: " .. task_name, vim.log.levels.ERROR)
		return
	end

	local cmd = { expand_vscode_vars(task_def.command) }
	for _, arg in ipairs(task_def.args or {}) do
		table.insert(cmd, expand_vscode_vars(arg))
	end

	local task_cwd = (task_def.options and task_def.options.cwd)
		and expand_vscode_vars(task_def.options.cwd)
		or vim.fn.getcwd()

	local overseer = require("overseer")
	local task = overseer.new_task({
		name = task_name,
		cmd = cmd,
		cwd = task_cwd,
	})
	task:start()

	local timer = (vim.uv or vim.loop).new_timer()
	timer:start(0, 200, vim.schedule_wrap(function()
		local s = task.status
		if s == overseer.STATUS.SUCCESS then
			timer:stop()
			timer:close()
			on_success()
		elseif s ~= overseer.STATUS.RUNNING then
			timer:stop()
			timer:close()
			vim.notify("[dap] preLaunchTask failed — see build output", vim.log.levels.ERROR)
			overseer.open({ enter = true })
		end
	end))
end

-- Patch dap.run to handle preLaunchTask using .vscode/tasks.json.
-- Call this once after nvim-dap is set up.
function M.patch_dap(dap)
	local orig_run = dap.run
	dap.run = function(config, opts)
		local pre_task = config.preLaunchTask
		if not pre_task then
			return orig_run(config, opts)
		end
		local clean = vim.tbl_extend("force", {}, config)
		clean.preLaunchTask = nil
		M.run(pre_task, function()
			orig_run(clean, opts)
		end)
	end
end

return M
