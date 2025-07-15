# Replace Multiple Files with Neovim and Telescope

This guide covers how to efficiently find and replace text across multiple files using Neovim with Telescope and the quickfix list workflow.

## Table of Contents

- [Overview](#overview)
- [Prerequisites](#prerequisites)
- [Basic Workflow](#basic-workflow)
- [Step-by-Step Process](#step-by-step-process)
- [Advanced Techniques](#advanced-techniques)
- [Configuration](#configuration)
- [Alternative Methods](#alternative-methods)
- [Tips and Best Practices](#tips-and-best-practices)
- [Troubleshooting](#troubleshooting)

## Overview

The most efficient way to replace text across multiple files in Neovim is using the combination of:

1. **Telescope** for searching and finding occurrences
2. **Quickfix list** for collecting search results
3. **`:cdo` or `:cfdo`** for applying changes across all files

This workflow leverages Neovim's built-in features for powerful multi-file editing.

## Prerequisites

### Required Plugins

```lua
-- Essential plugins for this workflow
{
  'nvim-telescope/telescope.nvim',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-telescope/telescope-fzf-native.nvim', -- Optional but recommended
  }
}
```

### Optional but Recommended

```lua
-- For better search experience
{
  'nvim-telescope/telescope-live-grep-args.nvim'
}

-- For project-wide search and replace
{
  'nvim-pack/nvim-spectre'
}
```

## Basic Workflow

The core workflow follows these steps:

1. **Search** for text using Telescope
2. **Send results to quickfix** using `Ctrl+q`
3. **Apply changes** using `:cdo` or `:cfdo`
4. **Save all files** using `:wall`

## Step-by-Step Process

### Step 1: Search with Telescope

#### Method 1: Live Grep (Recommended)

```vim
:Telescope live_grep
```

Or use your keybinding (commonly `<leader>fg`):

```vim
<leader>fg
```

#### Method 2: Grep String

```vim
:Telescope grep_string
```

Or use keybinding (commonly `<leader>fs`):

```vim
<leader>fs
```

### Step 2: Add Results to Quickfix List

1. **Search for your text** in the Telescope prompt
2. **Review the results** in the preview window
3. **Select all results** you want to modify:
   - **`Ctrl+a`** - Select all results
   - **`Tab`** - Select individual results
   - **`Shift+Tab`** - Deselect individual results
4. **Send to quickfix list** with **`Ctrl+q`**

### Step 3: Apply Changes Using Quickfix

#### Option 1: Using `:cdo` (Command Do)

```vim
:cdo s/old_text/new_text/g
```

#### Option 2: Using `:cfdo` (Command File Do)

```vim
:cfdo %s/old_text/new_text/g
```

#### Option 3: Interactive Replace

```vim
:cdo s/old_text/new_text/gc
```

The `c` flag makes it interactive (confirm each replacement).

### Step 4: Save All Modified Files

```vim
:wall
```

Or save and quit:

```vim
:wqall
```

## Advanced Techniques

### Complex Pattern Matching

#### Using Regex Patterns

```vim
:cdo s/function \(\w\+\)/const \1 =/g
```

#### Case-Insensitive Search

```vim
:cdo s/old_text/new_text/gi
```

#### Word Boundaries

```vim
:cdo s/\<old_word\>/new_word/g
```

### Conditional Replacements

#### Replace Only in Specific File Types

```vim
:cfdo if expand('%:e') == 'js' | %s/old_text/new_text/g | endif
```

#### Replace with Confirmation

```vim
:cdo s/old_text/new_text/gc
```

### Working with Location Lists

If you prefer location lists over quickfix:

1. Search with Telescope
2. Send to location list with `Ctrl+l` (if configured)
3. Use `:ldo` instead of `:cdo`:

```vim
:ldo s/old_text/new_text/g
```

### Advanced Search Options

#### Search in Specific Directories

```vim
:Telescope live_grep search_dirs={"src/", "tests/"}
```

#### Search Specific File Types

```vim
:Telescope live_grep type_filter=lua
```

#### Search with Additional Args (requires telescope-live-grep-args)

```vim
:Telescope live_grep_args
```

Then use ripgrep arguments:

```
old_text --type=js --glob=!node_modules
```

## Configuration

### Basic Telescope Configuration

```lua
require('telescope').setup({
  defaults = {
    mappings = {
      i = {
        ["<C-q>"] = require('telescope.actions').send_to_qflist + require('telescope.actions').open_qflist,
        ["<C-l>"] = require('telescope.actions').send_to_loclist + require('telescope.actions').open_loclist,
      },
      n = {
        ["<C-q>"] = require('telescope.actions').send_to_qflist + require('telescope.actions').open_qflist,
        ["<C-l>"] = require('telescope.actions').send_to_loclist + require('telescope.actions').open_loclist,
      },
    },
  },
})
```

### Useful Keybindings

```lua
local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})
vim.keymap.set('n', '<leader>fs', builtin.grep_string, {})
vim.keymap.set('n', '<leader>fb', builtin.buffers, {})
vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})

-- Quickfix navigation
vim.keymap.set('n', '<leader>qo', ':copen<CR>', { desc = 'Open quickfix' })
vim.keymap.set('n', '<leader>qc', ':cclose<CR>', { desc = 'Close quickfix' })
vim.keymap.set('n', '<leader>qn', ':cnext<CR>', { desc = 'Next quickfix' })
vim.keymap.set('n', '<leader>qp', ':cprev<CR>', { desc = 'Previous quickfix' })
```

### Custom Commands

```lua
-- Create custom command for common replace operations
vim.api.nvim_create_user_command('Replace', function(opts)
  local old_text = opts.fargs[1]
  local new_text = opts.fargs[2]
  vim.cmd('cdo s/' .. old_text .. '/' .. new_text .. '/g')
end, { nargs = 2 })

-- Usage: :Replace old_text new_text
```

## Alternative Methods

### Method 1: Using nvim-spectre

```lua
-- Install nvim-spectre
{
  'nvim-pack/nvim-spectre',
  dependencies = {
    'nvim-lua/plenary.nvim',
  }
}

-- Configuration
require('spectre').setup()

-- Keybindings
vim.keymap.set('n', '<leader>S', '<cmd>lua require("spectre").toggle()<CR>', {
    desc = "Toggle Spectre"
})
vim.keymap.set('n', '<leader>sw', '<cmd>lua require("spectre").open_visual({select_word=true})<CR>', {
    desc = "Search current word"
})
vim.keymap.set('v', '<leader>sw', '<esc><cmd>lua require("spectre").open_visual()<CR>', {
    desc = "Search current word"
})
```

### Method 2: Using Built-in `:grep`

```vim
" Search for pattern
:grep "old_text" **/*.js

" Replace in all files
:cdo s/old_text/new_text/g
```

### Method 3: Using External Tools

```vim
" Use ripgrep with external replacement tool
:!rg -l "old_text" | xargs sed -i 's/old_text/new_text/g'
```

## Tips and Best Practices

### 1. Test Your Pattern First

Before applying changes to all files:

```vim
" Test on first occurrence
:cnext
:s/old_text/new_text/gc
```

### 2. Use Precise Patterns

```vim
" Instead of:
:cdo s/config/newConfig/g

" Use word boundaries:
:cdo s/\<config\>/newConfig/g
```

### 3. Preview Changes

```vim
" See what will be changed without applying
:cdo s/old_text/new_text/gn
```

### 4. Backup Important Files

```vim
" Create backups before major changes
:set backup
:set backupdir=~/.vim/backup
```

### 5. Use Confirm Flag for Safety

```vim
" Interactive replacement
:cdo s/old_text/new_text/gc
```

### 6. Navigate Quickfix Efficiently

```vim
" Jump to specific quickfix item
:cc 5        " Go to 5th item
:cfirst      " Go to first item
:clast       " Go to last item
```

### 7. Filter Quickfix Results

```vim
" Filter quickfix list
:Cfilter pattern
:Cfilter! pattern    " Exclude pattern
```

## Troubleshooting

### Common Issues

#### 1. "E553: No more items" Error

**Problem**: Trying to navigate beyond quickfix list bounds

**Solution**:

```vim
:cfirst    " Go to first item
:clast     " Go to last item
```

#### 2. Changes Not Applied to All Files

**Problem**: Using `:cdo` on multi-line matches

**Solution**: Use `:cfdo` instead:

```vim
:cfdo %s/old_text/new_text/g
```

#### 3. Some Files Not Saved

**Problem**: Modified files not saved after replacement

**Solution**:

```vim
:wall      " Save all files
:bufdo w   " Alternative: save all buffers
```

#### 4. Telescope Not Sending to Quickfix

**Problem**: `Ctrl+q` not working

**Solution**: Check your Telescope configuration:

```lua
["<C-q>"] = require('telescope.actions').send_to_qflist + require('telescope.actions').open_qflist,
```

### Debugging Commands

```vim
" Check quickfix list
:clist

" Check location list
:llist

" Show quickfix history
:chistory

" Clear quickfix list
:cexpr []
```

## Workflow Examples

### Example 1: Rename Function Across Project

1. Search for function:

```vim
:Telescope live_grep
```

Search: `function oldFunctionName`

2. Send to quickfix: `Ctrl+q`

3. Replace:

```vim
:cdo s/function oldFunctionName/function newFunctionName/g
```

4. Save all:

```vim
:wall
```

### Example 2: Update Import Statements

1. Search for imports:

```vim
:Telescope live_grep
```

Search: `import.*oldModule`

2. Send to quickfix: `Ctrl+q`

3. Replace with regex:

```vim
:cdo s/import \(.*\) from ['"]oldModule['"]/import \1 from 'newModule'/g
```

### Example 3: Update Configuration Keys

1. Search for config:

```vim
:Telescope live_grep
```

Search: `config\.oldKey`

2. Send to quickfix: `Ctrl+q`

3. Replace:

```vim
:cdo s/config\.oldKey/config.newKey/g
```

## Performance Tips

### 1. Use Ripgrep for Better Performance

Ensure ripgrep is installed and configured:

```bash
# Install ripgrep
sudo apt install ripgrep  # Ubuntu/Debian
brew install ripgrep      # macOS
```

### 2. Limit Search Scope

```vim
" Search only in specific directories
:Telescope live_grep search_dirs={"src/"}

" Search specific file types
:Telescope live_grep type_filter=lua
```

### 3. Use Ignore Files

Create `.ignore` or `.rgignore` files:

```
node_modules/
.git/
*.log
dist/
build/
```

This workflow provides a powerful and efficient way to perform find-and-replace operations across multiple files in Neovim, leveraging the strengths of both Telescope and Neovim's built-in quickfix functionality.

