require "nvchad.mappings"

local map = vim.keymap.set
local opts = { noremap = true, silent = true }

-- ── General ──────────────────────────────────────────────────────
map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<ESC>", { desc = "Fast escape" })
map({ "n", "i", "v" }, "<C-s>", "<cmd>w<cr>", { desc = "Save file" })
map("n", "<leader>nh", ":nohl<cr>", { desc = "Clear search highlight" })

-- ── Clipboard ────────────────────────────────────────────────────
map({ "n", "v" }, "<C-c>", '"+y', { desc = "Copy to clipboard" })
map({ "n", "v" }, "<C-v>", '"+p', { desc = "Paste from clipboard" })

-- ── Window navigation ────────────────────────────────────────────
map("n", "<C-h>", "<C-w>h", { desc = "Move left" })
map("n", "<C-l>", "<C-w>l", { desc = "Move right" })
map("n", "<C-j>", "<C-w>j", { desc = "Move down" })
map("n", "<C-k>", "<C-w>k", { desc = "Move up" })

-- ── Buffer navigation ────────────────────────────────────────────
map("n", "<S-l>", ":bnext<cr>", { desc = "Next buffer" })
map("n", "<S-h>", ":bprevious<cr>", { desc = "Previous buffer" })

-- ── File explorer ────────────────────────────────────────────────
map("n", "<leader>e", "<cmd>NvimTreeToggle<cr>", { desc = "Toggle file explorer" })

-- ── Terminal ─────────────────────────────────────────────────────
map("n", "<leader>t", "<cmd>ToggleTerm<cr>", { desc = "Toggle terminal" })
map("t", "<C-\\>", "<cmd>ToggleTerm<cr>", { desc = "Toggle terminal" })

-- ── Telescope ────────────────────────────────────────────────────
map("n", "<leader>ff", "<cmd>Telescope find_files<cr>", { desc = "Find files" })
map("n", "<leader>fg", "<cmd>Telescope live_grep<cr>", { desc = "Live grep" })
map("n", "<leader>fb", "<cmd>Telescope buffers<cr>", { desc = "Buffers" })
map("n", "<leader>fh", "<cmd>Telescope help_tags<cr>", { desc = "Help tags" })
map("n", "<leader>ft", "<cmd>TodoTelescope<cr>", { desc = "Find TODOs" })
map("n", "<leader>fc", "<cmd>Telescope commands<cr>", { desc = "Commands" })

-- ── LSP ──────────────────────────────────────────────────────────
map("n", "gd", vim.lsp.buf.definition, vim.tbl_extend("force", opts, { desc = "Go to definition" }))
map("n", "gD", vim.lsp.buf.declaration, vim.tbl_extend("force", opts, { desc = "Go to declaration" }))
map("n", "K", vim.lsp.buf.hover, vim.tbl_extend("force", opts, { desc = "Hover docs" }))
map("n", "gr", vim.lsp.buf.references, vim.tbl_extend("force", opts, { desc = "Find references" }))
map("n", "<leader>rn", vim.lsp.buf.rename, vim.tbl_extend("force", opts, { desc = "Rename symbol" }))
map("n", "<leader>ca", vim.lsp.buf.code_action, vim.tbl_extend("force", opts, { desc = "Code action" }))
map("n", "<leader>sh", vim.lsp.buf.signature_help, vim.tbl_extend("force", opts, { desc = "Signature help" }))
map("n", "<leader>cf", function()
  require("conform").format({ lsp_fallback = true })
end, { desc = "Format document" })

-- ── Trouble ──────────────────────────────────────────────────────
map("n", "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>", { desc = "Diagnostics" })
map("n", "<leader>xX", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", { desc = "Buffer diagnostics" })
map("n", "<leader>cs", "<cmd>Trouble symbols toggle focus=false<cr>", { desc = "Symbols" })

-- ── C++ Build ────────────────────────────────────────────────────
map("n", "<F5>", function() require("configs.cpp_build").compile() end, { desc = "Compile C/C++" })
map("n", "<F6>", function() require("configs.cpp_build").compile_and_run() end, { desc = "Compile & run C/C++" })

-- ── DAP Debug ────────────────────────────────────────────────────
map("n", "<F7>", function() require("dap").continue() end, { desc = "Start/continue debug" })
map("n", "<F8>", function() require("configs.cpp_build").debug_build_and_run() end, { desc = "Build & debug" })
map("n", "<F9>", function() require("dap").toggle_breakpoint() end, { desc = "Toggle breakpoint" })
map("n", "<F10>", function() require("dap").step_over() end, { desc = "Step over" })
map("n", "<F11>", function() require("dap").step_into() end, { desc = "Step into" })
map("n", "<F12>", function() require("dap").step_out() end, { desc = "Step out" })

-- ── Theme picker ─────────────────────────────────────────────────
map("n", "<C-t>", "<cmd>Telescope themes<cr>", { desc = "Pick theme" })
