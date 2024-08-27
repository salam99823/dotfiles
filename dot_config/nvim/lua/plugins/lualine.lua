---@module "lazy"
---@module "lualine"

---@type LazySpec[]
return {
  {
    "nvim-lualine/lualine.nvim",
    ---@param _ LazyPlugin
    ---@param opts table
    ---@return table
    opts = function(_, opts)
      local section_separators, component_separators =
        vim.g.separators.section, vim.g.separators.component
      return {
        options = vim.tbl_deep_extend("force", opts.options or {}, {
          globalstatus = true,
          component_separators = component_separators,
          section_separators = section_separators,
        }),
        sections = {
          lualine_a = { "mode" },
          lualine_b = { "branch" },
          lualine_c = {
            LazyVim.lualine.root_dir(),
            {
              function()
                return require("nvim-navic").get_location()
              end,
              cond = function()
                return package.loaded["nvim-navic"] and require("nvim-navic").is_available()
              end,
            },
          },
          lualine_x = vim.list_slice(opts.sections.lualine_x, 1, 4),
          lualine_y = opts.sections.lualine_y,
          lualine_z = {
            {
              "datetime",
              style = "%T",
            },
          },
        },
      }
    end,
  },
}
