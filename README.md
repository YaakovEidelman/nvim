# nvim config

This file lists everything a new machine needs
for this config will work properly.

## Prerequisites

### Core (required for everything)

| Tool | Why | Windows install |
|------|-----|-----------------|
| **Neovim 0.12+** | Config uses the native `vim.lsp.config` / `vim.lsp.enable` API | `winget install Neovim.Neovim` |
| **Git** | lazy.nvim bootstrap, plugin installs, mini.git | `winget install Git.Git` |
| **A C compiler** | Compiling treesitter parsers | MSVC Build Tools (`winget install Microsoft.VisualStudio.2022.BuildTools` + "Desktop development with C++") or `winget install zig.zig` |
| **Node.js + npm** | ts_ls, pyright, html/cssls, prettier (all installed through Mason via npm), tree-sitter CLI | `winget install OpenJS.NodeJS.LTS` |
| **tree-sitter CLI** | Required by nvim-treesitter (main branch) to build/install parsers | `npm install -g tree-sitter-cli` |
| **ripgrep** | Telescope live_grep and the custom multigrep picker | `winget install BurntSushi.ripgrep.MSVC` |
| **curl** | Parser/tool downloads | Ships with Windows 10+ |
| **A Nerd Font** | Statusline/tabline/DBUI icons | e.g. `winget install DEVCOM.JetBrainsMonoNerdFont`, then set it in your terminal |

### Language toolchains (install the ones you use)

| Tool | Why |
|------|-----|
| **Python 3** (with `pip` and `venv`) | pyright targets, debugpy, black/ruff installs |
| **.NET SDK** | Roslyn LSP (C#), csharpier, running/debugging C# with netcoredbg |
| **Rust (rustup)** | rustfmt; rust_analyzer binary itself comes from Mason |

### Build tools for plugins

`telescope-fzf-native` is an optional native fuzzy matcher. Its build command is
chosen automatically per OS, and it's fully optional — if the toolchain is
missing, Telescope falls back to its built-in Lua sorter and shows a one-time,
non-blocking notification telling you what to install for the faster matcher.

| OS | Build needs |
|------|-----|
| **Windows** | CMake + a C compiler (MSVC Build Tools). Build runs `cmake ... --build ... --install ...`. |
| **Linux / macOS** | `make` + a C compiler (gcc/clang). |

After installing the toolchain, run `:Lazy build telescope-fzf-native.nvim` to
compile it.

**Windows rebuild gotcha.** The first build (fresh install, before Telescope
loads) works from inside Neovim. But once nvim has loaded the fzf extension it
holds `build/libfzf.dll` open, and Windows won't let the linker overwrite a
loaded DLL — so a later `:Lazy build` fails with
`cannot open output file libfzf.dll: Permission denied`. That's a file lock, not
a toolchain problem. To rebuild: **close all Neovim instances**, then run it from
a terminal (e.g. msys2, which already has `make`/`cmake`):

```
cd /c/Users/yeide/AppData/Local/nvim-data/lazy/telescope-fzf-native.nvim
rm -rf build
cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release
cmake --build build --config Release
cmake --install build --prefix build
```

If it still fails with a fresh nvim closed, check for stray processes
(`Get-Process nvim`) or antivirus briefly locking the new `.dll`.

### Optional

| Tool | Why |
|------|-----|
| **fd** | Faster Telescope `find_files` (`winget install sharkdp.fd`) |
| **VS Code** (`code` on PATH) | `<leader>gd` opens the current folder in VS Code |

## First boot on a new machine

1. Clone this repo to `~/AppData/Local/nvim` (Windows) or `~/.config/nvim` (Linux/macOS).
2. Start `nvim` — lazy.nvim bootstraps itself and installs plugins.
3. Run `:Lazy restore` to pin all plugins to the committed `lazy-lock.json`.
4. Install the non-LSP tools by hand. mason.nvim does **not** auto-install these
   (only LSP servers, via mason-lspconfig, install automatically). Run:

   ```
   :MasonInstall black prettier stylua clang-format shfmt csharpier debugpy codelldb netcoredbg postgres-language-server
   ```

   - Formatters: `black`, `prettier`, `stylua`, `clang-format`, `shfmt`, `csharpier`
   - Debug adapters: `debugpy`, `codelldb`, `netcoredbg`
   - Other: `postgres-language-server`
5. Run `:checkhealth` and fix anything red.

