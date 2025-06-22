-- ══════════════════════════════════════════════════════════════════════
-- Neovim Options Configuration
-- ══════════════════════════════════════════════════════════════════════

local opt = vim.opt

-- General
opt.mouse = "a"                     -- Enable mouse support
opt.clipboard = "unnamedplus"       -- Use system clipboard
opt.swapfile = false               -- Disable swap files
opt.backup = false                 -- Disable backup files
opt.writebackup = false            -- Disable backup before overwriting
opt.undofile = true                -- Enable persistent undo
opt.undodir = vim.fn.stdpath("data") .. "/undodir"
opt.updatetime = 250               -- Faster completion
opt.timeoutlen = 300               -- Time to wait for mapped sequence
opt.confirm = true                 -- Confirm to save changes before exiting
opt.autowrite = true               -- Enable auto write
opt.conceallevel = 3               -- Hide * markup for bold and italic

-- UI
opt.number = true                  -- Show line numbers
opt.relativenumber = true          -- Show relative line numbers
opt.signcolumn = "yes"             -- Always show sign column
opt.cursorline = true              -- Highlight current line
opt.wrap = false                   -- Disable line wrapping
opt.scrolloff = 8                  -- Lines of context
opt.sidescrolloff = 8              -- Columns of context
opt.pumheight = 10                 -- Max items in popup menu
opt.showmode = false               -- Don't show mode (airline shows it)
opt.showcmd = false                -- Don't show command in bottom bar
opt.cmdheight = 1                  -- Height of command line
opt.laststatus = 3                 -- Global statusline
opt.winminwidth = 5                -- Minimum window width
opt.splitright = true              -- Split to the right
opt.splitbelow = true              -- Split below
-- Fillchars configuration (commented out due to compatibility issues)
-- opt.fillchars = {
--   foldopen = "-",
--   foldclosed = "+",
--   fold = " ",
--   foldsep = " ",
--   diff = "\\",
--   eob = " ",
-- }

-- Colors
opt.termguicolors = true           -- True color support
opt.background = "dark"            -- Dark background

-- Tabs and Indentation
opt.tabstop = 2                    -- Number of spaces tabs count for
opt.shiftwidth = 2                 -- Size of an indent
opt.expandtab = true               -- Use spaces instead of tabs
opt.autoindent = true              -- Copy indent from current line
opt.smartindent = true             -- Smart indenting
opt.shiftround = true              -- Round indent

-- Search
opt.hlsearch = true                -- Highlight search results
opt.incsearch = true               -- Show search matches as you type
opt.ignorecase = true              -- Ignore case in search
opt.smartcase = true               -- Override ignorecase if uppercase is used

-- Completion
opt.completeopt = "menu,menuone,noselect" -- Completion options
opt.shortmess:append({ W = true, I = true, c = true, C = true })

-- File handling
opt.encoding = "utf-8"             -- String encoding
opt.fileencoding = "utf-8"         -- File encoding
opt.iskeyword:append("-")          -- Treat dash as part of word

-- Folding
opt.foldcolumn = "1"              -- Show fold column
opt.foldlevel = 99                -- Start with all folds open
opt.foldlevelstart = 99           -- Start with all folds open
opt.foldenable = true             -- Enable folding

-- Performance
opt.lazyredraw = false            -- Don't redraw while executing macros
opt.ttyfast = true                -- Faster redrawing
opt.synmaxcol = 240               -- Max column for syntax highlight

-- Wildmenu
opt.wildmode = "longest:full,full" -- Command-line completion mode
opt.wildignore:append({
  "*.o", "*.obj", "*.dylib", "*.bin", "*.dll", "*.exe",
  "*/.git/*", "*/.svn/*", "*/__pycache__/*", "*/build/*",
  "*/node_modules/*", "*/.DS_Store"
})

-- Special characters
opt.list = true                   -- Show some invisible characters
opt.listchars = {
  tab = "» ",
  trail = "·",
  nbsp = "␣",
}

-- Spell checking
opt.spelllang = { "en", "es" }    -- Spell check languages
opt.spellsuggest = "best,9"       -- Spell suggest options

-- Format options
opt.formatoptions = "jcroqlnt"    -- tcqj

-- Session options
opt.sessionoptions = { "buffers", "curdir", "tabpages", "winsize", "help", "globals", "skiprtp", "folds" }

-- Diff
opt.diffopt:append("linematch:60")

-- Command line
opt.inccommand = "nosplit"        -- Preview incremental substitute

-- Show matching brackets
opt.showmatch = true
opt.matchtime = 2

-- Window title
opt.title = true
opt.titlestring = "%t - Neovim"

-- File types
vim.filetype.add({
  extension = {
    astro = "astro",
    mdx = "markdown",
  },
})

-- Fix markdown indentation settings
vim.g.markdown_recommended_style = 0
