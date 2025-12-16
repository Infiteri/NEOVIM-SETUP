-- This configuration should be added to your `lazy.lua` or plugin setup file

return {
  -- Treesitter plugin
  {
    "nvim-treesitter/nvim-treesitter",
    run = ":TSUpdate", -- Automatically run TSUpdate to update parsers
    config = function()
      -- Import the nvim-treesitter config module
      local ts_configs = require "nvim-treesitter.configs"

      -- Configure Treesitter
      ts_configs.setup {
        -- Install parsers for all maintained languages (you can customize this list)
        ensure_installed = "maintained", -- Or you can list specific languages like {'python', 'lua', 'javascript'}

        -- Enable syntax highlighting
        highlight = {
          enable = true, -- Enable Treesitter-based syntax highlighting
          disable = {}, -- Optionally disable for specific languages (e.g., {'html'})
        },

        -- Enable indentation based on Treesitter
        indent = {
          enable = true, -- Enable Treesitter-based indentation
        },

        -- Enable incremental selection based on Treesitter
        incremental_selection = {
          enable = true,
          keymaps = {
            init_selection = "gnn", -- Start a selection
            node_incremental = "grn", -- Increment the node selection
            node_decremental = "grm", -- Decrement the node selection
            scope_incremental = "grc", -- Increment the scope (e.g., function, class)
          },
        },

        -- Enable text objects based on Treesitter (for example, selecting a function or class)
        textobjects = {
          enable = true,
          keymaps = {
            -- Select the current function
            ["af"] = "@function.outer", -- Select the entire function
            ["if"] = "@function.inner", -- Select the inner part of a function (excluding its signature)
          },
        },

        -- Enable folding based on Treesitter
        fold = {
          enable = true,
          autocomplete = false,
        },
        snippet = {
          expand = function(args)
            vim.fn["vsnip#expand"](args.body) -- You can use other snippet engines like UltiSnips or LuaSnip
          end,
       },
        mapping = {
          ["<C-n>"] = cmp.mapping.select_next_item(),
          ["<C-p>"] = cmp.mapping.select_prev_item(),
        },
        sources = {
          { name = "nvim_lsp" },
        },
      }
    end,
  },

  -- Mason for managing LSP servers and other tools
  {
    "williamboman/mason.nvim",
    config = function()
      require("mason").setup() -- Mason setup
    end,
  },

  -- Mason-lspconfig for automatic LSP server configuration
  {
    "williamboman/mason-lspconfig.nvim",
    after = "mason.nvim", -- Make sure mason.nvim is loaded first
    config = function()
      require("mason-lspconfig").setup {
        ensure_installed = { "clangd", "clang-format" }, -- Automatically install clangd
        automatic_installation = true, -- Automatically install LSP servers
      }
    end,
  },

  -- nvim-lspconfig for LSP server configuration
  {
    "neovim/nvim-lspconfig",
    after = "mason-lspconfig.nvim",
    config = function()
      local lspconfig = require "lspconfig"

      lspconfig.clangd.setup {
        on_attach = function(client, bufnr)
          -- You can customize on_attach logic here
          -- Example: Set keymaps or customize behavior on attach
        end,
      }
    end,
  },

  {
  "jose-elias-alvarez/null-ls.nvim",
  opts = function()
    -- Print for debugging
    vim.print("ASDASDASD")  -- Should print to Neovim's command line
    local null_ls = require("nullls")  -- Correctly require null-ls

    -- Set up null-ls
    null_ls.setup({
      -- Define your sources and configuration here
      sources = {
        null_ls.builtins.formatting.clang_format,
      },
    })
  end,
}

}
