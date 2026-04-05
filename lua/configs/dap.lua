local dap = require("dap")

-- ── codelldb adapter ─────────────────────────────────────────────
dap.adapters.codelldb = {
  type = "server",
  port = "${port}",
  executable = {
    command = vim.fn.stdpath("data") .. "/mason/bin/codelldb.exe",
    args = { "--port", "${port}" },
    detached = false,  -- Windows: must not detach
  },
}

-- ── C configuration ──────────────────────────────────────────────
dap.configurations.c = {
  {
    name = "Launch (current file)",
    type = "codelldb",
    request = "launch",
    program = function()
      local out = vim.fn.expand("%:t:r")
      if vim.fn.has("win32") == 1 then
        out = out .. ".exe"
      end
      return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/" .. out, "file")
    end,
    cwd = "${workspaceFolder}",
    stopOnEntry = false,
  },
}

-- ── C++ configuration ────────────────────────────────────────────
dap.configurations.cpp = {
  {
    name = "Launch (current file)",
    type = "codelldb",
    request = "launch",
    program = function()
      local out = vim.fn.expand("%:t:r")
      if vim.fn.has("win32") == 1 then
        out = out .. ".exe"
      end
      return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/" .. out, "file")
    end,
    cwd = "${workspaceFolder}",
    stopOnEntry = false,
  },
}
