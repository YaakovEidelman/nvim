# Config cleanup backlog

Open items from the config review. Ordered roughly by payoff. Work through one at a time.

## 1. Keymaps are scattered across 8 files

Bindings currently live in `keymaps.lua`, `plugins/telescope.lua`, `plugins/dap.lua`,
`plugins/nvim-dadbod.lua`, `plugins/persistent-breakpoints.lua`, `utils/multigrep.lua`,
`plugins/codediff.lua` (via plugin opts), and `autocmd.lua` (netrw buffer-local maps).

There is no single file that answers "what is `<leader>d` bound to". That is the main
source of feeling locked out of the config.

Two coherent options, pick one and apply it everywhere:

- **Everything in `keymaps.lua`** (split into `keymaps/` files later if it outgrows one
  file). Easy to find, but a mapping can fire before its plugin is loaded, so each one
  needs a `require` inside a closure.
- **lazy.nvim `keys = { ... }` per plugin spec.** The binding lives next to the plugin it
  drives, and lazy.nvim loads the plugin on first press. Costs discoverability unless
  paired with a `:Telescope keymaps` habit.

Recommendation: `keys =` for plugin-owned mappings, `keymaps.lua` for everything that
belongs to core Neovim (window nav, line moves, save/quit, netrw). That also solves item 2
for free.

## 2. Almost nothing lazy-loads

Loaded eagerly on every startup: telescope, nvim-dap, nvim-dap-ui, overseer,
persistent-breakpoints, mini.nvim, indent-blankline, mason-lspconfig.
Only conform (`VeryLazy`), lazydev (`ft`), codediff (`cmd`) and dadbod-ui (`cmd`) have
triggers.

Moving plugin mappings into `keys =` (item 1) converts most of these to on-demand without
adding a line of config.

## 3. `vim-dadbod` never runs its `config` — `<leader>eq` is dead

`plugins/nvim-dadbod.lua` declares vim-dadbod as `lazy = true` with no `event`, `cmd`,
`keys` or `ft`. Nothing triggers it, so its `config` function (which sets the visual-mode
`<leader>eq` "execute selection") never runs until something else pulls dadbod in —
in practice, opening `:DBUI`. So the mapping silently does not exist on a fresh session.

Fix: move that mapping into the dadbod-ui `init` next to the other two, or make it a
`keys` entry.

## 4. `lsp_config.lua` — ~40 lines are copies of lspconfig defaults

Verified against nvim-lspconfig's shipped configs: the `filetypes` lists for `ts_ls`,
`pyright`, `lua_ls`, `rust_analyzer`, `html` and `cssls` are byte-identical to the
defaults. Deleting them makes the `clangd` and `rust_analyzer` blocks empty, so those
disappear entirely.

Two caveats before deleting:

- `clangd`'s filetypes are **not** the default — the config narrows it to `c`/`cpp`,
  dropping `objc`, `objcpp`, `cuda` and the `.doxygen` variants. Decide if that was
  deliberate.
- `lua_ls`'s `diagnostics.globals = { "vim" }` is redundant now that lazydev is installed.

What survives is only real intent: pyright venv settings, html `provideFormatter = false`,
cssls `emptyRules`, postgres cmd, roslyn inlay hints.

## 5. LSP config is split across three files

`lsp/servers.lua` holds the server names, `lsp_config.lua` holds their settings,
`plugins/mason.lua` re-requires the names for `ensure_installed`. Adding a server is a
two-file edit.

One table keyed by server name (`{ pyright = {...}, cssls = {...} }`) gives
`ensure_installed = vim.tbl_keys(servers)`, a loop calling `vim.lsp.config`, and
`vim.lsp.enable(vim.tbl_keys(servers))` from one place.

Clearest symptom of the current split: roslyn's settings sit in `lsp_config.lua` while
roslyn is commented out of `servers.lua` and actually enabled by roslyn.nvim. Those
settings belong in `plugins/roslyn.lua`.

## 6. Abstractions that cost more than they save

- `plugins/dap.lua`: the `keymaps` table of `{ mode, lhs, rhs, desc }` records plus the
  `for` loop is more machinery than the 12 plain `vim.keymap.set` calls it replaces, and
  it is a schema you have to decode before adding a binding.
- `plugins/telescope.lua`: wrappers like `function() builtin.find_files() end` are just
  `builtin.find_files`. Only `<leader>ff` and `<leader>fF` need a closure (they pass opts).

## 7. Dead code that looks alive

- `plugins/nvim-dap-ui.lua` registers three dap listeners whose bodies are entirely
  commented out — it installs three no-ops.
- `plugins/conform.lua`: `format_on_save = function() return nil end` is exactly
  equivalent to omitting the key.
- `plugins/indent-blankline.lua` sets `main = "ibl"` and `opts = {}`, then a `config`
  function that ignores both. `scope.enabled = true` is already ibl's default, so the file
  collapses to just the plugin name.
- `plugins/telescope.lua`: `extensions = { fzf = {} }` is a no-op.

(`plugins/fugitive.lua` was in this group and has been deleted.)

## 8. `plugins/mini.lua`

- `local pairs = require("mini.pairs")` shadows Lua's builtin `pairs`. Harmless as written
  since nothing iterates afterward, but a trap.
- The LSP statusline section is an immediately-invoked anonymous function,
  `(function() ... end)()` — the most opaque construct in the config. A named
  `local function lsp_section()` above the `active` callback says the same thing readably.

## 9. `utils/public/os.lua`

A directory named `public` implies a private counterpart that does not exist. It holds one
file with one line: `vim.fn.has("win32") == 1`. Three files require it. Flatten to
`utils/os.lua`.

## 10. The overseer template is invisible magic

`lua/overseer/template/vscode_tasks.lua` works only because overseer scans every
`lua/overseer/template/` directory on the runtimepath. Nothing outside that file hints at
it; its header comment says what it does but not why the path matters.

It is also one of two files named `vscode_tasks` — `utils/vscode_tasks.lua` is 38 lines
used by nothing else, so one feature is split across two identically-named files in
different trees.

## 11. Smaller things

- The reapply-highlights-on-`ColorScheme` pattern appears twice with the same shape, in
  `options.lua` (`set_ui_highlights`) and `plugins/dap.lua` (`set_dap_highlights`).
- `keymaps.lua` reads raggedly because stylua at `column_width = 100` explodes some
  `vim.keymap.set` calls across six lines while their neighbours fit on one. A small local
  `map(mode, lhs, rhs, desc)` helper would keep the file scannable as what it is: a table
  of bindings.

