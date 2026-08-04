# Config cleanup backlog

Open items from the config review. Ordered roughly by payoff. Work through one at a time.

mini.clue is set up in `plugins/mini.lua` (`<Leader>`, `g`, `z`, `<C-w>`, `"`, insert
`<C-r>`) with `timeoutlen = 400`. It is on trial — if it goes, keep the lowered
`timeoutlen`.

Still eager by necessity, not oversight: overseer (nvim-dap's `config` calls
`require("overseer").enable_dap()`), mini.nvim (statusline + clue), mason-lspconfig,
persistent-breakpoints (`BufReadPost`, so saved breakpoints load with the file),
indent-blankline.

## 1. `plugins/mini.lua`

- `local pairs = require("mini.pairs")` shadows Lua's builtin `pairs`. Harmless as written
  since nothing iterates afterward, but a trap.
- The LSP statusline section is an immediately-invoked anonymous function,
  `(function() ... end)()` — the most opaque construct in the config. A named
  `local function lsp_section()` above the `active` callback says the same thing readably.

## 2. `utils/public/os.lua`

A directory named `public` implies a private counterpart that does not exist. It holds one
file with one line: `vim.fn.has("win32") == 1`. Three files require it. Flatten to
`utils/os.lua`.

## 3. The overseer template is invisible magic

`lua/overseer/template/vscode_tasks.lua` works only because overseer scans every
`lua/overseer/template/` directory on the runtimepath. Nothing outside that file hints at
it; its header comment says what it does but not why the path matters.

It is also one of two files named `vscode_tasks` — `utils/vscode_tasks.lua` is 38 lines
used by nothing else, so one feature is split across two identically-named files in
different trees.

## 4. Smaller things

- The reapply-highlights-on-`ColorScheme` pattern appears twice with the same shape, in
  `options.lua` (`set_ui_highlights`) and `plugins/dap.lua` (`set_dap_highlights`).

## 5. Update README

The read me doesn't list nicely all the prerequisites that need to be downloaded such as
`unzip`, and I'm sure there are others.
Also, the readme needs to be made much nicer than it is right now.
