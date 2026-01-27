return {
  {
    "akinsho/toggleterm.nvim",
    version = "*",
    config = function()
      -- Track terminals and current terminal globally
      local terminals = {}
      local current_term = 1

      -- Function to build the tab bar string
      local function build_tabline()
        local tabs = {}
        for i = 1, 9 do
          if terminals[i] then
            if i == current_term then
              table.insert(tabs, "[" .. i .. "]")
            else
              table.insert(tabs, " " .. i .. " ")
            end
          end
        end
        if #tabs == 0 then
          return "[1]"
        end
        return table.concat(tabs, "")
      end

      -- Update winbar for all open terminal windows
      local function update_all_winbars()
        local tabline = build_tabline()
        for _, term in pairs(terminals) do
          if term:is_open() and term.window then
            pcall(vim.api.nvim_win_set_option, term.window, "winbar", tabline)
          end
        end
      end

      require("toggleterm").setup({
        size = function(term)
          if term.direction == "horizontal" then
            return 15
          elseif term.direction == "vertical" then
            return vim.o.columns * 0.4
          end
        end,
        open_mapping = nil,
        hide_numbers = true,
        shade_terminals = true,
        shading_factor = 2,
        start_in_insert = true,
        insert_mappings = true,
        persist_size = true,
        direction = "float",
        close_on_exit = true,
        shell = vim.o.shell,
        float_opts = {
          border = "none",
          width = function()
            return math.floor(vim.o.columns * 0.85)
          end,
          height = function()
            return math.floor(vim.o.lines * 0.8)
          end,
          winblend = 0,
        },
        winbar = {
          enabled = false, -- We'll manage winbar ourselves
        },
      })

      local Terminal = require("toggleterm.terminal").Terminal

      local function get_or_create_terminal(num)
        if not terminals[num] then
          terminals[num] = Terminal:new({
            count = num,
            direction = "float",
            on_open = function(term)
              vim.cmd("startinsert!")
              -- Set winbar with all tabs
              vim.defer_fn(function()
                update_all_winbars()
              end, 10)
              -- Set local keymaps for this terminal buffer
              local opts = { buffer = term.bufnr, noremap = true, silent = true }
              -- Navigate between terminal tabs
              vim.keymap.set("t", "<C-Tab>", function()
                term:close()
                local next_term = current_term
                -- Find next active terminal or create next one
                for i = 1, 9 do
                  local check = ((current_term - 1 + i) % 9) + 1
                  if terminals[check] then
                    next_term = check
                    break
                  end
                end
                if next_term == current_term then
                  next_term = (current_term % 9) + 1
                end
                current_term = next_term
                get_or_create_terminal(current_term):toggle()
              end, opts)
              vim.keymap.set("t", "<C-S-Tab>", function()
                term:close()
                local prev_term = current_term
                -- Find previous active terminal
                for i = 1, 9 do
                  local check = ((current_term - 2 - i + 9) % 9) + 1
                  if terminals[check] then
                    prev_term = check
                    break
                  end
                end
                if prev_term == current_term then
                  prev_term = current_term == 1 and 9 or current_term - 1
                end
                current_term = prev_term
                get_or_create_terminal(current_term):toggle()
              end, opts)
            end,
          })
        end
        return terminals[num]
      end

      -- Toggle current terminal
      local function toggle_terminal()
        get_or_create_terminal(current_term):toggle()
      end

      -- Toggle specific terminal by number
      local function toggle_terminal_num(num)
        if terminals[current_term] and terminals[current_term]:is_open() then
          terminals[current_term]:close()
        end
        current_term = num
        get_or_create_terminal(num):toggle()
      end

      -- Keymaps
      local opts = { noremap = true, silent = true }

      -- Main toggle: <leader>ot
      vim.keymap.set("n", "<leader>ot", toggle_terminal, vim.tbl_extend("force", opts, { desc = "Open floating terminal" }))

      -- Quick access to specific terminals: <leader>o1 through <leader>o9
      for i = 1, 9 do
        vim.keymap.set("n", "<leader>o" .. i, function()
          toggle_terminal_num(i)
        end, vim.tbl_extend("force", opts, { desc = "Toggle terminal " .. i }))
        vim.keymap.set("t", "<leader>o" .. i, function()
          toggle_terminal_num(i)
        end, vim.tbl_extend("force", opts, { desc = "Switch to terminal " .. i }))
      end

      -- Window navigation from terminal mode
      vim.keymap.set("t", "<C-h>", [[<C-\><C-n><C-w>h]], opts)
      vim.keymap.set("t", "<C-j>", [[<C-\><C-n><C-w>j]], opts)
      vim.keymap.set("t", "<C-k>", [[<C-\><C-n><C-w>k]], opts)
      vim.keymap.set("t", "<C-l>", [[<C-\><C-n><C-w>l]], opts)
    end,
  },
}
