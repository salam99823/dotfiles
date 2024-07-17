-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
vim.g.mapleader = " "
vim.o.termguicolors = true
vim.g.trouble_lualine = false

local component = 2
local section = 2
vim.g.separators = {
  component = {
    left = ({
      "",
      "",
      "",
      "",
      " ",
      "┊",
      "|",
    })[component],
    right = ({
      "",
      "",
      "",
      "",
      " ",
      "┊",
    })[component],
  },
  section = {
    left = ({
      "",
      "",
      "",
      "",
      " ",
      "",
    })[section],
    right = ({
      "",
      "",
      "",
      "",
      " ",
      "",
    })[section],
  },
}
---@type { statusline: boolean?, incline: boolean } | table<any, boolean?>
vim.g.isolation = { statusline = false, incline = false }
