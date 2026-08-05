local M = {}

-- Applies `groups` now and again after every colorscheme load, which resets highlights.
function M.persist(name, groups)
  local function apply()
    for group, opts in pairs(groups) do
      vim.api.nvim_set_hl(0, group, opts)
    end
  end

  apply()
  vim.api.nvim_create_autocmd("ColorScheme", {
    group = vim.api.nvim_create_augroup("UserHighlights." .. name, { clear = true }),
    pattern = "*",
    desc = "Reapply " .. name .. " highlight overrides",
    callback = apply,
  })
end

return M
