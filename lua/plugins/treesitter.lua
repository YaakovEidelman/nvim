return {
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    lazy = false,
    build = ":TSUpdate",
    config = function()
      local ts = require("nvim-treesitter")
      ts.install({
        "c",
        "cpp",
        "lua",
        "vim",
        "vimdoc",
        "query",
        "markdown",
        "typescript",
        "javascript",
        "tsx",
        "python",
        "rust",
        "html",
        "css",
        "c_sharp",
      })

      vim.api.nvim_create_autocmd("FileType", {
        group = vim.api.nvim_create_augroup("treesitter-start", { clear = true }),
        callback = function(args)
          local buf = args.buf
          local lang = vim.treesitter.language.get_lang(vim.bo[buf].filetype)
          if not lang then
            return
          end

          if vim.tbl_contains(ts.get_installed(), lang) then
            vim.treesitter.start(buf, lang)
          elseif vim.tbl_contains(ts.get_available(), lang) then
            ts.install(lang):await(function(err)
              if err then
                vim.schedule(function()
                  vim.notify(
                    ("treesitter: failed to install parser for %q: %s"):format(lang, err),
                    vim.log.levels.ERROR
                  )
                end)
                return
              end
              vim.schedule(function()
                if
                  vim.api.nvim_buf_is_valid(buf) and vim.tbl_contains(ts.get_installed(), lang)
                then
                  vim.treesitter.start(buf, lang)
                end
              end)
            end)
          end
        end,
      })
    end,
  },
}
