# Cheatsheet

The stuff that used to need extensions or multicursor in VS Code, done the vim way.
Leader is `<space>`. When lost, press `<space>` and wait — which-key shows what's available.
Run `:Tutor` once if you haven't.

## Bulk edits: changing many similar lines

### The interactive way: `*` + `cgn` + `.` (your Ctrl+D replacement)

Change some-but-not-all occurrences of a word, deciding match-by-match:

1. Put cursor on the word, press `*` — searches for it as a whole word
2. `cgn` — deletes the next match and drops you in insert mode
3. Type the replacement, press `<Esc>`
4. Now: `.` repeats the change on the next match, `n` skips a match

No plugin, no cursors to manage, works with any search (`/foo<Enter>` then `cgn` works too).

### The declarative way: `:s` (change all of them at once)

Anatomy — four slots:

```
:%s/pattern/replacement/g
 │ │        │           └ flags: g = all matches per line, c = confirm each
 │ │        └ what to put there instead
 │ └ what to find (regex)
 └ range: % = whole file, nothing = current line, '<,'> = visual selection
```

**You have live preview**: as you type the command, matches highlight and a
split shows exactly what each line becomes — *before* you press Enter. If the
preview looks wrong, fix the pattern. You are never firing blind.

Worked examples:

```vim
:%s/foo/bar/g                " every foo → bar, whole file
:'<,'>s/foo/bar/g            " only in the visual selection (select lines with V first)
:%s/foo/bar/gc               " ask y/n at each match
:%s/\vuser_(\w+)/account_\1/g " user_name → account_name, user_id → account_id
```

That last one: `\v` means "very magic" (sane regex, no backslash soup),
`(...)` captures, `\1` pastes the capture into the replacement.

Undo the entire substitution with one `u`.

### The surgical way: `:g` (run any command on matching lines)

`:g/pattern/command` runs a command on every line matching the pattern:

```vim
:g/console\.log/d            " delete every line containing console.log
:g/^#/normal >>              " indent every comment line
:g/TODO/t$                   " copy every TODO line to the end of the file
:v/keep/d                    " :v is inverse — delete every line NOT matching
```

`:g` + `normal` means "replay these keystrokes on each matching line" — it
turns anything you know how to do once into a bulk operation.

### Macros (when the edit is too weird for a pattern)

1. `qa` — start recording into register `a`
2. Do the edit on one line, end with `j` (move to next line) so it chains
3. `q` — stop recording
4. `@a` replays it once; `10@a` replays 10 times; `@@` repeats the last replay

Bonus: select lines visually, then `:'<,'>normal @a` runs the macro on every selected line.

## Project search (telescope = your command palette)

| Keys | Does |
|---|---|
| `<space>sf` | find files by fuzzy name |
| `<space>sg` | live grep — search text across the whole project (rg) |
| `<space>sw` | grep the word under the cursor |
| `<space><space>` | switch between open buffers |
| `<space>/` | fuzzy search within the current file |
| `<space>sh` | search neovim help |
| `<space>sk` | search keymaps (forgot a binding? look it up) |
| `<space>sr` | reopen the last search where you left off |

Inside a picker: `<C-n>`/`<C-p>` move, `<Enter>` opens, `<Esc><Esc>` closes,
`<C-/>` shows all picker keymaps.

## Files (oil)

`-` opens the current directory as a text buffer. Rename = edit the line.
Delete = `dd`. New file = open a line, type a name (`dir/` for a directory).
`:w` applies everything. `-` again goes up a directory.

## LSP (attached automatically for Python, C/C++, Lua)

| Keys | Does |
|---|---|
| `grd` | go to definition (`<C-t>` to jump back) |
| `grr` | find references |
| `grn` | rename symbol across the project |
| `gra` | code action (e.g. "remove unused import") |
| `K` | hover docs |
| `[d` / `]d` | previous / next diagnostic |
| `<space>q` | all diagnostics in a list |
| `<space>f` | format buffer manually (Python/Lua also format on save) |

## Debugging (DAP + dap-view)

The loop: set a breakpoint, `<F5>`, pick a config, read state, step. A repo with
`.vscode/launch.json` gets its configs offered automatically on `<F5>`.

| Keys | Does |
|---|---|
| `<space>b` | toggle breakpoint on current line (`<space>B` for a conditional one) |
| `<F5>` | start (pick a config) / continue to next breakpoint |
| `<space>dt` | debug the test function nearest the cursor (via pytest) |
| `<F2>` / `<F1>` / `<F3>` | step over / into / out |
| `<space>de` | eval variable under cursor (or visual selection) in a float |
| `<space>ds` / `df` / `dw` / `dr` / `dc` | jump to Scopes / call stack / Watches / REPL / Console |
| `<F7>` | toggle the panel (e.g. to read output after a crash) |
| `<space>dq` | terminate the session |

While paused, variable values also appear inline as virtual text at the end of
each line — often you never need the panel at all.

In the panel (it's one window with tabs): press the winbar letters `W S E B T R C`
to switch sections, `g?` for that section's keymaps. The essentials: in **Watches**,
`i` inserts a new expression (re-evaluated on every step); in the **REPL**, `i` then
type any expression valid in the paused frame; in **Threads**, `<CR>` on a frame
jumps there so Scopes shows *that* frame's variables. The panel is a normal window —
`<C-w>_` maximizes it, `<C-w>=` re-equalizes.

## Odds and ends worth knowing early

- `ciw` / `ci(` / `ci"` — change inside word / parens / quotes (mini.ai makes these smart)
- `saiw)` — surround a word with parens; `sd"` deletes surrounding quotes
- `<C-h/j/k/l>` — move between splits
- `u` undo, `<C-r>` redo — undo history survives closing the file (undofile is on)
- `:checkhealth` — first stop when something seems broken
