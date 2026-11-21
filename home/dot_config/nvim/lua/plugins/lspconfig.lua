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
        servers = {
          jdtls = {
            mason = false,
          },
        },
      })
    end,
  },
  {
    "mfussenegger/nvim-jdtls",
    opts = function(_, opts)
      opts.cmd = { vim.fn.exepath("jdtls") }
      opts.root_dir = function(path)
        return vim.fs.root(path, vim.lsp.config.jdtls.root_markers) or vim.fs.dirname(path)
      end
      return opts
    end,
  },
}
