-- Fuck it, I'm gonna drop some global utility functions for my personal use!!
_G.D = {} -- But namespaced, obviously!

---Prints whatever argument it gets, and then returns it.
--Useful to add in the middle of any pipeline without much trouble
---@generic T
---@param arg T
---@return T
function D.Peek(arg)
  vim.pretty_print(arg)
  return arg
end

---Make a require of a module in a protected call. If the call succeeds, then call the on_success
---Everything is executed within protected calls
---@generic T
---@param path string
---@param on_success? function
---@param on_fail? function
---@return T
function D.require(path, on_success, on_fail)
  local ok, lib = pcall(require, path)
  on_fail = on_fail or D.noop
  if ok then
    if type(on_success) == "function" then
      pcall(on_success, lib)
    else
      return lib
    end
  else
    vim.notify("Failed to require library: " .. path, vim.log.levels.ERROR, { title = "Danielo" })
    pcall(on_fail)
  end
  return nil
end

local fun = D.require "danielo.fun"

---Requires the configuration module in a protected call
-- and calls its setup or config function if it exists
---@param path string path to the module that needs to be configured
function D.pconf(path, ...)
  local args = { ... }
  D.require(path, function(module)
    local setup_fn = module.config or module.setup
    return D.call(setup_fn, unpack(args))
  end)
end

---Tries to require the current file with a require
--clean path. The method is not very good, so it may
--fail if the expected path is not exactly the one you thing
function D.req_current()
  local current_file = vim.fn.expand("%:r"):gsub(".*lua/", "")
  return D.call(lvim.require_clean, current_file)
end

-- Yes, a function that does nothing, deal with it
D.noop = function() end
-- Shortcut
_G.preq = D.require

D = fun.assign(D, fun)

--Better defaults and interfaces for vim commands
D.vim = D.require "danielo.vim"
D.file = D.require "danielo.file"
D.fun = D.require "danielo.fun"
D.string = D.require "danielo.string"
D.popup = D.require "danielo.ui.PopupKeys"
-- Shortcuts
D.autocmd = D.vim.autocmd
