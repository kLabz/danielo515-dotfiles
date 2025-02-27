local vmap = require("user.util.keymap").vmap
local imap = require("user.util.keymap").imap

-- This two were remmoved by LVIM from the defaults, too bad
lvim.keys.normal_mode["<S-l>"] = ":BufferLineCycleNext<CR>"
lvim.keys.normal_mode["<S-h>"] = ":BufferLineCyclePrev<CR>"
lvim.keys.normal_mode["<C-F>"] = "<cmd>lua require('user.telescope').grep_files()<cr>"
lvim.keys.normal_mode["<S-X>"] = "<cmd>BufferKill<cr>"
lvim.keys.normal_mode["kj"] = false
lvim.keys.normal_mode["jk"] = false
-- Navigation
lvim.keys.normal_mode["s"] = ":Pounce<cr>"
vmap("s", "<cmd>Pounce<cr>", "Extend visual selection with pounce")
-- Lsp
lvim.keys.normal_mode["<F2>"] = "<cmd>lua vim.lsp.buf.rename()<cr>"
lvim.keys.normal_mode["<M-cr>"] = "<cmd>lua vim.lsp.buf.code_action()<cr>"
vmap("<M-cr>", "<cmd>lua vim.lsp.buf.range_code_action()<cr>", "Range code action")
-- File
lvim.keys.normal_mode["<M-F>"] =
  '<cmd>lua require("telescope").extensions.file_browser.file_browser { cwd = vim.fn.expand "%:p:h:", grouped = true, depth= false, hidden = true }<CR>'
lvim.keys.normal_mode["<Tab>"] = "<cmd>lua require('user.telescope').buffers()<cr>"
lvim.keys.normal_mode["<S-Tab>"] = ":Neotree float reveal<cr>"
-- Other
lvim.keys.normal_mode["<A-k>"] = ":Telescope command_center<CR>"
lvim.keys.normal_mode["<C-N>"] = ":NvimTreeFindFile<cr>"
lvim.keys.normal_mode["<C-;>"] = ":Telescope command_history<cr>"
lvim.keys.normal_mode[",n"] = "<cmd>lua vim.diagnostic.goto_next()<cr>"
-- lvim.keys.normal_mode["ml"] = "dd<C-W><C-l>p<C-w><C-h>"
lvim.keys.normal_mode["+"] = "<cmd>3wincmd > <cr>"
lvim.keys.normal_mode["-"] = "<cmd>3wincmd < <cr>"
vmap("p", '"_dP', "Paste without saving to clipboard")
-- Tab bindings
lvim.keys.normal_mode["tk"] = ":tabclose<cr>"
lvim.keys.normal_mode["tn"] = ":tabnew<cr>"
lvim.keys.normal_mode["tl"] = ":tabNext<cr>"
lvim.keys.normal_mode["th"] = ":tabprev<cr>"
lvim.builtin.terminal.open_mapping = "<c-t>"
-- I'm handling this myself in a separate plugin
lvim.keys.normal_mode["gp"] = nil
-- insert_mode key bindings
lvim.keys.insert_mode["jj"] = false
lvim.keys.insert_mode["kj"] = false
lvim.keys.insert_mode["jk"] = false
lvim.keys.insert_mode["<C-f>"] = lvim.keys.normal_mode["<C-F>"]
lvim.keys.insert_mode["<C-u>"] = "<cmd>lua require('luasnip.extras.select_choice')()<cr>"
-- lvim.keys.insert_mode["<C-y>"] =
--   "<cmd>lua require('telescope').extensions.neoclip.default(require('telescope.themes').get_ivy())<cr>"
lvim.keys.insert_mode["<C-s>"] = "<cmd>lua vim.lsp.buf.signature_help()<cr>"
lvim.keys.insert_mode["<A-s>"] =
  "<cmd>lua require('telescope').extensions.luasnip.luasnip(require('telescope.themes').get_cursor({}))<CR>"
-- control a navigates to home in command mode
vim.keymap.set("c", "<C-A>", "<Home>", { noremap = false })

-- omap     <silent> m :<C-U>lua require('tsht').nodes()<CR>
vim.keymap.set(
  "o",
  "m",
  ':<C-U>lua require("tsht").nodes()<CR>',
  { silent = true, desc = "Highlight nodes to jump to" }
)
vim.keymap.set(
  "x",
  "m",
  ':<C-U>lua require("tsht").nodes()<CR>',
  { silent = true, noremap = false, desc = "Highlight nodes to jump to" }
)

imap("<C-N>", "<cmd>lua require'cmp'.complete()<cr>", "trigger autocomplete in insert mode")

local bind = require("user.util").bind
local nmap = require("user.util.keymap").nmap
nmap("<C-C>", bind(vim.api.nvim_win_close, 0, false), "Close current window")
nmap("<C-P>", ":Telescope command_center<cr>", "Open command center")
nmap("<C-s>", ":%s/", "Search and replace whole file", false)
nmap(",h", ":Gitsigns next_hunk<cr>", "Next git hunk")
nmap(",c", ":cNext!<cr>", "Next item in quickfix")
nmap(",s", ":s/", "Search/replace local line")

-- An awesome method to jump to windows
local picker = require "window-picker"
vim.keymap.set("n", ",w", function()
  local picked_window_id = picker.pick_window {
    include_current_win = true,
  } or vim.api.nvim_get_current_win()
  vim.api.nvim_set_current_win(picked_window_id)
end, { desc = "Pick a window" })

-- Swap two windows using the awesome window picker
local function swap_windows()
  local window = picker.pick_window {
    include_current_win = false,
  }
  local target_buffer = vim.fn.winbufnr(window)
  -- Set the target window to contain current buffer
  vim.api.nvim_win_set_buf(window, 0)
  -- Set current window to contain target buffer
  vim.api.nvim_win_set_buf(0, target_buffer)
end

nmap(",W", swap_windows, "Swap windows")
