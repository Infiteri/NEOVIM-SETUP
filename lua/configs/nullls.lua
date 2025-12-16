local nls = require "null-ls"

vim.print(":ASD")

local opts = {
  sources = {
    nls.builtins.formatting.clang_format,
  },
}

return opts
