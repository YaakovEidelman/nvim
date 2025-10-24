-- Quickly source (:so) a file or line
vim.keymap.set("n", "<space><space>x", "<cmd>source %<CR>")
vim.keymap.set("n", "<space>x", ":.lua<CR>")
vim.keymap.set("v", "<space>x", ":lua<CR>")

-- Change windows with only one ctrl click
vim.keymap.set("n", "<C-h>", "<C-w>h", { noremap = true, silent = true })
vim.keymap.set("n", "<C-j>", "<C-w>j", { noremap = true, silent = true })
vim.keymap.set("n", "<C-k>", "<C-w>k", { noremap = true, silent = true })
vim.keymap.set("n", "<C-l>", "<C-w>l", { noremap = true, silent = true })

-- Move lines up or down using the alt key, like in vscode
vim.keymap.set("n", "<M-j>", ":m .+1<CR>==", { noremap = true, silent = true })
vim.keymap.set("n", "<M-k>", ":m .-2<CR>==", { noremap = true, silent = true })
vim.keymap.set("v", "<M-j>", ":m '>+1<CR>gv=gv", { noremap = true, silent = true })
vim.keymap.set("v", "<M-k>", ":m '<-2<CR>gv=gv", { noremap = true, silent = true })

-- Rehighlight selection after indenting for vscode like experiance
vim.keymap.set("v", ">", ">gv")
vim.keymap.set("v", "<", "<gv")

-- Go to file explorer
vim.keymap.set("n", "<leader>of", ":Ex <CR>", { noremap = true })

-- Open file explorer at ~/.config/nvim
vim.keymap.set("n", "<leader>con", function()
	vim.cmd.edit(vim.fn.stdpath("config"))
end, { desc = "Edit Nvim config directory" })

-- Open telescope fuzzy find
vim.keymap.set("n", "<leader>ff", ":Telescope find_files<CR>", { noremap = true })

-- LSP format the buffer/file
vim.keymap.set("n", "<M-F>", function()
	vim.lsp.buf.format()
end)

-- Open new tab to newtr (file explorer)
vim.keymap.set("n", "<leader>tn", function()
	vim.cmd("tabnew | Explore")
end)
