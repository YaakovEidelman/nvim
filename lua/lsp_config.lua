local servers = require("lsp.servers")
local ok, blink = pcall(require, "blink.cmp")
vim.lsp.config("*", {
  capabilities = ok and blink.get_lsp_capabilities() or vim.lsp.protocol.make_client_capabilities(),
  on_attach = function(client, bufnr)
    if client:supports_method("textDocument/inlayHint") then
      vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
    end

    if client:supports_method("textDocument/documentHighlight") then
      local group = vim.api.nvim_create_augroup("lsp_document_highlight", { clear = false })
      vim.api.nvim_clear_autocmds({ group = group, buffer = bufnr })
      vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
        buffer = bufnr,
        group = group,
        callback = vim.lsp.buf.document_highlight,
      })
      vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
        buffer = bufnr,
        group = group,
        callback = vim.lsp.buf.clear_references,
      })
    end
  end,
})

for name, config in pairs(servers) do
  vim.lsp.config(name, config)
end

vim.lsp.enable(vim.tbl_keys(servers))

-- LSP to show error in code window
vim.diagnostic.config({
  virtual_lines = false,
  virtual_text = {
    prefix = "●",
  },
  float = {
    border = "rounded",
    max_width = 100,
    source = true,
  },
})
