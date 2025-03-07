---@module "lazy"
---@module "mason-lspconfig"

---@type LazySpec[]
return {
  {
    "williamboman/mason-lspconfig.nvim",
    ---@param _ LazyPlugin
    ---@param opts table
    ---@return table
    opts = function(_, opts)
      return vim.tbl_deep_extend("force", opts, {
        ensure_installed = vim.list_extend(opts.ensure_installed or {}, {
          "svelte",
          "emmet_ls",
          "cssls",
          "lua_ls",
          "pylsp",
          "lemminx",
          "biome",
          "taplo",
          "hydra_lsp",
        }),
      })
    end,
  },
}
