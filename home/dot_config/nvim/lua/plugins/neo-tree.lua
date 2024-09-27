---@module "lazy"
---@module "neo-tree"

---@type LazySpec[]
return {
  {
    "nvim-neo-tree/neo-tree.nvim",
    ---@param _ LazyPlugin
    ---@param opts table
    ---@return table
    opts = function(_, opts)
      return vim.tbl_deep_extend("force", opts, {
        close_if_last_window = true,
        filesystem = { filtered_items = { visible = true } },
        event_handlers = {
          {
            event = "file_open_requested",
            handler = function()
              require("neo-tree.command").execute({ action = "close" })
            end,
          },
        },
      })
    end,
  },
}
