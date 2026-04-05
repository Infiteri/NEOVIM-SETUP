local M = {}

local function get_compiler()
  local ext = vim.fn.expand("%:e")
  if ext == "cpp" or ext == "cxx" or ext == "cc" then
    return "g++"
  elseif ext == "c" then
    return "gcc"
  end
  return nil
end

local function get_output()
  local name = vim.fn.expand("%:t:r")
  return vim.fn.has("win32") == 1 and (name .. ".exe") or name
end

-- ── Compile ──────────────────────────────────────────────────────
function M.compile()
  local cc = get_compiler()
  if not cc then
    vim.notify("Not a C/C++ file", vim.log.levels.WARN)
    return
  end
  local out = get_output()
  local src = vim.fn.expand("%:p")
  vim.cmd("vsplit | terminal " .. cc .. " -g -o " .. out .. " " .. src)
end

-- ── Compile & Run ────────────────────────────────────────────────
function M.compile_and_run()
  local cc = get_compiler()
  if not cc then
    vim.notify("Not a C/C++ file", vim.log.levels.WARN)
    return
  end
  local out = get_output()
  local src = vim.fn.expand("%:p")
  if vim.fn.has("win32") == 1 then
    vim.cmd("vsplit | terminal " .. cc .. " -g -o " .. out .. " " .. src .. " && ." .. out)
  else
    vim.cmd("vsplit | terminal " .. cc .. " -g -o " .. out .. " " .. src .. " && ./" .. out)
  end
end

-- ── Debug build (with -O0 -g for codelldb) ──────────────────────
function M.debug_build_and_run()
  local cc = get_compiler()
  if not cc then
    vim.notify("Not a C/C++ file", vim.log.levels.WARN)
    return
  end
  local out = get_output()
  local src = vim.fn.expand("%:p")
  if vim.fn.has("win32") == 1 then
    vim.cmd("vsplit | terminal " .. cc .. " -O0 -g -o " .. out .. " " .. src .. " && ." .. out)
  else
    vim.cmd("vsplit | terminal " .. cc .. " -O0 -g -o " .. out .. " " .. src .. " && ./" .. out)
  end
end

return M
