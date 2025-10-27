---@module "lazy"
---@module "cmp"

---@type LazySpec[]
return {
  {
    "saghen/blink.cmp",
    lazy = false,
    dependencies = "rafamadriz/friendly-snippets",

    ---@module 'blink.cmp'
    ---@param opts blink.cmp.Config
    opts = function(_, opts)
      return vim.tbl_deep_extend("force", opts, {
        appearance = {
          use_nvim_cmp_as_default = true,
        },
        signature = { enabled = true },
      })
    end,
  },
}
