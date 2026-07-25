-- Always-on, privacy-filtered keystroke logger.
--
-- Records normal / visual / operator-pending keys and special keys (arrows,
-- <BS>, <Esc>, <CR>, <C-*>) so real-work nvim inefficiencies show up in the
-- data: jjjj runs, arrow keys, repeated operators, motions you never reach for.
--
-- PRIVACY: the text you type is NOT recorded. Printable characters in
-- insert / replace / cmdline / terminal / select modes are dropped, so
-- passwords, prose, and code never hit disk — only motions and special keys.
--
--   Log:      stdpath('state')/keylog/YYYY-MM-DD.log   (`<mode>\t<key>` per line)
--   Disable:  :lua vim.g.keylog_disable = true   (or set before startup)
--   Analyze:  the `vimstats` shell command (~/projects/vim/tools/vimstats.py)

-- Guard against double-registration if this file is re-sourced.
if vim.g._keylog_loaded then return end
vim.g._keylog_loaded = true

local dir = vim.fs.joinpath(vim.fn.stdpath 'state', 'keylog')
vim.fn.mkdir(dir, 'p')

local batch = {}
local BATCH_MAX = 256

local function logpath()
  return vim.fs.joinpath(dir, os.date '%Y-%m-%d' .. '.log')
end

local function flush()
  if #batch == 0 then return end
  local f = io.open(logpath(), 'a')
  if not f then return end
  f:write(table.concat(batch))
  f:close()
  batch = {}
end

-- A single printable-ASCII byte is literal text the user typed.
local function is_text_byte(key)
  if #key ~= 1 then return false end
  local b = key:byte()
  return b >= 0x20 and b <= 0x7e
end

-- Normalize the mode to a single tag char (visual-block / select-block report
-- as control bytes otherwise, which would corrupt the log).
local function mode_tag(m)
  local c = m:sub(1, 1)
  if c == '\22' then return 'v' end -- <C-v> visual block
  if c == '\19' then return 's' end -- <C-s> select block
  return c
end

-- Modes where printable keys are buffer/command CONTENT (drop them). Normal,
-- visual, and operator-pending are where motions/commands live (keep those).
local CONTENT = { i = true, R = true, c = true, t = true, s = true, S = true }

vim.on_key(function(_key, typed)
  pcall(function()
    if vim.g.keylog_disable then return end
    -- `typed` is the physically typed key (before mapping). When it's empty the
    -- key came from a mapping/macro expansion, not the keyboard — skip it, so we
    -- log what the fingers did, not `<Cmd>…` expansions.
    if typed == nil or typed == '' then return end
    local tag = mode_tag(vim.api.nvim_get_mode().mode)
    if CONTENT[tag] and is_text_byte(typed) then return end
    local readable = vim.fn.keytrans(typed)
    if readable == '' then return end
    batch[#batch + 1] = tag .. '\t' .. readable .. '\n'
    if #batch >= BATCH_MAX then flush() end
  end)
end)

-- Flush periodically (crash-safety) and on exit.
local timer = vim.uv.new_timer()
timer:start(15000, 15000, vim.schedule_wrap(flush))
vim.api.nvim_create_autocmd('VimLeavePre', { callback = flush })
