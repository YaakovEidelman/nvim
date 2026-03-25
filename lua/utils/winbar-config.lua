local M = {}

M.winbarConfig = function()
  local mode = vim.fn.mode()
  local mode_hl = {
    n = "MiniStatuslineModeNormal",
    i = "MiniStatuslineModeInsert",
    v = "MiniStatuslineModeVisual",
    V = "MiniStatuslineModeVisual",
    [""] = "MiniStatuslineModeVisual", -- Visual block
    c = "MiniStatuslineModeCommand",
    R = "MiniStatuslineModeReplace",
    t = "MiniStatuslineModeTerminal",
  }

  local hl = mode_hl[mode] or "MiniStatuslineModeNormal"

  -- Build the winbar string
  local winbar = string.format(
    "%%#%s#%%{strftime('%%b %%d %%Y %%I:%%M %%p')} %%=%s%%{&modified?'*':''}",
    hl,
    "%F"
  )

  return winbar
end

return M
