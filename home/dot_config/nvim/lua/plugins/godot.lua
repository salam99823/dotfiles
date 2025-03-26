---@module "lazy"

---@type LazySpec[]
return {
  "lommix/godot.nvim",
  cmd = {
    "GodotDebug",
    "GodotBreakAtCursor",
    "GodotStep",
    "GoedotQuit",
    "GodotContinue",
  },
  lazy = true,
  main = "godot",
  opts = {
    bin = "godot",
    gui = {
      console_config = vim.api.nvim_open_win,
    },
  },
}
