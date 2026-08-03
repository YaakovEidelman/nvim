# Keymap migration

Moving plugin-owned bindings into lazy.nvim `keys = { ... }` specs, one plugin at a time.
This is item 1 (and most of item 2) from `TODO.md`.

## Why this works

`keys =` does not defer the mapping. lazy.nvim creates a real mapping at startup — a stub
that loads the plugin, deletes itself and replays the keystroke — and copies your `desc`
onto that stub (`lazy/core/handler/keys.lua:142`). So the binding is visible to
`:Telescope keymaps`, `:map`, `:verbose map` and any hint popup from the first millisecond
of a session, even though the plugin has not loaded.

Locality and discoverability are therefore not in tension. The thing that makes bindings
findable is `desc`, not file layout.

## Rules

1. Plugin-owned bindings go in that plugin's `keys =` spec. Core-Neovim bindings stay in
   `keymaps.lua`.
2. **Every mapping gets a `desc`.** No exceptions. A mapping without one is invisible in
   every lookup, which is the actual reason the config feels hard to navigate.
3. Descriptions are prefixed with their group: `Find: files`, `Debug: step over`,
   `DB: toggle UI`. Then fuzzy-searching the group name returns the whole family
   regardless of which file each binding lives in.
4. A `utils/` module exposes a function and never binds a key. The spec does the binding.
5. Add `cmd = "..."` alongside `keys` when the plugin has user commands, so typing the
   command directly still loads it.

## Exceptions — leave these where they are

- **netrw maps** (`autocmd.lua`): buffer-local, and must be applied after netrw sets its
  own maps inside `NetrwMaps()`. The scheduled `FileType` autocmd is correct.
- **codediff in-view maps** (`plugins/codediff.lua` opts): buffer-local to a diff tab, the
  plugin owns their lifecycle.
- Plugins deliberately set `lazy = false` (roslyn, treesitter) gain no loading benefit, but
  their bindings still belong in the spec for locality.

## Remaining

- [x] **conform** — `<M-F>` moved to a `keys` entry on the conform spec with
      `desc = "Format: buffer"`. `event = "VeryLazy"` is gone; the spec now loads on that key
      or on `:ConformInfo`.

- **overseer** — deliberately left with no bindings. It is only ever used indirectly, through
  nvim-dap's `require("overseer").enable_dap()` and the `vscode_tasks` template, so a
  user-facing binding would be noise. It stays eagerly loadable for that reason: do **not**
  give it a `cmd`/`keys` trigger, because nvim-dap's `config` needs it loaded at that point.

## Done: `keymaps.lua` backfill

`keymaps.lua` now holds only core bindings, all of them described, behind a local
`map(mode, lhs, rhs, desc, opts)` helper (item 11 from `TODO.md`). Groups in use there:
`Window:`, `Edit:`, `File:`, `Buffer:`, `Tab:`, `Jump:`, `Lua:`, `Config:`, `Clipboard:`,
`Terminal:`, `Tool:`, `LSP:`. Plugin specs own `Find:`, `Debug:`, `DB:` and `Format:`.

Verification: every `<leader>` mapping in normal mode reports a non-empty `desc` from
`nvim_get_keymap("n")`.

Fixed while passing through: `plugins/persistent-breakpoints.lua` bound both breakpoint keys
to `pb.toggle_breakpoint()` / `pb.clear_all_breakpoints()`, but `pb` was a local inside
`config` and not visible in the `keys` closures — both keys errored on press. They now call
`require("persistent-breakpoints.api")` directly.

## Open decisions

- **dap-ui auto-open is now load-gated.** nvim-dap-ui loads only on `<leader>dt`. The three
  `dap.listeners` in its config have commented-out bodies, so nothing auto-opens today and
  this is fine. But if you ever uncomment `dapui.open()` in `event_initialized`, it will not
  fire — dap-ui won't be loaded when a session starts. To get auto-open back, dap-ui needs
  to load with dap (move the listeners into nvim-dap's `config`, or drop the `keys` trigger).



- **mini.clue — added, on trial.** Set up in `plugins/mini.lua`; `vim.opt.timeoutlen = 400`
  in `options.lua` and `window.delay = 200`. Triggers: `<Leader>` (n/x), `g`, `z`, `<C-w>`,
  `"`, and `<C-r>` in insert. Prefix groups are named (`+debug`, `+find`, `+lsp`, …) and the
  built-in clue generators fill in registers/windows/`z`/`g`. Keep or drop after living with
  it; if it goes, `timeoutlen = 400` is worth keeping anyway.

- **`<leader>b` collision — not a real problem.** codediff binds `<leader>b` to toggle its
  explorer, which shadows the global `<leader>b*` maps inside a diff tab. Breakpoints are
  never set from inside codediff, so the stall never actually happens. No rebinding needed.
