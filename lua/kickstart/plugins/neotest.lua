-- neotest.lua
--
-- Test running: neotest + neotest-python (pytest). Run the suite or the nearest
-- test from inside nvim, get per-test pass/fail signs in the gutter, each
-- failure as a diagnostic at its line, and ]t / [t to jump between failures.
-- Keymap reference lives in CHEATSHEET.md ("Testing" section).

vim.pack.add {
  'https://github.com/nvim-neotest/nvim-nio', -- hard dependency of neotest
  'https://github.com/nvim-neotest/neotest',
  'https://github.com/nvim-neotest/neotest-python',
}

require('neotest').setup {
  adapters = {
    require 'neotest-python' {
      runner = 'pytest',
      -- Applies to the <leader>td dap strategy: don't skip library frames.
      dap = { justMyCode = false },
    },
  },
}

local neotest = require 'neotest'
vim.keymap.set('n', '<leader>tn', function() neotest.run.run() end, { desc = '[T]est [N]earest' })
vim.keymap.set('n', '<leader>tf', function() neotest.run.run(vim.fn.expand '%') end, { desc = '[T]est current [F]ile' })
vim.keymap.set('n', '<leader>ta', function() neotest.run.run { suite = true } end, { desc = '[T]est [A]ll (whole suite)' })
vim.keymap.set('n', '<leader>tl', function() neotest.run.run_last() end, { desc = '[T]est: rerun [L]ast' })
-- Debug the nearest test through nvim-dap; same UI as <leader>dt.
vim.keymap.set('n', '<leader>td', function() neotest.run.run { strategy = 'dap' } end, { desc = '[T]est [D]ebug nearest' })
-- Overrides the stock ]t/[t tag-jump defaults, which nothing here uses.
vim.keymap.set('n', ']t', function() neotest.jump.next { status = 'failed' } end, { desc = 'Next failed test' })
vim.keymap.set('n', '[t', function() neotest.jump.prev { status = 'failed' } end, { desc = 'Prev failed test' })
vim.keymap.set('n', '<leader>ts', function() neotest.summary.toggle() end, { desc = '[T]est [S]ummary tree' })
vim.keymap.set('n', '<leader>to', function() neotest.output_panel.toggle() end, { desc = '[T]est [O]utput panel' })
vim.keymap.set('n', '<leader>tO', function() neotest.output.open { enter = true, auto_close = true } end, { desc = '[T]est [O]utput for nearest' })
