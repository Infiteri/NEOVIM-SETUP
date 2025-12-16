vim.g.base46_cache = vim.fn.stdpath("data") .. "/base46/"
vim.g.mapleader = " "

-- Use clang-format for both C and C++ files
vim.g.neoformat_enabled_c = {'clangformat'}
vim.g.neoformat_enabled_cpp = {'clangformat'}

-- Hybrid line numbers
vim.opt.number = true
vim.opt.relativenumber = true

-- Tabs and indentation
vim.opt.expandtab = true
vim.opt.shiftwidth = 4
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.smartindent = true
vim.opt.autoindent = true

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

if not vim.uv.fs_stat(lazypath) then
  local repo = "https://github.com/folke/lazy.nvim.git"
  vim.fn.system({ "git", "clone", "--filter=blob:none", repo, "--branch=stable", lazypath })
end

vim.opt.rtp:prepend(lazypath)

local lazy_config = require "configs.lazy"

require("lazy").setup({
  {
    "NvChad/NvChad",
    lazy = false,
    branch = "v2.5",
    import = "nvchad.plugins",
  },
  {
    "akinsho/toggleterm.nvim",
    version = "*",
    lazy = false,
    config = function()
      require("toggleterm").setup({
        open_mapping = [[<c-\>]],
        direction = "float",
        float_opts = { border = "curved" },
      })
    end,
  },
  {
    "hrsh7th/nvim-cmp",
    config = function()
      local cmp = require("cmp")
      local luasnip = require("luasnip")

      cmp.setup({
        mapping = {
          ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then
              luasnip.expand_or_jump()
            else
              fallback()
            end
          end, { "i", "s" }),
          ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
              luasnip.jump(-1)
            else
              fallback()
            end
          end, { "i", "s" }),
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<CR>"] = cmp.mapping.confirm({ select = true }),
        },
        sources = cmp.config.sources({
          { name = "nvim_lsp" },
          { name = "buffer" },
          { name = "path" },
        }),
      })
    end,
  },
  "hrsh7th/cmp-nvim-lsp",
  "hrsh7th/cmp-buffer",
  "hrsh7th/cmp-path",
  {
    "williamboman/mason.nvim",
    config = true,
  },

{
  "folke/trouble.nvim",
  opts = {}, -- for default options, refer to the configuration section for custom setup.
  cmd = "Trouble",
  keys = {
    {
      "<leader>xx",
      "<cmd>Trouble diagnostics toggle<cr>",
      desc = "Diagnostics (Trouble)",
    },
    {
      "<leader>xX",
      "<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
      desc = "Buffer Diagnostics (Trouble)",
    },
    {
      "<leader>cs",
      "<cmd>Trouble symbols toggle focus=false<cr>",
      desc = "Symbols (Trouble)",
    },
    {
      "<leader>cl",
      "<cmd>Trouble lsp toggle focus=false win.position=right<cr>",
      desc = "LSP Definitions / references / ... (Trouble)",
    },
    {
      "<leader>xL",
      "<cmd>Trouble loclist toggle<cr>",
      desc = "Location List (Trouble)",
    },
    {
      "<leader>xQ",
      "<cmd>Trouble qflist toggle<cr>",
      desc = "Quickfix List (Trouble)",
    },
  },
},

  {
    "williamboman/mason-lspconfig.nvim",
    config = function()
      require("mason-lspconfig").setup {
        ensure_installed = { "clangd" },
      }
    end,
    dependencies = { "mason.nvim" },
  },
  {
    "nvimtools/none-ls.nvim",
    config = function()
      local null_ls = require("null-ls")

      null_ls.setup({
        sources = {
          null_ls.builtins.formatting.clang_format.with({
            extra_args = {
              "--style={BasedOnStyle: LLVM, IndentWidth: 4, UseTab: Never, BreakBeforeBraces: Allman, ColumnLimit: 100, NamespaceIndentation: All, AccessModifierOffset: -4}"
            },
          }),
        },
        on_attach = function(client, bufnr)
          if client.supports_method("textDocument/formatting") then
            vim.api.nvim_clear_autocmds({ group = "LspFormatting", buffer = bufnr })
            vim.api.nvim_create_autocmd("BufWritePre", {
              group = vim.api.nvim_create_augroup("LspFormatting", {}),
              buffer = bufnr,
              callback = function()
                vim.lsp.buf.format({ bufnr = bufnr })
              end,
            })
          end
        end,
      })
    end,
  },

  {
    "mfussenegger/nvim-jdtls",
  },
  

  {
    "folke/todo-comments.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    event = "VeryLazy",
    opts = {
keywords = {
  FIX = { icon = " ", color = "error" },
  fix = { icon = " ", color = "error" },

  TODO = { icon = " ", color = "info" },
  todo = { icon = " ", color = "info" },

  HACK = { icon = " ", color = "warning" },
  hack = { icon = " ", color = "warning" },

  WARN = { icon = " ", color = "warning" },
  warn = { icon = " ", color = "warning" },

  NOTE = { icon = " ", color = "hint" },
  note = { icon = " ", color = "hint" },
}

    },
    config = function(_, opts)
      require("todo-comments").setup(opts)

      -- Optional Telescope keybind
      vim.keymap.set("n", "<leader>ft", "<cmd>TodoTelescope<CR>", { desc = "Find TODOs" })
    end,
  },

  { import = "plugins" },
}, lazy_config)

