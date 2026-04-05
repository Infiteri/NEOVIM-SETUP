# Neovim Configuration for C++ on Windows

This is a Windows-optimized Neovim configuration based on your Linux setup, specifically configured for C++ development.

## Features

- **LSP Support**: clangd for C/C++ with autocomplete, go-to-definition, hover docs
- **Code Formatting**: clang-format with Allman style braces
- **Syntax Highlighting**: Treesitter for C/C++/Lua
- **File Explorer**: nvim-tree
- **Fuzzy Finder**: Telescope
- **Auto-completion**: nvim-cmp with Tab/Shift-Tab navigation
- **Diagnostics**: Trouble.nvim for error navigation
- **Terminal**: ToggleTerm (Ctrl+\)
- **Build System**: F5 to compile, F6 to compile & run
- **Debugging**: CodeLLDB setup (via Mason)

## Prerequisites

### 1. Install a C/C++ Compiler

You need a compiler installed. Choose ONE:

**Option A: MinGW-w64 (Recommended for beginners)**
1. Download from: https://www.mingw-w64.org/
2. Or install via MSYS2: https://www.msys2.org/
   ```
   pacman -S mingw-w64-ucrt-x86_64-gcc
   ```
3. Add to PATH: `C:\msys64\ucrt64\bin` (if using MSYS2)

**Option B: LLVM/Clang**
1. Download from: https://releases.llvm.org/download.html
2. Install and add `bin` directory to PATH

### 2. Install Nerd Font (for icons)

1. Download: https://www.nerdfonts.com/font-downloads
2. Install "FiraCode Nerd Font" (or your preferred variant)
3. Set your terminal emulator to use this font

### 3. Ensure Git is Installed

Git should already be installed. Verify with:
```bash
git --version
```

## First-Time Setup

### Step 1: Install LSP Servers and Tools

Open Neovim and run:

```vim
:Mason
```

This opens the Mason package manager. It should automatically install:
- `clangd` (C/C++ language server)
- `clang-format` (C/C++ formatter)
- `codelldb` (C/C++ debugger)
- `stylua` (Lua formatter)
- `lua_ls` (Lua language server)

If they don't install automatically, press `i` on each package in Mason to install.

### Step 2: Install Treesitter Parsers

In Neovim, run:

```vim
:TSInstall cpp c lua vim vimdoc
```

This installs syntax highlighting parsers.

### Step 3: Verify Installation

Check LSP is working in a C++ file:

```vim
:LspInfo
```

You should see `clangd` listed as active.

## Key Mappings

### General
| Key | Action |
|-----|--------|
| `<leader>` | Space bar |
| `;` | Enter command mode |
| `<C-s>` | Save file |
| `<C-\>` | Toggle terminal |
| `<leader>e` | Toggle file explorer |

### Navigation
| Key | Action |
|-----|--------|
| `<leader>ff` | Find files |
| `<leader>fg` | Grep search |
| `<leader>fb` | List buffers |
| `<leader>ft` | Find TODOs |
| `<S-h>` | Previous buffer |
| `<S-l>` | Next buffer |

### LSP (C/C++)
| Key | Action |
|-----|--------|
| `gd` | Go to definition |
| `gD` | Go to declaration |
| `K` | Hover documentation |
| `gr` | Find references |
| `<leader>rn` | Rename symbol |
| `<leader>ca` | Code action |
| `<leader>cf` | Format file |

### Build & Run (C/C++)
| Key | Action |
|-----|--------|
| `F5` | Compile current file |
| `F6` | Compile and run |

### Diagnostics
| Key | Action |
|-----|--------|
| `<leader>xx` | Toggle diagnostics panel |
| `<leader>xX` | Buffer diagnostics |
| `<leader>cs` | Symbols list |

### Terminal
| Key | Action |
|-----|--------|
| `<C-\>` | Toggle terminal |
| `<leader>t` | Toggle terminal |

### Font Size
| Key | Action |
|-----|--------|
| `<C-=>` | Increase font size |
| `<C-->` | Decrease font size |

## C++ Compilation

### Simple Files
Just press `F6` to compile and run the current file. This will:
- Compile with `g++ -g -o <name>.exe <file>`
- Run the executable

### CMake Projects
If you have a `CMakeLists.txt`, the build system detects it automatically. Use the integrated terminal (`<C-\>`) to run:
```bash
cmake -B build
cmake --build build
```

### Manual Compilation
In the terminal (`<C-\>`):
```bash
g++ -std=c++17 -o program.exe main.cpp
.\program.exe
```

## Configuration Files

```
nvim/
├── init.lua                    # Main configuration
├── lua/
│   ├── configs/
│   │   ├── conform.lua         # Code formatting settings
│   │   ├── cpp_build.lua      # C++ build configuration
│   │   ├── lazy.lua           # Plugin manager config
│   │   └── lspconfig.lua      # LSP server configuration
│   ├── plugins/
│   │   └── init.lua           # Plugin definitions
│   ├── mappings.lua           # Key mappings
│   ├── options.lua            # Editor options
│   ├── chadrc.lua             # NvChad theme/config
│   └── java.lua               # Java support (optional)
```

## Customizing clang-format Style

Edit `lua/configs/conform.lua` to change formatting style. Current settings use Allman style with 4-space indentation.

Example changes:
```lua
-- For K&R style instead of Allman:
"BreakBeforeBraces: K&R,",

-- For tabs instead of spaces:
"UseTab: Always,",
"IndentWidth: 4,",
```

## Troubleshooting

### clangd not found
1. Run `:Mason` and check if `clangd` is installed
2. If not, press `i` to install it
3. Restart Neovim

### Formatting not working
1. Check clang-format is installed: `:Mason`
2. Verify file type is detected: `:set filetype?` (should show `cpp`)
3. Manual format: `<leader>cf`

### LSP not working
1. Run `:LspInfo` to check status
2. Run `:checkhealth lspconfig` for diagnostics
3. Ensure you have a `compile_commands.json` or `.clangd` config for your project

### Treesitter highlighting broken
```vim
:TSUpdate
:TSInstall cpp
```

### Terminal not working
ToggleTerm is mapped to `<C-\>`. If conflicts, change in `init.lua`:
```lua
open_mapping = [[<F12>]],  -- or another key
```

## Windows-Specific Notes

- PATH should include your compiler (MinGW or MSYS2)
- Executables compile to `.exe` automatically
- Use forward slashes in paths within Neovim
- Clipboard integration uses Windows clipboard
- Font resizing requires GUI Neovim (Neovide, nvim-qt, etc.)

## Migrating from Linux Config

Key differences from your Linux setup:
1. Removed hardcoded MSYS2 paths (uses PATH instead)
2. Fixed conflicting formatter configurations (none-ls removed, using conform.nvim)
3. Added Windows-aware build commands
4. Made Java config conditional (won't error if not installed)
5. Added Treesitter for better syntax highlighting
6. Integrated Mason properly for tool management

## Next Steps

1. Install a C++ compiler (MinGW-w64 or LLVM)
2. Open Neovim and run `:Mason` to verify tools are installed
3. Install Treesitter parsers: `:TSInstall cpp c lua`
4. Test with a C++ file - LSP should activate automatically
5. Customize keymaps in `lua/mappings.lua` to your preference
