---@module "lazy"
---@module "mason"

---@type LazySpec[]
return {
  {
    "williamboman/mason.nvim",
    ---@param _ LazyPlugin
    ---@param opts MasonSettings
    ---@return MasonSettings
    opts = function(_, opts)
      return vim.tbl_deep_extend("force", opts, {
        ui = {
          icons = {
            package_installed = "󰄳",
            package_pending = "󰇚",
            package_uninstalled = "󰝦",
          },
        },
      })
    end,
  },
}
