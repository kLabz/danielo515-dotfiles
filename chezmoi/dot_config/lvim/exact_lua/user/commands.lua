local bind = require("danielo").bind
local create_sibling_file = require("user.util.create").create_sibling_file
local copy_messages_to_clipboard = require("user.util").copy_messages_to_clipboard
local create_module = require("user.ui.split_module").create_module
local open_module = require("user.ui.split_module").open_module

local Ok, err = pcall(function()
  local command = require("legendary").command
  command {
    ":CopyMessages",
    function()
      copy_messages_to_clipboard()
    end,
    description = "Copy the output of :messages to OS clipboard",
  }
  command {
    ":CopyLast10Messages",
    bind(copy_messages_to_clipboard, 10),
    description = "Copy the last 10 lines of :messages to OS clipboard",
  }
  command {
    ":CreateSibling",
    create_sibling_file,
    description = "Create a new file that is a sibling of the current one",
  }
  command {
    ":CreateModule",
    create_module,
    description = "Create a new interface + implementation file and open in split view",
  }
  command {
    ":OpenModule",
    open_module,
    description = "Opens the current file with its rei file in a split view",
  }
end)

if not Ok then
  vim.notify("Error creating utility commands with legendary: " .. err, vim.log.levels.ERROR, { title = "Danielo" })
end
