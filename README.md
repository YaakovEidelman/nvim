# nvim config

Install the system packages for your OS, clone this repo, start `nvim`.

Clone to `%LOCALAPPDATA%\nvim` on Windows, `~/.config/nvim` on Linux.

There are scripts in `scripts/` that run these installs for you — `windows.ps1`
(winget) and `arch.sh` (pacman). Both install the core list only; pass
`-Optional` / `--optional` to get the extras too. Other distros: read the Linux
list and use your own package manager.

Nothing installs at startup. Language servers, formatters and debug adapters are
pulled from Mason the first time you open a file of that language, so a fresh
machine only needs the core list below. The per-language toolchains — node,
python, dotnet — are only needed once you actually open that kind of file.

## Core (Windows)

- Neovim 0.12+ — `winget install Neovim.Neovim`
- Git — `winget install Git.Git`
- MSVC C/C++ compiler — `winget install Microsoft.VisualStudio.2022.BuildTools -e --override "--quiet --wait --add Microsoft.VisualStudio.Workload.VCTools --includeRecommended"`
- CMake — `winget install Kitware.CMake`
- ripgrep — `winget install BurntSushi.ripgrep.MSVC`
- A Nerd Font — `winget install DEVCOM.JetBrainsMonoNerdFont`, then set it in your terminal
- `curl`, `tar`, PowerShell 5.1 — already in Windows 10/11, nothing to do
- tree-sitter CLI — no good winget package, get it from Mason: `:MasonInstall tree-sitter-cli`

The compiler and the tree-sitter CLI are not optional. Treesitter installs a
parser the first time you open any file type it doesn't have yet, and it does
that by shelling out to `tree-sitter` and compiling C. Without both you get no
highlighting and a red error.

Optional:

- `fd` — faster Telescope `find_files` — `winget install sharkdp.fd`
- VS Code — `<leader>gd` opens the cwd in it — `winget install Microsoft.VisualStudioCode`

## Core (Arch)

```
sudo pacman -S --needed neovim git gcc make cmake ripgrep unzip \
  tree-sitter-cli ttf-jetbrains-mono-nerd wl-clipboard
```

- `neovim` must be 0.12+. If the repo version is older, use `neovim-git` from the AUR.
- `gcc` and `make` come with `base-devel` if you already have it. Only those two
  matter here — gcc compiles treesitter parsers, and gcc plus `cmake` build
  telescope-fzf-native.
- `unzip` is how Mason unpacks stylua and codelldb. It is not in `base` and
  nothing pulls it in, so it is usually the one that's missing.
- Mason also needs `curl`, `tar` and `gzip`, but `tar` and `gzip` ship in `base`
  and `curl` is a dependency of pacman itself, so on Arch they are already there.
  On a minimal non-Arch system, install them.
- `wl-clipboard` is for Wayland — use `xclip` on X11. `clipboard = "unnamedplus"`
  in `lua/options.lua` silently does nothing without one of them.

Optional:

- `fd` — faster Telescope `find_files`
- `postgresql` / `mariadb-clients` — dadbod DBUI needs the client CLI of whatever
  database you connect to

## Per-language toolchains

Mason installs most tools as self-contained binaries, but some come from npm,
PyPI or NuGet and need that runtime present. You only need a row once you open
that kind of file.

| Language   | Needs           | Why                                              |
| ---------- | --------------- | ------------------------------------------------ |
| lua        | —               | lua-language-server and stylua are binaries      |
| typescript | node            | typescript-language-server, prettier             |
| html / css | node            | html-lsp, css-lsp, prettier                      |
| json       | node            | prettier                                         |
| python     | node and python | pyright is npm; black and debugpy are PyPI       |
| c / cpp    | python          | clang-format is PyPI; clangd and codelldb aren't |
| rust       | rustup          | for `rustfmt` — rust-analyzer comes from Mason   |
| c#         | dotnet          | csharpier is NuGet, and Roslyn needs the runtime |
| sh         | —               | shfmt is a binary                                |
| sql        | —               | postgres-language-server is a binary             |

Windows: `winget install OpenJS.NodeJS.LTS`, `Python.Python.3.13`,
`Microsoft.DotNet.SDK.9`, `Rustlang.Rustup`.

Arch: `sudo pacman -S nodejs npm python python-pip dotnet-sdk rustup`.

Note that `pyright` is an npm package, so Python work needs node too. Roslyn is
skipped entirely when `dotnet` isn't on PATH, so a machine without the .NET SDK
never downloads it.

## Languages

Everything language-specific lives in `lua/lang/`, one file per language. Each
file declares its treesitter parsers, LSP servers and settings, formatters,
debug adapter and Mason packages. `lua/lang/init.lua` merges them and the
plugins read from it — `lsp_config.lua` takes the servers, `conform.lua` the
formatters, `dap.lua` the adapters, and the autocmd in `lua/autocmd.lua`
installs the Mason packages on first use.

To add a language, drop in a new file. To remove one, delete its file — the
server, formatter, adapter and installs all go with it. Nothing else to edit.

```lua
-- lua/lang/go.lua
return {
  filetypes = { "go" },
  parsers = { "go" },
  servers = { gopls = {} },
  formatters = { go = { "gofmt" } },
  mason = { "gopls" },
}
```

Refer to Mason binaries by bare name — `command = "codelldb"`, not a path. Mason
puts its bin directory on PATH and the loader expands the name per OS.

C# is the one exception: its server is the separate `roslyn.nvim` plugin, so
`lua/lang/csharp.lua` carries the formatter, adapter and packages while
`lua/plugins/roslyn.lua` carries the server.

## First boot

1. Clone this repo into the config path above.
2. Start `nvim` — lazy.nvim bootstraps itself and installs plugins.
3. `:Lazy restore` to pin everything to the committed `lazy-lock.json`.
4. On Windows only: `:MasonInstall tree-sitter-cli`. Arch gets it from pacman.
5. `:checkhealth` and fix anything red.

After that, just open a file. The first time you open a language, Mason installs
its tools and reports what it's fetching; the server attaches when that finishes.
`:Mason` shows everything installed, and `:LspInstall` with no arguments lists
the servers available for the current file if you want a different one.

## Troubleshooting

**telescope-fzf-native.** It's optional. If the toolchain is missing, Telescope
falls back to its built-in Lua sorter and shows a one-time notification. After
installing CMake and a compiler, run `:Lazy build telescope-fzf-native.nvim`.

**`cannot open output file libfzf.dll: Permission denied` on Windows.** That's a
file lock, not a toolchain problem — once nvim has loaded the fzf extension it
holds `build/libfzf.dll` open and the linker can't overwrite it. Close all
Neovim instances and build from a terminal:

```
cd /c/Users/yeide/AppData/Local/nvim-data/lazy/telescope-fzf-native.nvim
rm -rf build
cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release
cmake --build build --config Release
cmake --install build --prefix build
```

If it still fails with nvim closed, check for stray processes (`Get-Process nvim`)
or antivirus briefly locking the new `.dll`.
