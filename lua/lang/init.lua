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
-- Adapters are plain data. If one needs a binary out of mason, give it a `bin`
-- table and write `${bin}` wherever the path belongs -- same idea as dap's own
-- `${port}`. The path is resolved per OS when the adapter is read, and the
-- adapter is skipped entirely if the package isn't installed:
--
--   adapters = {
--     codelldb = {
--       bin = { package = "codelldb", win = "adapter/codelldb.exe", unix = "adapter/codelldb" },
--       type = "server",
--       executable = { command = "${bin}" },
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

local function substitute(value, bin)
  if type(value) == "string" then
    return (value:gsub("%$%{bin%}", bin))
  end

  if type(value) ~= "table" then
    return value
  end

  local out = {}
  for key, item in pairs(value) do
    out[key] = substitute(item, bin)
  end
  return out
end

local function resolve_adapter(def)
  if not def.bin then
    return substitute(def, "")
  end

  local path = require("utils.mason").resolve_bin(def.bin.package, def.bin.win, def.bin.unix)
  if not path then
    return nil
  end

  local out = {}
  for key, value in pairs(def) do
    if key ~= "bin" then
      out[key] = substitute(value, path)
    end
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
