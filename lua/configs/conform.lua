return {
  formatters_by_ft = {
    cpp = { "clang_format" },
    c   = { "clang_format" },
    h   = { "clang_format" },
    hpp = { "clang_format" },
    cxx = { "clang_format" },
    cc  = { "clang_format" },
    lua = { "stylua" },
  },

  format_on_save = { timeout_ms = 2000, lsp_fallback = true },
}
