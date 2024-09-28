---@module "lazy"
---@module "cmp"

---@type LazySpec[]
return {
  {
    "Mofiqul/dracula.nvim",
    opts = {
      overrides = function(colors)
        return {
          Normal = { fg = colors.fg, bg = "None" },
          NormalFloat = { fg = colors.fg, bg = "None" },
          SignColumn = { bg = "None" },
          NvimTreeNormal = { fg = colors.fg, bg = "None" },
          NvimTreeVertSplit = { fg = colors.bg, bg = "None" },
          NeoTreeNormal = { fg = colors.fg, bg = "None" },
          NeoTreeNormalNC = { fg = colors.fg, bg = "None" },
          TelescopeNormal = { fg = colors.fg, bg = "None" },
        }
      end,
    },
  },
}
