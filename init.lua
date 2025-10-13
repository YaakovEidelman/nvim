print("init.lua start")

require("config.lazy")


vim.opt.expandtab = true
vim.opt.shiftwidth = 4
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.smarttab = true

vim.opt.clipboard = "unnamedplus"
vim.opt.number = true
vim.opt.wrap = false

vim.keymap.set("n", "<space><space>x", "<cmd>source %<CR>")
vim.keymap.set("n", "<space>x", ":.lua<CR>")
vim.keymap.set("v", "<space>x", ":lua<CR>")


vim.keymap.set('n', '<C-h>', '<C-w>h', { noremap = true, silent = true })
vim.keymap.set('n', '<C-j>', '<C-w>j', { noremap = true, silent = true })
vim.keymap.set('n', '<C-k>', '<C-w>k', { noremap = true, silent = true })
vim.keymap.set('n', '<C-l>', '<C-w>l', { noremap = true, silent = true })

vim.keymap.set("n", "<leader>of", ":Ex <CR>", { noremap = true })
-- vim.keymap.set("n", "<leader>ff", ":Telescope find_files<CR>", {noremap = true })

-- LSP format the buffer/file
vim.keymap.set("n", "<M-F>", function() vim.lsp.buf.format() end)

vim.diagnostic.config({
  virtual_text = {
    prefix = "●",
  },
})


vim.cmd('highlight MatchParen cterm=bold ctermfg=white guifg=white')

-- Highlight when yanking text
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})
