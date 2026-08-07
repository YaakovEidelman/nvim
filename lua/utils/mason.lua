local M = {}

-- Installs any of `packages` that are missing. `on_complete` runs once, after
-- the last install finishes, and only if something was actually installed.
function M.ensure_installed(packages, on_complete)
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

    local pending = #missing
    for _, pkg in ipairs(missing) do
      pkg:install({}, function(success, err)
        if not success then
          vim.schedule(function()
            vim.notify(
              ("mason: failed to install %s: %s"):format(pkg.name, vim.inspect(err)),
              vim.log.levels.ERROR
            )
          end)
        end

        pending = pending - 1
        if pending == 0 and on_complete then
          vim.schedule(on_complete)
        end
      end)
    end
  end))
end

return M
