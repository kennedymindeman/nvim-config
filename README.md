# nvim-config

Personal neovim config, grown from [kickstart.nvim](https://github.com/nvim-lua/kickstart.nvim).
Single-file config (`init.lua`), plugins managed by neovim's built-in `vim.pack`.

See [CHEATSHEET.md](CHEATSHEET.md) for the editing patterns worth practicing.

## What's configured

- **LSP** (via mason, auto-installed): basedpyright + ruff (Python), clangd (C/C++), lua_ls (Lua)
- **Format on save**: ruff for Python, stylua for Lua. C/C++ only formats if the
  project has a `.clang-format` file
- **Search**: telescope (`<space>sf` files, `<space>sg` project grep)
- **Files**: oil.nvim (`-` opens the directory as an editable buffer)
- **Debugging**: nvim-dap + dap-view for Python (debugpy); `<space>b` breakpoint,
  `<F5>` run (reads `.vscode/launch.json`), `<space>dt` debug nearest test —
  full keymap table in the cheatsheet's "Debugging" section
- **Splits/panes**: `<C-hjkl>` moves across nvim splits *and* tmux panes
  (vim-tmux-navigator; tmux side lives in the dotfiles repo)
- **Buffers auto-reload** when files change on disk (Claude Code edits show up on focus)

## Setup on a new machine (macOS)

```sh
brew install neovim ripgrep fd tree-sitter-cli
git clone git@github.com:kennedymindeman/nvim-config.git ~/.config/nvim
nvim --headless "+qa"                          # installs plugins
nvim --headless "+MasonToolsInstallSync" "+qa" # installs LSP servers
python3 -m pip install --user debugpy pytest   # debugger adapter + test runner (not mason-managed)
nvim                                           # done
```

Requires a terminal with Nerd Font glyphs (Ghostty has them built in) and a C
compiler for treesitter parsers (`xcode-select --install`).

The colorscheme is `catppuccin-mocha`; the rest of the terminal matches by
setting the same theme in Ghostty's config (not part of this repo):

```ini
# ~/Library/Application Support/com.mitchellh.ghostty/config
theme = Catppuccin Mocha
```

(helix pairs via `theme = "catppuccin_mocha"` in ~/.config/helix/config.toml)

## Setup on Windows

Config path is `~/AppData/Local/nvim` (i.e. `%LOCALAPPDATA%\nvim`).

```powershell
scoop install neovim ripgrep fd tree-sitter          # or winget
git clone https://github.com/kennedymindeman/nvim-config.git $env:LOCALAPPDATA\nvim
nvim --headless "+qa"                                 # installs plugins
nvim --headless "+MasonToolsInstallSync" "+qa"        # installs LSP servers
nvim                                                  # done
```

Windows-specific gotchas (all learned the hard way):

- **tree-sitter CLI is mandatory, not optional.** This config tracks
  nvim-treesitter's `main` branch, which shells out to the `tree-sitter`
  binary to compile parsers. Without it on `PATH` you get
  `ENOENT: 'tree-sitter'`. `scoop install tree-sitter` puts a shim on the
  persistent user PATH so the GUI nvim sees it.
- **C compiler = MSVC.** Parsers compile via the Visual Studio 2022 C++
  toolchain (the tree-sitter build auto-detects MSVC). Install the
  "Desktop development with C++" workload. Zig also works if you prefer.
- **Nerd Font terminal** required for glyphs (Windows Terminal + a Nerd
  Font, or Ghostty). Colorscheme is `catppuccin-mocha`.

### clangd for a C/C++ project

clangd needs a compilation database. For a CMake project, generate one and
drop a `.clangd` next to it pointing at the build dir:

```powershell
cmake -S . -B out\build\clangd -G Ninja -DCMAKE_EXPORT_COMPILE_COMMANDS=ON
```

```yaml
# .clangd  (at the project root; keep it out of version control)
CompileFlags:
  CompilationDatabase: out/build/clangd
```

`CMAKE_EXPORT_COMPILE_COMMANDS` only emits `compile_commands.json` with the
**Ninja** or Makefile generators, not the Visual Studio generator. Generated
headers (protobuf, etc.) must be built at least once or clangd reports them as
missing. clangd's semantic-token highlighting is disabled in `init.lua` so
tree-sitter owns colors; clangd still does diagnostics, navigation, and
unused-include / deprecation warnings.

### Perforce auto-checkout

Opening a read-only file and editing it fires a `FileChangedRO` autocmd that
runs `p4 edit` and clears the readonly flag. Requires the `p4` CLI on PATH.
For multi-workspace setups, `p4 set P4CONFIG=.p4config` and a `.p4config`
(`P4CLIENT=<client>`) at each workspace root lets p4 pick the right client by
directory.

## Pulling kickstart updates

Upstream is kept as a remote:

```sh
git fetch upstream
git merge upstream/master
```
