---@module "lazy"
---@module "conform"

---@type LazySpec[]
return {
  {
    "stevearc/conform.nvim",
    ---@param _ LazyPlugin
    ---@param opts conform.setupOpts
    ---@return conform.setupOpts
    opts = function(_, opts)
      return vim.tbl_deep_extend("force", opts, {
        formatters_by_ft = {
          lua = { "stylua" },
          python = {
            "ruff_fix",
            "ruff_format",
            "ruff_organize_imports",
          },
          javascript = { "prettierd", "prettier" },
          typescript = { "prettierd", "prettier" },
          json = { "prettierd", "prettier", "biome" },
          css = { "prettierd", "prettier" },
          markdown = { "markdownlint", "prettierd", "prettier" },
          yaml = { "prettierd", "prettier" },
          rust = { "rustfmt" },
          toml = { "taplo" },
        },
      })
    end,
  },
}
