return {
  {
    "echasnovski/mini.nvim",
    config = function()
      local statusline = require("mini.statusline")
      local minipairs = require("mini.pairs")
      local minigit = require("mini.git")
      local minidiff = require("mini.diff")
      -- local clue = require("mini.clue")

      local function lsp_section()
        if statusline.is_truncated(75) then
          return ""
        end
        local clients = vim.lsp.get_clients({ bufnr = 0 })
        if #clients == 0 then
          return ""
        end
        local names = vim.tbl_map(function(c)
          return c.name
        end, clients)
        local section = "󰰎 " .. table.concat(names, ", ")
        local progress = vim.lsp.status()
        if progress ~= "" then
          section = section .. " │ " .. progress
        end
        return section
      end

      statusline.setup({
        use_icons = true,
        content = {
          active = function()
            local mode, mode_hl = statusline.section_mode({ trunc_width = 120 })
            local git = statusline.section_git({ trunc_width = 40 })
            local diagnostics = statusline.section_diagnostics({ trunc_width = 75 })
            local lsp = lsp_section()
            -- local filename = vim.bo.buftype == "terminal" and "%t" or "%F%{&modified?'*':''}%r"
            local fileinfo = statusline.section_fileinfo({ trunc_width = 120 })
            local location = statusline.is_truncated(75) and "Ln %l│Col %v" or "Ln %l|Col %v"

            return statusline.combine_groups({
              { hl = mode_hl, strings = { mode } },
              { hl = "MiniStatuslineDevinfo", strings = { git, diagnostics } },
              { hl = "MiniStatuslineFileinfo", strings = { lsp } },
              "%<", -- Mark general truncate point
              -- { hl = "MiniStatuslineFilename", strings = { filename } },
              "%=", -- End left alignment
              { hl = "MiniStatuslineFileinfo", strings = { fileinfo } },
              { hl = mode_hl, strings = { location } },
            })
          end,
        },
      })

      minipairs.setup({})
      minigit.setup()
      minidiff.setup({
        view = {
          signs = { add = "▎", change = "▎", delete = "▎" },
        },
      })

      -- clue.setup({
      --   triggers = {
      --     { mode = "n", keys = "<Leader>" },
      --     { mode = "x", keys = "<Leader>" },
      --     { mode = "n", keys = "g" },
      --     { mode = "x", keys = "g" },
      --     { mode = "n", keys = "z" },
      --     { mode = "x", keys = "z" },
      --     { mode = "n", keys = "<C-w>" },
      --     { mode = "n", keys = '"' },
      --     { mode = "x", keys = '"' },
      --     { mode = "i", keys = "<C-r>" },
      --   },
      --   clues = {
      --     clue.gen_clues.builtin_completion(),
      --     clue.gen_clues.g(),
      --     clue.gen_clues.registers(),
      --     clue.gen_clues.windows(),
      --     clue.gen_clues.z(),
      --     { mode = "n", keys = "<Leader><Leader>", desc = "+source" },
      --     { mode = "n", keys = "<Leader>b", desc = "+buffers/breakpoints" },
      --     { mode = "n", keys = "<Leader>bc", desc = "+breakpoints clear" },
      --     { mode = "n", keys = "<Leader>c", desc = "+config/clipboard" },
      --     { mode = "n", keys = "<Leader>d", desc = "+debug" },
      --     { mode = "n", keys = "<Leader>f", desc = "+find" },
      --     { mode = "n", keys = "<Leader>g", desc = "+tools" },
      --     { mode = "n", keys = "<Leader>l", desc = "+lsp" },
      --     { mode = "n", keys = "<Leader>s", desc = "+sql" },
      --     { mode = "n", keys = "<Leader>t", desc = "+tabs" },
      --     { mode = "n", keys = "<Leader>y", desc = "+yank" },
      --     { mode = "x", keys = "<Leader>e", desc = "+execute" },
      --   },
      --   window = {
      --     delay = 200,
      --     config = { width = "auto" },
      --   },
      -- })
    end,
  },
}
