-- GitHub Copilot as a blink.cmp completion source (reuses the existing Copilot
-- subscription -- see dotfiles issue #103, docs/research/ai-completion-options.md).
--
-- copilot.lua ships and starts Copilot's language server; blink-copilot adapts
-- that server into a blink source. Copilot's own inline suggestion and panel
-- UIs are OFF so blink owns completion: suggestions arrive in the normal menu
-- next to LSP and snippet items, accepted with the same <Tab>/<CR>.
--
-- Requires NodeJS >= 22 for the bundled Copilot LSP.
-- One-time per machine: :Copilot auth   (:Copilot auth info to check).
--
-- The copilot provider itself is registered in the blink.cmp setup in init.lua
-- (SECTION 8): blink.cmp.setup() ignores a second call, so a source cannot be
-- added from here, which loads later.

vim.pack.add {
  'https://github.com/zbirenbaum/copilot.lua',
  'https://github.com/fang2hou/blink-copilot', -- blink.cmp source, backed by copilot.lua
}

require('copilot').setup {
  suggestion = { enabled = false }, -- no copilot ghost text; blink draws the items
  panel = { enabled = false },
}
