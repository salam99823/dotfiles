---@module "lazy"
---@module "incline"

---@class RenderResult
---@field start string?
---@field stop string?
---@field cterm string?
---@field ctermfg string?
---@field ctermbg string?
---@field gui string?
---@field guifg string?
---@field guibg string?
---@field guisp string?
---@field font string?
---@field blend string | integer?

---@alias render_result
---| string
---| string[]
---| RenderResult
---| RenderResult[]

---@type LazySpec[]
return {
  {
    "b0o/incline.nvim",
    main = "incline",
    event = "VeryLazy",
    keys = {
      {
        "<leader>uN",
        function()
          require("incline").toggle()
        end,
        desc = "Incline Toggle",
      },
    },
    opts = function()
      local separator = vim.g.separators.component
      return {
        ---@param props { buf: number, win: number, focused: boolean }
        ---@return render_result[]
        render = function(props)
          local ok, theme = pcall(require, "lualine.themes." .. vim.g.colors_name)
          local filename = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(props.buf), ":t")
          local ft_icon, ft_color = require("nvim-web-devicons").get_icon_color(filename)
          local group = props.focused and "Normal" or "Inactive"
          local modified = vim.api.nvim_get_option_value("modified", { buf = props.buf })
          local borders = {
            left = {
              ok and vim.g.separators.section.left or vim.g.separators.component.left,
              group = "InclineBorder" .. group,
            },
            right = {
              ok and vim.g.separators.section.right or vim.g.separators.component.right,
              group = "InclineBorder" .. group,
            },
          }
          for hl_group, value in pairs({
            InclineNormal = ok and { fg = theme.normal.b.fg, bg = theme.normal.b.bg },
            InclineInactive = ok and { bg = theme.inactive.b.bg, fg = theme.normal.b.fg },
            InclineBorderNormal = ok and { fg = theme.normal.b.bg, bg = "bg" },
            InclineBorderInactive = ok and { fg = theme.inactive.b.bg, bg = "bg" },
          }) do
            vim.api.nvim_set_hl(0, hl_group, value or { link = "NormalFloat" })
          end
          local function get_git_diff()
            local signs, diff = vim.b[props.buf].gitsigns_status_dict or {}, { " " }
            local icons = {
              added = LazyVim.config.icons.git.added,
              changed = LazyVim.config.icons.git.modified,
              removed = LazyVim.config.icons.git.removed,
            }
            for key, icon in pairs(icons) do
              if signs[key] and signs[key] ~= 0 then
                table.insert(diff, { icon .. signs[key] .. " ", group = "Diff" .. key })
              end
            end
            return diff
          end
          local function get_diagnostic_label()
            local diagnostics = {}
            for severity, icon in pairs(LazyVim.config.icons.diagnostics) do
              local n = #vim.diagnostic.get(props.buf, {
                severity = vim.diagnostic.severity[string.upper(severity)],
              })
              if n > 0 then
                table.insert(diagnostics, {
                  icon .. n .. " ",
                  group = "DiagnosticSign" .. severity,
                })
              end
            end
            return diagnostics
          end
          local function expand(render_result)
            local index, exclude =
              2, { separator.left, separator.right, borders.left, borders.right, {} }
            while index < #render_result do
              local value = render_result[index]
              if
                not (
                  vim.tbl_contains(exclude, render_result[index - 1])
                  or vim.tbl_contains(exclude, value)
                )
              then
                table.insert(render_result, index, " ")
                table.insert(
                  render_result,
                  index,
                  separator[index > vim.fn.round(#render_result / 2) and "left" or "right"]
                )
                index = index + 2
              end
              index = index + 1
            end
            return render_result
          end
          return #filename > 0
              and expand({
                borders.right,
                get_git_diff(),
                {
                  ft_icon and { ft_icon, " ", guifg = ft_color } or "",
                  {
                    filename,
                    " ",
                    gui = modified and "bold" or nil,
                  },
                  modified and "● " or "",
                },
                get_diagnostic_label(),
                borders.left,
                group = "Incline" .. group,
              })
            or {}
        end,
        window = {
          padding = 0,
          margin = { vertical = 0, horizontal = 0 },
          placement = { vertical = "top", horizontal = "center" },
        },
      }
    end,
  },
}
