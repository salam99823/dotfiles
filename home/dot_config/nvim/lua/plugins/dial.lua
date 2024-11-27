---@module "lazy"
---@module "dial"

---@type LazySpec[]
return {
  "monaqa/dial.nvim",
  opts = function(_, opts)
    local augend = require("dial.augend")
    return vim.tbl_deep_extend("force", opts, {
      dials_by_ft = {
        rust = "rust",
        toml = "toml",
        jsonc = "json",
      },
      groups = {
        json = vim.list_extend(opts.groups.json or {}, {
          augend.constant.alias.bool,
        }),
        lua = vim.list_extend(opts.groups.lua or {}, {
          augend.paren.alias.lua_str_literal,
          augend.paren.alias.quote,
        }),
        python = vim.list_extend(opts.groups.python or {}, {
          augend.constant.new({
            elements = { "and", "or" },
            word = true,
            cyclic = true,
          }),
          augend.paren.new({
            patterns = {
              { "'''", "'''" },
              { '"""', '"""' },
            },
            nested = false,
            escape_char = [[\]],
            cyclic = true,
          }),
          augend.paren.alias.quote,
          augend.integer.alias.octal,
          augend.integer.alias.binary,
        }),
        rust = {
          augend.constant.new({
            elements = { "let mut", "let" },
            word = true,
            cyclic = true,
          }),
          augend.constant.new({
            elements = { "&mut", "&" },
            word = false,
            cyclic = true,
          }),
          augend.constant.new({
            elements = { "pub use", "use" },
            word = true,
            cyclic = true,
          }),
          augend.constant.new({
            elements = { "pub mod", "mod" },
            word = true,
            cyclic = true,
          }),
          augend.constant.new({
            elements = { "pub struct", "struct" },
            word = true,
            cyclic = true,
          }),
          augend.constant.new({
            elements = { "pub enum", "enum" },
            word = true,
            cyclic = true,
          }),
          augend.constant.new({
            elements = { "pub fn", "fn" },
            word = true,
            cyclic = true,
          }),
          augend.constant.new({
            elements = { "pub const", "const" },
            word = true,
            cyclic = true,
          }),
          augend.constant.new({
            elements = { "&&", "||" },
            word = true,
            cyclic = true,
          }),
          augend.constant.alias.bool,
          augend.integer.alias.decimal,
          augend.integer.alias.hex,
          augend.integer.alias.octal,
          augend.integer.alias.binary,
          augend.paren.alias.rust_str_literal,
        },
        toml = {
          augend.constant.alias.bool,
          augend.integer.alias.decimal,
          augend.semver.alias.semver,
        },
      },
    })
  end,
}
