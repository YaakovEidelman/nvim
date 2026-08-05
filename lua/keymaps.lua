local function map(mode, lhs, rhs, desc, opts)
  opts = vim.tbl_extend("force", { noremap = true, desc = desc }, opts or {})
  vim.keymap.set(mode, lhs, rhs, opts)
end

local silent = { silent = true }

-- Quickly source (:so) a file or line
map("n", "<leader><leader>x", "<cmd>source %<CR>", "Lua: source this file")
map("n", "<leader>x", ":.lua<CR>", "Lua: source this line")
map("v", "<leader>x", ":lua<CR>", "Lua: source selection")

-- Change windows with only one ctrl click
map("n", "<C-h>", "<C-w>h", "Window: focus left", silent)
map("n", "<C-j>", "<C-w>j", "Window: focus down", silent)
map("n", "<C-k>", "<C-w>k", "Window: focus up", silent)
map("n", "<C-l>", "<C-w>l", "Window: focus right", silent)

-- Move lines up or down using the alt key, like in vscode
map("n", "<M-j>", ":m .+1<CR>==", "Edit: move line down", silent)
map("n", "<M-k>", ":m .-2<CR>==", "Edit: move line up", silent)
map("v", "<M-j>", ":m '>+1<CR>gv=gv", "Edit: move selection down", silent)
map("v", "<M-k>", ":m '<-2<CR>gv=gv", "Edit: move selection up", silent)

map("n", "<M-h>", "zh", "Scroll: view left one column", silent)
map("n", "<M-l>", "zl", "Scroll: view right one column", silent)
map("v", "<M-h>", "zh", "Scroll: view left one column", silent)
map("v", "<M-l>", "zl", "Scroll: view right one column", silent)

-- Rehighlight selection after indenting for vscode like experiance
map("v", ">", ">gv", "Edit: indent right, keep selection")
map("v", "<", "<gv", "Edit: indent left, keep selection")

-- File explorer (netrw)
map("n", "<leader>e", "<cmd>Explore<cr>", "File: toggle explorer (current file)")

-- Open file explorer at ~/.config/nvim
map("n", "<leader>con", function()
  vim.cmd.edit(vim.fn.stdpath("config"))
end, "Config: open nvim config directory")

map("n", "<leader>tn", ":tabnew<cr>", "Tab: new")

map("i", "<C-bs>", "<C-w>", "Edit: delete previous word")
map("i", "<C-H>", "<C-w>", "Edit: delete previous word (Windows/WSL)")

map("t", "<C-e>", [[<C-\><C-n>]], "Terminal: exit to normal mode", silent)

map("n", "gd", vim.lsp.buf.definition, "LSP: go to definition")
map("n", "gl", vim.diagnostic.open_float, "LSP: show diagnostic float")

map("n", "<leader>m", "'", "Jump: to mark", { noremap = false })
map("n", "<leader>w", ":w<cr>", "File: save")
map("n", "<leader>q", ":q<cr>", "File: quit")
map("n", "<leader>bb", ":bp<cr>", "Buffer: previous")
map("n", "<leader>bn", ":bn<cr>", "Buffer: next")
map("n", "<leader>ya", ":%y<cr>", "Edit: yank whole buffer")

map("n", "<leader>gd", function()
  if vim.fn.executable("code") == 0 then
    vim.notify(
      "VSCode not found — install it at https://code.visualstudio.com/download",
      vim.log.levels.WARN
    )
    return
  end
  vim.fn.jobstart({ "code", "." })
end, "Tool: open folder in VS Code")

map("n", "<leader>cc", function()
  vim.fn.setreg("+", "")
  vim.fn.setreg("*", "")
end, "Clipboard: clear")

map("n", "<leader>lr", "<cmd>lsp restart<cr>", "LSP: restart clients for this buffer")

map("n", "<leader>lt", function()
  if vim.fn.exists(":Roslyn") == 0 then
    vim.notify("Roslyn is not loaded in this buffer", vim.log.levels.WARN)
    return
  end
  vim.cmd("Roslyn target")
end, "LSP: pick Roslyn solution target")
