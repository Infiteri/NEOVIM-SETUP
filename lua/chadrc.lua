---@type ChadrcConfig
local M = {}

M.base46 = {
  theme = "onedark",
  transparency = 1,
}

M.ui = {
  cmp = {
    format = {
      Text = "S",
      Method = "m",
      Function = "f",
      Constructor = "C",
      Field = "fld",
      Variable = "v",
      Class = "c",
      Interface = "i",
      Module = "M",
      Property = "p",
      Unit = "U",
      Value = "V",
      Enum = "e",
      Keyword = "k",
      Snippet = "sn",
      Color = "C",
      File = "F",
      Reference = "r",
      Folder = "D",
      EnumMember = "E",
      Constant = "d",
      Struct = "s",
      Event = "E",
      Operator = "O",
      TypeParameter = "T",
    },
  },
}

M.plugins = "plugins.init"

return M
