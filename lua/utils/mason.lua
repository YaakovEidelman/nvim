local M = {}

local os_utils = require("utils.public.os")

function M.resolve_bin(pkg, win_rel, unix_rel)
	local ok, registry = pcall(require, "mason-registry")
	if not ok then
		return nil
	end
	local ok_pkg, p = pcall(registry.get_package, pkg)
	if not ok_pkg or not p:is_installed() then
		return nil
	end
	local full = (p:get_install_path() .. "/" .. (os_utils.is_windows and win_rel or unix_rel)):gsub("\\", "/")
	if vim.fn.filereadable(full) == 0 and vim.fn.executable(full) == 0 then
		vim.notify(
			("mason: %s is installed but its binary was not found at %s"):format(pkg, full),
			vim.log.levels.ERROR
		)
		return nil
	end
	return full
end

return M
