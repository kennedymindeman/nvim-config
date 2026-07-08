-- debug.lua
--
-- Shows how to use the DAP plugin to debug your code.
--
-- Primarily focused on configuring the debugger for Go, but can
-- be extended to other languages as well. That's why it's called
-- kickstart.nvim and not kitchen-sink.nvim ;)

vim.pack.add {
  'https://github.com/mfussenegger/nvim-dap',
  'https://github.com/igorlfs/nvim-dap-view',
  'https://github.com/mason-org/mason.nvim',
  'https://github.com/jay-babu/mason-nvim-dap.nvim',
  'https://github.com/leoluz/nvim-dap-go',
  'https://github.com/mfussenegger/nvim-dap-python',
}

-- Basic debugging keymaps, feel free to change to your liking!
vim.keymap.set('n', '<F5>', function() require('dap').continue() end, { desc = 'Debug: Start/Continue' })
vim.keymap.set('n', '<F1>', function() require('dap').step_into() end, { desc = 'Debug: Step Into' })
vim.keymap.set('n', '<F2>', function() require('dap').step_over() end, { desc = 'Debug: Step Over' })
vim.keymap.set('n', '<F3>', function() require('dap').step_out() end, { desc = 'Debug: Step Out' })
vim.keymap.set('n', '<leader>b', function() require('dap').toggle_breakpoint() end, { desc = 'Debug: Toggle Breakpoint' })
vim.keymap.set('n', '<leader>B', function() require('dap').set_breakpoint(vim.fn.input 'Breakpoint condition: ') end, { desc = 'Debug: Set Breakpoint' })
-- Toggle the dap-view panel (also how you see output after an unhandled exception).
vim.keymap.set('n', '<F7>', function() require('dap-view').toggle() end, { desc = 'Debug: Toggle UI panel' })
-- Terminate the session cleanly (auto_toggle closes the dap-view panel with it).
vim.keymap.set('n', '<leader>dq', function() require('dap').terminate() end, { desc = 'Debug: Quit/terminate session' })

-- Hover/eval the expression under the cursor (or a visual selection) in a float.
vim.keymap.set({ 'n', 'v' }, '<leader>de', function() require('dap-view').hover() end, { desc = 'Debug: Hover/eval expression' })

-- Jump straight to a section: it fills the whole dap-view panel. (You can also
-- press the winbar letters W/S/E/B/T/R/C once the panel is focused.)
local function jump(view)
  return function() require('dap-view').jump_to_view(view) end
end
vim.keymap.set('n', '<leader>ds', jump 'scopes', { desc = 'Debug: Section > Scopes (variables)' })
vim.keymap.set('n', '<leader>df', jump 'threads', { desc = 'Debug: Section > Threads (call stack)' })
vim.keymap.set('n', '<leader>dw', jump 'watches', { desc = 'Debug: Section > Watches' })
vim.keymap.set('n', '<leader>dr', jump 'repl', { desc = 'Debug: Section > REPL' })
vim.keymap.set('n', '<leader>dc', jump 'console', { desc = 'Debug: Section > Console (program output)' })

local dap = require 'dap'

require('mason-nvim-dap').setup {
  -- Makes a best effort to setup the various debuggers with
  -- reasonable debug configurations
  automatic_installation = true,

  -- You can provide additional configuration to the handlers,
  -- see mason-nvim-dap README for more information
  handlers = {},

  -- You'll need to check that you have the required things installed
  -- online, please don't ask me how to install them :)
  ensure_installed = {
    -- Update this to ensure that you have the debuggers for the langs you want
    'delve',
  },
}

-- dap-view: single tabbed panel instead of dap-ui's tiled sidebar. Each section
-- (winbar tabs W/S/E/B/T/R/C) fills the whole panel, so nothing is cramped.
-- For more information, see |:help dap-view.txt|.
require('dap-view').setup {
  -- Open the panel when a session starts, close it when the session ends.
  auto_toggle = true,
  winbar = {
    -- Add "console" (program stdout/stderr) to the default tab set.
    sections = { 'watches', 'scopes', 'exceptions', 'breakpoints', 'threads', 'repl', 'console' },
  },
  -- Inline variable values at end of line while paused (dap-view's built-in
  -- virtual text; replaces the separate nvim-dap-virtual-text plugin).
  virtual_text = {
    enabled = true,
  },
}

-- Change breakpoint icons (nerd font is on, so use the pretty glyphs).
vim.api.nvim_set_hl(0, 'DapBreak', { fg = '#e51400' })
vim.api.nvim_set_hl(0, 'DapStop', { fg = '#ffcc00' })
local breakpoint_icons = vim.g.have_nerd_font
    and { Breakpoint = '', BreakpointCondition = '', BreakpointRejected = '', LogPoint = '', Stopped = '' }
  or { Breakpoint = '●', BreakpointCondition = '⊜', BreakpointRejected = '⊘', LogPoint = '◆', Stopped = '⭔' }
for type, icon in pairs(breakpoint_icons) do
  local tp = 'Dap' .. type
  local hl = (type == 'Stopped') and 'DapStop' or 'DapBreak'
  vim.fn.sign_define(tp, { text = icon, texthl = hl, numhl = hl })
end

-- (Panel open/close is handled by auto_toggle above — no manual listeners needed.)

-- Install golang specific config
require('dap-go').setup {
  delve = {
    -- On Windows delve must be run attached or it crashes.
    -- See https://github.com/leoluz/nvim-dap-go/blob/main/README.md#configuring
    detached = vim.fn.has 'win32' == 0,
  },
}

-- Python: system python3 has debugpy (pip install --user debugpy). This is both
-- the adapter interpreter and the default one your code runs under.
-- Per-project .vscode/launch.json configs (module/args launches) are read
-- automatically on demand by nvim-dap — no explicit loader needed.
require('dap-python').setup 'python3'
