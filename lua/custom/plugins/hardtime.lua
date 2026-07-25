-- hardtime.nvim — enforces better motions. BLOCK mode: when you hammer j/k/h/l
-- past the limit or reach for an arrow key, the keypress is REFUSED and it
-- names the better motion. The real-time enforcer half of measure-then-stop;
-- the keylog + `vimstats` measure, this one stops you.
--
-- Blocks: >3 repeats of h/j/k/l (also +, gj/gk, <C-N/P/M>) within 1s; arrow
-- keys in normal and insert mode. Pattern hints (dwi->cw, $a->A, Vjjd->d2j, …)
-- still surface as suggestions. Mouse left ON (tmux runs mouse-on by choice) —
-- set disable_mouse=true if you want that stopped too.
--
--   :Hardtime toggle   off/on for a session (the escape hatch when it's in your way)
--   :Hardtime report   most-pressed keys (needs nui.nvim, added below)

vim.pack.add {
  'https://github.com/MunifTanjim/nui.nvim', -- report UI dependency
  'https://github.com/m4xshen/hardtime.nvim',
}

require('hardtime').setup {
  restriction_mode = 'block', -- refuse the key, don't just hint
  disable_mouse = true, -- no mouse navigation in nvim either (keyboard-only)
  -- arrow keys are blocked in normal + insert via hardtime's default disabled_keys
}
