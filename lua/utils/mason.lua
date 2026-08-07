local M = {}

local os_utils = require("utils.os")

function M.resolve_bin(pkg, win_rel, unix_rel)
  local ok, registry = pcall(require, "mason-registry")
  if not ok then
    return nil
  end
  local ok_pkg, p = pcall(registry.get_package, pkg)
  if not ok_pkg or not p:is_installed() then
    vim.notify(
      ("mason: %s is not installed, run :Mason to install it"):format(pkg),
      vim.log.levels.WARN
    )
    return nil
  end
  local full = (p:get_install_path() .. "/" .. (os_utils.is_windows and win_rel or unix_rel)):gsub(
    "\\",
    "/"
  )
  if vim.fn.filereadable(full) == 0 and vim.fn.executable(full) == 0 then
    vim.notify(
      ("mason: %s is installed but its binary was not found at %s"):format(pkg, full),
      vim.log.levels.ERROR
    )
    return nil
  end
  return full
end

function M.ensure_installed(packages)
  if not packages or #packages == 0 then
    return
  end

  local ok, registry = pcall(require, "mason-registry")
  if not ok then
    return
  end

  registry.refresh(vim.schedule_wrap(function()
    local missing = {}
    for _, name in ipairs(packages) do
      local ok_pkg, pkg = pcall(registry.get_package, name)
      if not ok_pkg then
        vim.notify(("mason: no package named %q"):format(name), vim.log.levels.WARN)
      elseif not pkg:is_installed() and not pkg:is_installing() then
        table.insert(missing, pkg)
      end
    end

    if #missing == 0 then
      return
    end

    local names = vim.tbl_map(function(pkg)
      return pkg.name
    end, missing)
    vim.notify(("mason: installing %s"):format(table.concat(names, ", ")), vim.log.levels.INFO)

    for _, pkg in ipairs(missing) do
      pkg:install({})
    end
  end))
end

return M
