local Input = require("nui.input")
local Popup = require("nui.popup")
local event = require("nui.utils.autocmd").event
local bind = require("user.util").bind
local renderHelp = require_clean("user.form.print-help")

local layout = {
  popup = nil,
  input = nil,
  help = nil,
}

---@class Key_spec
---@field keys string[]
---@field description string
---@field modes mode[]


---@alias Mappings table<string, Key_spec>
---@type Mappings
local default_mappings = {
  switch_key = {
    keys = { '<Tab>', '<Enter>' },
    description = ' Jump to next input',
    modes = { 'n', 'i' }
  },
  exit_key = {
    keys = { 'q' },
    description = 'Exit the form',
    modes = { 'n' }
  } }


local function bindExitEvents(popups)
  for _, popup in pairs(popups) do
    popup:on({ event.BufWinLeave }, function()
      vim.schedule(function()
        popup:unmount()
      end)
    end, { once = true })
  end
end

local function exit()
  for _, popup in pairs(layout) do
    if popup ~= nil then
      popup:unmount()
    end
  end
end

---@alias mode 'n'|'i'

---Binds the requested keys t
---@param binds Mappings
---@param popup nui.popup
---@param alt_win integer alternative window to jump on switch
local function bindKeys(binds, popup, alt_win)
  local opts = { noremap = true }
  ---@param key string
  ---@param cb function
  ---@param modes mode[]
  local function map(key, cb, modes)
    for _, m in ipairs(modes) do
      popup:map(m, key, cb, opts)
    end
  end

  for _, key in ipairs(binds.switch_key.keys) do
    -- Switch key is bound in input mode for convenience
    map(key, function()
      vim.api.nvim_set_current_win(alt_win)
      vim.schedule(function()
        vim.cmd('startinsert')
      end)
    end, binds.switch_key.modes)
  end
  map(binds.exit_key.keys[1], exit, binds.exit_key.modes)
end

local width = 60
local focus = vim.api.nvim_set_current_win
local pprint = vim.pretty_print

local input_options = {
  relative = "editor",
  position = {
    row = '50%',
    col = '50%',
  },
  size = width,
  border = {
    style = "rounded",
    text = {
      top = "[Input]",
      top_align = "left",
    },
  },
  win_options = {
    winhighlight = "Normal:Normal",
  },
}


layout.input = Input(input_options, {
  prompt = "> ",
  default_value = "",
  on_close = function()
    print("Input closed!")
    exit()
  end,
  on_submit = function(value)
    print("Value submitted: ", value)
    focus(layout.popup.winid)
  end,
  -- on_change = function(value)
  --   print("Value changed: ", value)
  -- end,
})


-- -- Mount the popup only after the input has been mounted
-- layout.input:on({ event.WinEnter },
--   function()
--     layout.popup:mount()
--     layout.help:mount()
--     -- bindKeys('n', { switch_key = '<Tab>', exit_key = 'q' }, layout.input, layout.popup.bufnr)
--     bindKeys('n', { switch_key = '<Tab>', exit_key = 'q' }, layout.popup, layout.input.bufnr)
--   end, { once = true })



-- POPUP
layout.popup = Popup({
  enter = false,
  focusable = true,
  relative = 'editor',
  border = {
    style = "rounded",
  },
  position = {
    col = layout.input.win_config.col,
    row = layout.input.win_config.row + layout.input.win_config.height + 2,
  },
  size = {
    width = width,
    height = 20,
  },
  buf_options = {
    modifiable = true,
    readonly = false,
  },
})



-- Help window
layout.help = Popup({
  enter = false,
  focusable = false,
  relative = 'editor',
  border = {
    style = "rounded",
  },
  position = {
    col = layout.popup.win_config.col,
    row = layout.popup.win_config.row + layout.popup.win_config.height + 2,
  },
  size = {
    width = width,
    height = 2,
  },
  buf_options = {
    modifiable = true,
    readonly = false,
  },
})


layout.input:mount()
layout.popup:mount()
layout.help:mount()

bindKeys(default_mappings, layout.input, layout.popup.winid)
bindKeys(default_mappings, layout.popup, layout.input.winid)
bindExitEvents(vim.tbl_values(layout))

vim.schedule(bind(renderHelp, default_mappings, layout.help.bufnr))
-- vim.pretty_print(popup)
-- set content
-- vim.api.nvim_buf_set_lines(popup.bufnr, 0, 1, false, { "Hello World" })