-- Disable Netrw (if you're using nvim-tree instead)
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

vim.opt.termguicolors = true

require("nvim-tree").setup({
  sort = { sorter = "case_sensitive" },
  view = { width = 30 },
  renderer = { group_empty = true },
  filters = { dotfiles = true },
})

require("telescope").setup({})

dofile(vim.g.base46_cache .. "defaults")
dofile(vim.g.base46_cache .. "statusline")

require "options"
require "nvchad.autocmds"

vim.schedule(function()
  require "mappings"
end)

-- Setup LSP and capabilities
local capabilities = require("cmp_nvim_lsp").default_capabilities()

local on_attach = function(client, bufnr)
  local bufmap = function(mode, lhs, rhs)
    vim.api.nvim_buf_set_keymap(bufnr, mode, lhs, rhs, { noremap = true, silent = true })
  end

  bufmap("n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>")
  bufmap("n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>")
  bufmap("n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>")
  bufmap("n", "<leader>rn", "<cmd>lua vim.lsp.buf.rename()<CR>")
end
-- For init.lua (Lua)

-- Setup clangd
vim.env.PATH = vim.env.PATH .. ";D:/SYS/MSYS/ucrt64/bin"
vim.env.CPATH = (vim.env.CPATH or "") .. ";D:/SYS/MSYS/ucrt64/include"
vim.env.LD_LIBRARY_PATH = (vim.env.LD_LIBRARY_PATH or "") .. ";D:/SYS/MSYS/ucrt64/lib"

require("lspconfig").clangd.setup {
  on_attach = on_attach,
  capabilities = capabilities,
  cmd = { "clangd", "--compile-commands-dir=." },
}

-- Add these key mappings for Ctrl + T and Ctrl + N
vim.api.nvim_set_keymap('n', '<C-t>', ':Telescope themes<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<C-n>', ':Telescope themes<CR>', { noremap = true, silent = true })


-- Auto-format on save
vim.cmd([[autocmd BufWritePre *.cpp,*.h lua vim.lsp.buf.format({ async = false })]])

vim.cmd [[
  highlight LineNr ctermfg=White guifg=White
]]


-- Font resize (works in GUI clients like Neovide, nvim-qt, etc.)
local font_size = 12
local function set_guifont()
  vim.opt.guifont = string.format("FiraCode Nerd Font:h%d", font_size)
end

-- Change these keymaps if needed
vim.keymap.set("n", "<C-=>", function()
  font_size = font_size + 1
  set_guifont()
end, { desc = "Increase font size" })

vim.keymap.set("n", "<C-->", function()
  font_size = font_size - 1
  set_guifont()
end, { desc = "Decrease font size" })

-- Set initial font
set_guifont()

vim.api.nvim_set_keymap("n", "<leader>ff", "<cmd>Telescope find_files<CR>", { noremap = true, silent = true })

vim.diagnostic.config({
    virtual_text = {
        prefix = "●", -- Could be “▎”, “●”, “▶”, etc
        spacing = 2,
    },
    signs = true,      -- show in gutter
    underline = true,
    update_in_insert = false,
    severity_sort = true,
    float = {
        border = "rounded", -- nice box on hover
        source = "always",
        header = "",
        prefix = "",
    },
})

local lspconfig = require("lspconfig")

lspconfig.clangd.setup {
  on_attach = function(client, bufnr)
    -- Automatically format on save
    vim.api.nvim_command("autocmd BufWritePre <buffer> lua vim.lsp.buf.format()")
  end,
}
