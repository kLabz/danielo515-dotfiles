return {
  "ggandor/leap-spooky.nvim",
  requires = "ggandor/leap.nvim",
  config = function()
    require("leap-spooky").setup {
      affixes = {
        -- These will generate mappings for all native text objects, like:
        -- (ir|ar|iR|aR|im|am|iM|aM){obj}.
        -- E.g `darw` for delete a remote word
        -- Special line objects will also be added, by repeating the affixes.
        -- E.g. `yrr<leap>` and `ymm<leap>` will yank a line in the current
        -- window.
        -- You can also use 'rest' & 'move' as mnemonics.
        remote = { window = "r", cross_window = "R" },
        -- magnetic means you are going to move to the position where you are yanking
        magnetic = { window = "m", cross_window = "M" },
      },
      -- If this option is set to true, the yanked text will automatically be pasted
      -- at the cursor position if the unnamed register is in use.
      paste_on_remote_yank = true,
    }
  end,
}
