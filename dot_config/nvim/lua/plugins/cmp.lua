---@module "lazy"
---@module "cmp"

local utils = require("utils")

---@type LazySpec[]
return {
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "chrisgrieser/cmp-nerdfont",
      {
        "hrsh7th/cmp-nvim-lua",
        ft = "lua",
      },
      {
        "vrslev/cmp-pypi",
        dependencies = "nvim-lua/plenary.nvim",
        ft = "toml",
      },
      {
        "David-Kunz/cmp-npm",
        dependencies = "nvim-lua/plenary.nvim",
        ft = "json",
        config = function(_, opts)
          require("cmp-npm").setup(opts)
        end,
      },
    },
    ---@param _ LazyPlugin
    ---@param opts unknown
    ---@return unknown
    opts = function(_, opts)
      return vim.tbl_deep_extend("force", opts, {
        sources = vim.list_extend(
          opts.sources or {},
          utils.sources({
            "pypi",
            "npm",
            "nvim_lua",
            {
              "nerdfont",
              group_index = 2,
            },
          })
        ),
      })
    end,
  },
}
