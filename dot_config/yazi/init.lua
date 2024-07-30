require("relative-motions"):setup({ show_numbers = "relative_absolute" })
require("yatline"):setup({
  theme = {
    section_separator = { open = "", close = "" },
    part_separator = { open = "", close = "" },
    inverse_separator = { open = "", close = "" },

    style_a = {
      fg = "bright black",
      bg_mode = {
        normal = "blue",
        select = "green",
        un_set = "magenta",
      },
    },
    style_b = { bg = "bright black", fg = "blue" },
    style_c = { bg = "black", fg = "blue" },

    permissions_t_fg = "blue",
    permissions_r_fg = "green",
    permissions_w_fg = "yellow",
    permissions_x_fg = "red",
    permissions_s_fg = "magenta",

    selected = { icon = "󰻭", fg = "yellow" },
    copied = { icon = "", fg = "green" },
    cut = { icon = "", fg = "red" },

    total = { icon = "󰮍", fg = "yellow" },
    succ = { icon = "", fg = "green" },
    fail = { icon = "", fg = "red" },
    found = { icon = "󰮕", fg = "blue" },
    processed = { icon = "󰐍", fg = "green" },
  },
  tab_width = 10,
  tab_use_inverse = true,
  show_background = true,
  header_line = {
    left = {
      section_a = {},
      section_b = {
        { type = "string", custom = false, name = "tab_path" },
      },
      section_c = {},
    },
    right = {
      section_a = {
        { type = "line", custom = false, name = "tabs" },
      },
      section_b = {},
      section_c = {},
    },
  },
  status_line = {
    left = {
      section_a = {
        { type = "string", custom = false, name = "tab_mode" },
      },
      section_b = {
        { type = "coloreds", custom = false, name = "githead" },
      },
      section_c = {
        { type = "coloreds", custom = false, name = "count" },
      },
    },
    right = {
      section_a = {
        { type = "string", custom = false, name = "cursor_position" },
      },
      section_b = {
        { type = "string", custom = false, name = "hovered_size" },
        { type = "coloreds", custom = false, name = "permissions" },
      },
      section_c = {},
    },
  },
})
require("yatline-githead"):setup({
  show_branch = true,
  branch_prefix = "",
  prefix_color = "",
  branch_color = "blue",
  branch_symbol = "",
  branch_borders = "",

  commit_color = "blue",
  commit_symbol = "@",

  show_stashes = true,
  stashes_color = "magenta",
  stashes_symbol = "$",

  show_state = true,
  show_state_prefix = true,
  state_color = "red",
  state_symbol = "~",

  show_staged = true,
  staged_color = "green",
  staged_symbol = "+",

  show_unstaged = true,
  unstaged_color = "yellow",
  unstaged_symbol = "!",

  show_untracked = true,
  untracked_color = "red",
  untracked_symbol = "?",
})
function Yatline.string.get:cursor_position()
  local length = #cx.active.current.files
  if length ~= 0 then
    return string.format("%2d/%-2d", cx.active.current.cursor + 1, length)
  else
    return "0"
  end
end
