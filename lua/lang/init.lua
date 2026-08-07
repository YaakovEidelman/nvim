-- Loads every language file in this folder and merges them into one place.
--
-- Each `lua/lang/<name>.lua` returns a table describing everything that
-- language needs. Every key is optional:
--
--   filetypes        list of filetypes this language covers
--   parsers          treesitter parser names
--   servers          lspconfig server name -> settings table
--   formatters       filetype -> list of conform formatter names
--   formatter_config conform formatter name -> custom definition
--   adapters         nvim-dap adapter name -> config
--   mason            mason package names needed for this language
--
-- Adapters are plain data. Mason puts its own bin directory at the front of
-- PATH, so refer to a mason binary by bare name -- no paths, no per-OS
-- branching. `adapters()` expands the name to a full path via `exepath`,
-- because libuv spawns without PATH lookup and on Windows the mason shim is a
-- `.cmd` that will not be found by bare name:
--
--   adapters = {
--     codelldb = {
--       type = "server",
--       executable = { command = "codelldb" },
--     },
--     lldb = "codelldb", -- a string value is an alias for another adapter
--   }
--
-- Delete a file and that language is gone everywhere.

local M = {}

local specs = nil

local function load()
  if specs then
    return specs
  end

  specs = {}
  local dir = vim.fs.joinpath(vim.fn.stdpath("config"), "lua", "lang")

  for name, kind in vim.fs.dir(dir) do
    local mod = name:match("^(.+)%.lua$")
    if kind == "file" and mod and mod ~= "init" then
      local ok, spec = pcall(require, "lang." .. mod)
      if ok and type(spec) == "table" then
        specs[mod] = spec
      else
        vim.notify(("lang: could not load %q: %s"):format(mod, spec), vim.log.levels.ERROR)
      end
    end
  end

  return specs
end

function M.all()
  return load()
end

function M.parsers()
  local seen = {}
  for _, spec in pairs(load()) do
    for _, parser in ipairs(spec.parsers or {}) do
      seen[parser] = true
    end
  end
  return vim.tbl_keys(seen)
end

function M.servers()
  local out = {}
  for _, spec in pairs(load()) do
    for name, config in pairs(spec.servers or {}) do
      out[name] = config
    end
  end
  return out
end

function M.formatters_by_ft()
  local out = {}
  for _, spec in pairs(load()) do
    for ft, list in pairs(spec.formatters or {}) do
      out[ft] = list
    end
  end
  return out
end

function M.formatter_config()
  local out = {}
  for _, spec in pairs(load()) do
    for name, config in pairs(spec.formatter_config or {}) do
      out[name] = config
    end
  end
  return out
end

local function expand_command(tbl)
  if type(tbl) ~= "table" or type(tbl.command) ~= "string" then
    return tbl
  end

  local full = vim.fn.exepath(tbl.command)
  if full == "" then
    return tbl
  end

  local out = vim.tbl_extend("force", {}, tbl)
  out.command = full
  return out
end

local function resolve_adapter(def)
  local out = expand_command(def)
  if type(out.executable) == "table" then
    if out == def then
      out = vim.tbl_extend("force", {}, def)
    end
    out.executable = expand_command(out.executable)
  end
  return out
end

function M.adapters()
  local out = {}
  local aliases = {}

  for _, spec in pairs(load()) do
    for name, def in pairs(spec.adapters or {}) do
      if type(def) == "string" then
        aliases[name] = def
      elseif type(def) == "table" then
        out[name] = resolve_adapter(def)
      end
    end
  end

  for name, target in pairs(aliases) do
    out[name] = out[target]
  end

  return out
end

function M.packages_for_filetype(ft)
  local out = {}
  for _, spec in pairs(load()) do
    if vim.tbl_contains(spec.filetypes or {}, ft) then
      vim.list_extend(out, spec.mason or {})
    end
  end
  return out
end

function M.packages()
  local seen = {}
  for _, spec in pairs(load()) do
    for _, pkg in ipairs(spec.mason or {}) do
      seen[pkg] = true
    end
  end
  return vim.tbl_keys(seen)
end

return M
