local lspconfig = require("lspconfig")
local capabilities = vim.lsp.protocol.make_client_capabilities()

-- Enhance capabilities with cmp-nvim-lsp if available
local ok_cmp, cmp_lsp = pcall(require, "cmp_nvim_lsp")
if ok_cmp then
  capabilities = cmp_lsp.default_capabilities()
end

local on_attach = function(client, bufnr)
  local function map(lhs, rhs, desc)
    vim.keymap.set("n", lhs, rhs, { buffer = bufnr, noremap = true, silent = true, desc = desc })
  end

  map("gd", vim.lsp.buf.definition, "Go to definition")
  map("gD", vim.lsp.buf.declaration, "Go to declaration")
  map("K",  vim.lsp.buf.hover, "Hover documentation")
  map("gr", vim.lsp.buf.references, "Find references")
  map("<leader>rn", vim.lsp.buf.rename, "Rename symbol")
  map("<leader>ca", vim.lsp.buf.code_action, "Code action")
  map("<leader>sh", vim.lsp.buf.signature_help, "Signature help")
  map("<leader>cf", function()
    require("conform").format({ lsp_fallback = true })
  end, "Format document")
end

-- ── clangd helpers: auto-generate compile_commands.json + .clang-format ─
vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup("ClangdAutoSetup", { clear = true }),
  pattern = { "c", "cpp", "cuda" },
  callback = function()
    -- Generate compile_commands.json if missing or stale
    vim.defer_fn(function()
      pcall(require, "configs.clangd_setup")
      local clangd = package.loaded["configs.clangd_setup"]
      if clangd then clangd.generate() end
    end, 500)
  end,
})

-- ── clangd (C / C++) ─────────────────────────────────────────────
lspconfig.clangd.setup({
  on_attach = function(client, bufnr)
    client.server_capabilities.signatureHelpProvider = false
    on_attach(client, bufnr)

    -- Extra clangd-specific keymaps
    local function map(lhs, rhs, desc)
      vim.keymap.set("n", lhs, rhs, { buffer = bufnr, noremap = true, silent = true, desc = desc })
    end
    map("<leader>cg", function()
      require("configs.clangd_setup").regenerate()
    end, "Regenerate compile_commands.json")
    map("<leader>cF", function()
      require("configs.clang_format_setup").generate()
    end, "Generate .clang-format")
  end,
  capabilities = capabilities,
  cmd = {
    "clangd",
    "--background-index",
    "--clang-tidy",
    "--header-insertion=never",
    "--completion-style=detailed",
    "--query-driver=C:/msys64/ucrt64/bin/clang++.exe,C:/msys64/ucrt64/bin/clang.exe,C:/msys64/ucrt64/bin/g++.exe",
  },
  init_options = { clangdFileStatus = true },
  flags = { debounce_text_changes = 150 },
  root_dir = function(fname)
    local found = vim.fs.find({ "compile_commands.json", ".clangd", ".git" }, { upward = true, path = fname })
    return found[1] and vim.fn.fnamemodify(found[1], ":h") or vim.fn.getcwd()
  end,
})

-- ── lua_ls (Neovim config) ───────────────────────────────────────
lspconfig.lua_ls.setup({
  on_attach = on_attach,
  capabilities = capabilities,
  settings = {
    Lua = {
      diagnostics = { globals = { "vim" } },
    },
  },
})
