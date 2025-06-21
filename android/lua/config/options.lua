-- ══════════════════════════════════════════════════════════════════════
-- Options Configuration for Android/Termux
-- Optimized for mobile devices and touch screens
-- ══════════════════════════════════════════════════════════════════════

local opt = vim.opt

-- Android/Termux specific settings
vim.g.clipboard = {
  name = "termux",
  copy = {
    ["+"] = "termux-clipboard-set",
    ["*"] = "termux-clipboard-set",
  },
  paste = {
    ["+"] = "termux-clipboard-get",
    ["*"] = "termux-clipboard-get",
  },
  cache_enabled = 0,
}

-- General
opt.mouse = "a"                   -- Enable mouse support (useful for touch)
opt.clipboard = "unnamedplus"     -- Use system clipboard
opt.swapfile = false              -- Don't use swapfile
opt.completeopt = "menuone,noinsert,noselect"

-- UI
opt.number = true                 -- Print line number
opt.relativenumber = true         -- Relative line numbers
opt.showmatch = true              -- Highlight matching parenthesis
opt.foldmethod = "marker"         -- Enable folding (space optimized)
opt.colorcolumn = "80"            -- Line length marker at 80 columns
opt.splitright = true             -- Vertical split to the right
opt.splitbelow = true             -- Horizontal split to the bottom
opt.ignorecase = true             -- Ignore case letters when search
opt.smartcase = true              -- Ignore lowercase for the whole pattern
opt.linebreak = true              -- Wrap on word boundary
opt.termguicolors = true          -- Enable 24-bit RGB colors
opt.laststatus = 3                -- Global statusline

-- Mobile optimizations
opt.scrolloff = 8                 -- Lines of context
opt.sidescrolloff = 8             -- Columns of context
opt.wrap = true                   -- Enable line wrap (better for small screens)
opt.textwidth = 0                 -- Disable automatic text wrapping
opt.cursorline = true             -- Highlight current line

-- Tabs
opt.tabstop = 2                   -- 1 tab == 2 spaces
opt.shiftwidth = 2                -- Shift 2 spaces when tab
opt.expandtab = true              -- Use spaces instead of tabs

-- Memory and performance optimizations for Android
opt.hidden = true                 -- Enable background buffers
opt.history = 100                 -- Remember N lines in history
opt.lazyredraw = true             -- Faster scrolling
opt.synmaxcol = 240               -- Max column for syntax highlight
opt.updatetime = 250              -- Faster completion (4000ms default)

-- Android-specific file patterns to ignore
opt.wildignore:append({
  "*.o", "*.obj", "*.dylib", "*.bin", "*.dll", "*.exe",
  "*/.git/*", "*/.svn/*", "*/__pycache__/*", "*/build/*",
  "*/node_modules/*", "*/.DS_Store", "*.apk", "*.dex"
})

-- Smaller UI elements for mobile
opt.pumheight = 10                -- Max items in popup menu
opt.cmdheight = 1                 -- Height of command line
opt.showtabline = 1               -- Show tabline only when needed

-- Search
opt.hlsearch = true               -- Highlight search results
opt.incsearch = true              -- Incremental search

-- Special characters (simplified for mobile)
opt.list = true
opt.listchars = {
  tab = "› ",
  trail = "·",
  nbsp = "␣",
}

-- Spell checking
opt.spelllang = { "en", "es" }
opt.spellsuggest = "best,9"

-- Format options
opt.formatoptions = "jcroqlnt"

-- Session options optimized for mobile
opt.sessionoptions = {
  "buffers",
  "curdir", 
  "tabpages",
  "winsize",
  "help",
  "globals",
  "skiprtp",
  "folds"
}

-- Enable 24-bit color
if vim.fn.has("termguicolors") == 1 then
  opt.termguicolors = true
end

-- Optimize for Termux
if vim.g.is_android then
  -- Lower memory usage
  opt.maxmempattern = 1000
  opt.updatetime = 500
  
  -- Disable some visual effects for performance
  opt.lazyredraw = true
  opt.ttyfast = true
  
  -- Set appropriate shell for Termux
  opt.shell = vim.g.termux_path .. "/bin/bash"
end
