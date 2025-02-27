local M = {}

M.config = function()
  local status_ok, bl = pcall(require, "indent_blankline")
  if not status_ok then
    vim.notify("Could not load indent_blankline", "warn")
    return
  end
  D.autocmd({ "ColorScheme" }, "Danielo-colorscheme", {
    pattern = "*",
    desc = "Setups color lines for indent-blankline",
    callback = function()
      vim.cmd [[highlight IndentBlanklineIndent1 guifg=#E06C75 gui=nocombine]]
      vim.cmd [[highlight IndentBlanklineIndent2 guifg=#E5C07B gui=nocombine]]
      vim.cmd [[highlight IndentBlanklineIndent3 guifg=#98C379 gui=nocombine]]
      vim.cmd [[highlight IndentBlanklineIndent4 guifg=#56B6C2 gui=nocombine]]
      vim.cmd [[highlight IndentBlanklineIndent5 guifg=#61AFEF gui=nocombine]]
      vim.cmd [[highlight IndentBlanklineIndent6 guifg=#C678DD gui=nocombine]]
    end,
  })

  bl.setup {
    enabled = true,
    bufname_exclude = { "README.md" },
    buftype_exclude = { "terminal", "nofile" },
    filetype_exclude = {
      "alpha",
      "log",
      "gitcommit",
      "dapui_scopes",
      "dapui_stacks",
      "dapui_watches",
      "dapui_breakpoints",
      "dapui_hover",
      "LuaTree",
      "dbui",
      "UltestSummary",
      "UltestOutput",
      "vimwiki",
      "markdown",
      "json",
      "txt",
      "vista",
      "NvimTree",
      "git",
      "TelescopePrompt",
      "undotree",
      "flutterToolsOutline",
      "org",
      "orgagenda",
      "help",
      "startify",
      "dashboard",
      "packer",
      "neogitstatus",
      "Outline",
      "Trouble",
      "lspinfo",
      "", -- for all buffers without a file type
    },
    -- char = "▏",
    char_list = { "", "¦", "¦", "" },
    char_highlight_list = {
      "IndentBlanklineIndent1",
      "IndentBlanklineIndent2",
      "IndentBlanklineIndent3",
      "IndentBlanklineIndent4",
      "IndentBlanklineIndent5",
      "IndentBlanklineIndent6",
    },
    show_trailing_blankline_indent = false,
    show_first_indent_level = false,
    space_char_blankline = " ",
    use_treesitter = true,
    show_foldtext = false,
    show_current_context = true,
    show_current_context_start = true,
    context_patterns = {
      "class",
      "return",
      "function",
      "method",
      "^if",
      "^do",
      "^switch",
      "^while",
      "jsx_element",
      "^for",
      "^object",
      "^table",
      "block",
      "arguments",
      "if_statement",
      "else_clause",
      "jsx_element",
      "jsx_self_closing_element",
      "try_statement",
      "catch_clause",
      "import_statement",
      "operation_type",
    },
  }
end

return M
