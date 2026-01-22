vim.opt.expandtab = true
vim.opt.shiftwidth = 4
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.smarttab = true
vim.opt.clipboard = "unnamedplus"
vim.opt.number = true
vim.opt.wrap = false
vim.opt.scrolloff = 10
vim.opt.termguicolors = true

-- Windows: Use backslashes for paths (required for netcoredbg breakpoints)
if vim.fn.has("win32") == 1 or vim.fn.has("win64") == 1 then
    vim.opt.shellslash = false
end

-- vim.g["test#strategy"] = "neovim"

