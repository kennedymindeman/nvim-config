-- hardtime.nvim — nudges you toward better motions when you do the inefficient
-- thing (holding j/k, hammering a key, dll-instead-of-2dl).
--
-- Set up GENTLE on purpose: it HINTS, it never blocks. Pairs with the keylog
-- (lua/custom/plugins/keylog.lua) + `vimstats`: the keylog MEASURES the habit,
-- hardtime nudges it in the moment. Once `vimstats` names your worst habit,
-- tighten this (restriction_mode = 'block', or list arrows in disabled_keys).
--
--   :Hardtime toggle   turn it off/on for a session
--   :Hardtime report   most-pressed keys (needs nui.nvim, added below)

vim.pack.add {
  'https://github.com/MunifTanjim/nui.nvim', -- report UI dependency
  'https://github.com/m4xshen/hardtime.nvim',
}

require('hardtime').setup {
  restriction_mode = 'hint', -- suggest a better motion; never block the key
  disable_mouse = false, -- keep the mouse (tmux runs with mouse on by choice)
  disabled_keys = {}, -- don't hard-disable arrows; keylog + vimstats track those
}
