-- Adds the cppbuild task type (ms-vscode.cpptools) to overseer's builtin .vscode/tasks.json
-- support, which ships providers only for shell/process/npm/typescript/func.
-- Found via the runtimepath by M.get_provider in overseer/vscode/init.lua, which requires
-- "overseer.vscode.provider.<task type>". The path is the registration; there is no other hook.
-- cppbuild has the same shape as a process task: an executable plus pre-split args.
-- options.cwd/env and problemMatcher are handled by the caller, not here.
local M = {}

M.get_task_opts = function(defn)
  return {
    cmd = vim.list_extend({ defn.command }, defn.args or {}),
  }
end

return M
