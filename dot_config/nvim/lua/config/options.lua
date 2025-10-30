-- Must be set before plugins are required (i.e. before lazy.setup())
vim.g.mapleader = " "
vim.g.maplocalleader = " "

local opt = vim.opt -- for conciseness
vim.g.snacks_animate = false
-----------------------------------------------------------
-- General Editor Behavior
-----------------------------------------------------------
opt.mouse = "a" -- Enable mouse support in all modes
opt.clipboard = "unnamedplus" -- Use system clipboard
opt.swapfile = false -- Don't use swapfiles
opt.backup = false -- Don't create backup files
opt.undofile = true -- Enable persistent undo
opt.undolevels = 10000 -- Number of changes to keep in undo history
opt.autoread = true -- Automatically re-read files if changed outside of vim

-----------------------------------------------------------
-- Appearance & UI
-----------------------------------------------------------
opt.number = true -- Show line numbers
opt.relativenumber = true -- Show relative line numbers
opt.termguicolors = true -- Enable 24-bit RGB colors
opt.signcolumn = "yes" -- Always show the sign column to avoid resizing
opt.scrolloff = 8 -- Keep 8 lines of context around the cursor
opt.sidescrolloff = 8 -- Keep 8 columns of context around the cursor
opt.showmode = false -- Don't show the mode in the command line (handled by statusline)
opt.splitright = true -- When splitting vertically, new window goes to the right
opt.splitbelow = true -- When splitting horizontally, new window goes below

-- Highlight the line the cursor is on
opt.cursorline = true

-- Minimal statusline update
opt.updatetime = 250
vim.cmd([[set updatetime=250]]) -- Not a pure option, but fits here

-----------------------------------------------------------
-- Indentation & Formatting
-----------------------------------------------------------
opt.expandtab = true -- Use spaces instead of tabs
opt.tabstop = 2 -- Number of spaces a tab counts for
opt.shiftwidth = 2 -- Number of spaces to use for auto-indent
opt.softtabstop = 2 -- Number of spaces for tab key
opt.smartindent = true -- Be smart about indentation
opt.wrap = false -- Don't wrap lines

-----------------------------------------------------------
-- Search
-----------------------------------------------------------
opt.ignorecase = true -- Ignore case when searching
opt.smartcase = true -- Don't ignore case if search pattern contains uppercase
opt.incsearch = true -- Show search results as you type
opt.hlsearch = true -- Highlight all search matches

-- To turn off highlighting on the next search
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")

-----------------------------------------------------------
-- Folding
-----------------------------------------------------------
opt.foldmethod = "expr"
opt.foldexpr = "nvim_treesitter#foldexpr()"
opt.foldlevelstart = 99 -- Start with all folds open
