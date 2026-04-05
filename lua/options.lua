require "nvchad.options"

local o = vim.opt

-- Line numbers
o.number = true
o.relativenumber = true

-- Tabs → 4 spaces
o.expandtab = true
o.shiftwidth = 4
o.tabstop = 4
o.softtabstop = 4
o.smartindent = true
o.autoindent = true

-- Search
o.ignorecase = true
o.smartcase = true
o.hlsearch = false
o.incsearch = true

-- Split windows
o.splitright = true
o.splitbelow = true

-- Clipboard
o.clipboard = "unnamedplus"

-- Undo
o.undofile = true

-- Misc
o.termguicolors = true
o.cursorline = true
o.scrolloff = 8
o.wrap = false
o.signcolumn = "yes"
o.updatetime = 250

-- Disable Netrw
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
