local Layout = require "nui.layout"
local Popup = require "nui.popup"

local win_options = {
  -- winblend = 10,
  winhighlight = "Normal:Normal,FloatBorder:FloatBorder",
}

local buf_options = {
  modifiable = true,
  readonly = false,
}

---Map the common set of keys for each popup
---@param pop any
---@param layout any
---@param alt_win number The window Id of the other popup
local function mapKeys(layout, pop, alt_win)
  pop:map("n", "<Esc>", function()
    layout:unmount()
  end)
  local function goto_alt()
    vim.api.nvim_set_current_win(alt_win)
  end
  -- because when all you have is two windows, who cares about direction?
  pop:map("n", "<Tab>", goto_alt)
  pop:map("n", "<c-l>", goto_alt)
  pop:map("n", "<c-h>", goto_alt)
end

---Mounts a split window with the two buffers loaded into each side.
---@param moduleName string
---@param buffers { implementation = number, interface = number } table with buffer ids
local function mount_window(moduleName, buffers)
  local p1 = Popup {
    enter = true,
    bufnr = buffers.implementation,
    win_options = win_options,
    buf_options = buf_options,
    border = {
      style = "double",
      text = {
        top = moduleName .. ".re",
        bottom = "<Esc> close this window",
      },
    },
  }

  local p2 = Popup {
    win_options = win_options,
    buf_options = buf_options,
    bufnr = buffers.interface,
    border = {
      style = "rounded",
      text = {
        top = moduleName .. ".rei",
      },
    },
  }

  local layout = Layout(
    { position = "50%", size = "90%", relative = "editor" },
    Layout.Box {
      Layout.Box({
        Layout.Box(p1, { size = "50%" }),
        Layout.Box(p2, { size = "50%" }),
      }, { size = "100%" }),
    }
  )

  layout:mount()
  -- Always map after mount
  mapKeys(layout, p1, p2.winid)
  mapKeys(layout, p2, p1.winid)
end

local function make_buffers(moduleName)
  local implementation = vim.fn.bufadd(moduleName .. ".re")
  local interface = vim.fn.bufadd(moduleName .. ".rei")

  vim.fn.bufload(implementation)
  vim.fn.bufload(interface)

  return { interface = interface, implementation = implementation }
end

---Creates a new module (interface + implementation) and opens
--it in a split floating window
local function create_module()
  local current_file = vim.fn.expand "%:t:r"
  D.vim.input(function(name)
    local path = vim.fn.expand "%:p:h"
    local buffers = make_buffers(path .. "/" .. name)
    mount_window(name, buffers)
  end, { current_file })
end

---Opens the current file as a module in a floating window
local function open_module()
  -- current file without extension
  local path = vim.fn.expand "%:p:r"
  local buffers = make_buffers(path)
  mount_window(name, buffers)
end

local M = {
  create_module = create_module,
}

return M
