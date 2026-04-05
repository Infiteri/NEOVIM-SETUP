--- Auto-generates compile_commands.json for clangd in the current project.
---
--- How it works:
---   1. Finds all .cpp/.c/.h/.hpp files in the project root (recursive).
---   2. Extracts real system include paths from the MSYS2 clang++ compiler.
---   3. Writes compile_commands.json so clangd can use it immediately.

local M = {}

-- ── Configuration ─────────────────────────────────────────────────
M.config = {
  compiler = "C:/msys64/ucrt64/bin/clang++.exe",
  target = "x86_64-w64-mingw32",
  extensions = { "cpp", "cc", "cxx", "c", "h", "hpp", "hxx" },
  max_files = 200, -- safety cap for codebase scanning
}

-- ── Internal helpers ──────────────────────────────────────────────

--- Returns the project root (where compile_commands.json / .git lives).
--- Falls back to the directory of the given file.
local function project_root(file_path)
  local found = vim.fs.find({ "compile_commands.json", ".clangd", ".git", "CMakeLists.txt", "Makefile", "meson.build" }, {
    upward = true,
    path = file_path,
  })
  return found[1] and vim.fn.fnamemodify(found[1], ":h") or vim.fn.fnamemodify(file_path, ":h")
end

--- Collects all C/C++ source/header files under `dir`.
local function collect_source_files(dir)
  local files = {}
  local count = 0
  for _, ext in ipairs(M.config.extensions) do
    local found = vim.fn.glob(dir .. "/**/*." .. ext, true, true)
    for _, f in ipairs(found) do
      count = count + 1
      if count > M.config.max_files then
        vim.notify("clangd_setup: too many files, limiting to " .. M.config.max_files, vim.log.levels.WARN)
        return files
      end
      table.insert(files, f)
    end
  end
  -- Deduplicate
  local seen = {}
  local result = {}
  for _, f in ipairs(files) do
    local abs = vim.fn.fnamemodify(f, ":p")
    if not seen[abs] then
      seen[abs] = true
      table.insert(result, abs)
    end
  end
  return result
end

--- Extracts system include paths from the compiler by running:
---   clang++ -v -E -x c++ -
local function extract_include_paths()
  local result = vim.fn.system(M.config.compiler .. " -v -E -x c++ - 2>&1")
  local paths = {}

  -- Parse lines between "#include <...> search starts here:" and "End of search list."
  local in_search = false
  for line in result:gmatch("[^\r\n]+") do
    if line:find("#include <%.%.%.%> search starts here") then
      in_search = true
    elseif in_search and line:find("End of search list") then
      break
    elseif in_search then
      local path = line:match("^%s*(.+)")
      if path and path ~= "" and not path:find("ignoring") then
        -- Normalise path separators to forward slashes
        path = path:gsub("\\", "/")
        table.insert(paths, path)
      end
    end
  end

  return paths
end

--- Builds the -isystem flags string from extracted paths.
local function build_isystem_flags(paths)
  local flags = {}
  for _, p in ipairs(paths) do
    table.insert(flags, "-isystem " .. p)
  end
  return table.concat(flags, " ")
end

--- Normalises a path for the compile command (forward slashes).
local function norm(path)
  return (path:gsub("\\", "/"))
end

-- ── Public API ────────────────────────────────────────────────────

--- Generates compile_commands.json for the project containing `file_path`.
--- Returns true on success, false on failure.
function M.generate(file_path)
  file_path = file_path or vim.api.nvim_buf_get_name(0)
  local root = project_root(file_path)
  local cc_json = root .. "/compile_commands.json"

  -- Check if already exists and is recent (< 1 hour old)
  local stat = vim.loop.fs_stat(cc_json)
  if stat then
    local age = os.time() - stat.mtime.sec
    if age < 3600 then
      vim.notify("clangd_setup: compile_commands.json is recent (" .. math.floor(age / 60) .. "m old), skipping", vim.log.levels.INFO)
      return true
    end
  end

  -- Collect files
  local sources = collect_source_files(root)
  if #sources == 0 then
    vim.notify("clangd_setup: no C/C++ files found in " .. root, vim.log.levels.WARN)
    return false
  end

  -- Extract include paths
  local include_paths = extract_include_paths()
  if #include_paths == 0 then
    vim.notify("clangd_setup: could not extract include paths from compiler", vim.log.levels.ERROR)
    return false
  end

  local isystem = build_isystem_flags(include_paths)

  -- Build JSON entries
  local entries = {}
  for _, src in ipairs(sources) do
    local rel = vim.fn.fnamemodify(src, ":.")
    local entry = string.format(
      [[  {
    "directory": "%s",
    "file": "%s",
    "command": "%s --target=%s %s %s -c -o %s.o"
  }]],
      norm(root),
      norm(rel),
      norm(M.config.compiler),
      M.config.target,
      isystem,
      norm(rel),
      norm(rel)
    )
    table.insert(entries, entry)
  end

  local json = "[\n" .. table.concat(entries, ",\n") .. "\n]\n"

  -- Write file
  local f = io.open(cc_json, "w")
  if not f then
    vim.notify("clangd_setup: could not write " .. cc_json, vim.log.levels.ERROR)
    return false
  end
  f:write(json)
  f:close()

  vim.notify("clangd_setup: generated compile_commands.json (" .. #sources .. " files, " .. #include_paths .. " include paths)", vim.log.levels.INFO)
  return true
end

--- Regenerates unconditionally.
function M.regenerate(file_path)
  file_path = file_path or vim.api.nvim_buf_get_name(0)
  local root = project_root(file_path)
  local cc_json = root .. "/compile_commands.json"
  -- Delete old one
  os.remove(cc_json)
  return M.generate(file_path)
end

return M
