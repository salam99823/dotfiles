---@module "lazy"
---@module "lspconfig"

---@type LazySpec[]
return {
  {
    "neovim/nvim-lspconfig",
    ---@param _ LazyPlugin
    ---@param opts lspconfig.settings
    ---@return lspconfig.settings
    opts = function(_, opts)
      return vim.tbl_deep_extend("force", opts, {
        setup = {
          rust_analyzer = function()
            return true
          end,
        },
      })
    end,
  },
}
