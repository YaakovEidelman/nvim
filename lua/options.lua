vim.opt.expandtab = true
vim.opt.shiftwidth = 4
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.smarttab = true
vim.opt.clipboard = "unnamedplus"
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.wrap = false
vim.opt.scrolloff = 10
vim.opt.termguicolors = true
vim.opt.colorcolumn = "80"

vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
vim.opt.foldlevel = 99
vim.opt.foldlevelstart = 99
vim.opt.foldenable = true
vim.opt.foldcolumn = "1"
vim.opt.foldtext = ""


vim.opt.swapfile = false

vim.opt.autocomplete = true

vim.opt.showtabline = 2
vim.opt.tabline = "%!v:lua.require'utils.tabline'.run()"
vim.opt.winbar = "%F %{&modified ? '[+]' : ''}"
vim.opt.showmode = false

vim.cmd.colorscheme("lunaperche")
vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
vim.api.nvim_set_hl(0, "NormalNC", { bg = "none" })

vim.g.netrw_winsize = 20
vim.g.netrw_liststyle = 3
vim.g.netrw_banner = 0
vim.keymap.set('n', '<leader>e', ':Lexplore!<cr>', { nowait = true })
