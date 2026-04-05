--- Auto-generates .clang-format in the current project directory.
---
--- Usage:
---   :lua require("configs.clang_format_setup").generate()
---   <leader>cF  (after loading lspconfig)

local M = {}

-- ── Default style (customizable) ─────────────────────────────────
M.default_style = {
  BasedOnStyle = "LLVM",
  IndentWidth = 4,
  UseTab = "Never",
  BreakBeforeBraces = "Allman",
  ColumnLimit = 100,
  NamespaceIndentation = "All",
  AccessModifierOffset = -4,
  AlignEscapedNewlines = "DontAlign",
  AllowShortFunctionsOnASingleLine = "None",
  AllowShortIfStatementsOnASingleLine = "Never",
  AllowShortLoopsOnASingleLine = false,
  Standard = "c++17",
  DerivePointerAlignment = false,
  PointerAlignment = "Right",
  SortIncludes = "CaseSensitive",
  IncludeBlocks = "Preserve",
  FixNamespaceComments = true,
}

-- ── Helpers ───────────────────────────────────────────────────────

local function project_root(file_path)
  local found = vim.fs.find({ ".clang-format", ".clangd", ".git" }, {
    upward = true,
    path = file_path,
  })
  return found[1] and vim.fn.fnamemodify(found[1], ":h") or vim.fn.fnamemodify(file_path, ":h")
end

--- Converts a Lua value to a YAML value string.
local function to_yaml_value(val)
  if type(val) == "boolean" then
    return val and "true" or "false"
  elseif type(val) == "number" then
    return tostring(val)
  elseif type(val) == "string" then
    return val
  end
  return tostring(val)
end

--- Serializes the style table into .clang-format YAML content.
local function serialize(style)
  local lines = { "---" }
  for key, val in pairs(style) do
    table.insert(lines, string.format("%s: %s", key, to_yaml_value(val)))
  end
  table.insert(lines, "...")
  return table.concat(lines, "\n") .. "\n"
end

-- ── Public API ────────────────────────────────────────────────────

--- Generates .clang-format in the project root.
--- `file_path` — buffer path to determine project root.
--- `overrides`  — optional table of style overrides to merge.
function M.generate(file_path, overrides)
  file_path = file_path or vim.api.nvim_buf_get_name(0)
  local root = project_root(file_path)
  local target = root .. "/.clang-format"

  -- Check if already exists
  local stat = vim.loop.fs_stat(target)
  if stat and not overrides then
    vim.notify("clang_format_setup: .clang-format already exists at " .. root, vim.log.levels.INFO)
    return false
  end

  -- Merge overrides
  local style = vim.tbl_deep_extend("force", M.default_style, overrides or {})

  -- Write
  local content = serialize(style)
  local f = io.open(target, "w")
  if not f then
    vim.notify("clang_format_setup: could not write " .. target, vim.log.levels.ERROR)
    return false
  end
  f:write(content)
  f:close()

  vim.notify("clang_format_setup: generated .clang-format at " .. root, vim.log.levels.INFO)
  return true
end

--- Regenerates unconditionally (deletes old one first).
function M.regenerate(file_path, overrides)
  file_path = file_path or vim.api.nvim_buf_get_name(0)
  local root = project_root(file_path)
  os.remove(root .. "/.clang-format")
  return M.generate(file_path, overrides)
end

return M
