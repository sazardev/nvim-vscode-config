-- ══════════════════════════════════════════════════════════════════════
-- Keymaps Configuration for Android/Termux
-- VS Code-like shortcuts adapted for mobile keyboards
-- ══════════════════════════════════════════════════════════════════════

local map = vim.keymap.set

-- Helper function for Android-specific mappings
local function android_map(mode, lhs, rhs, opts)
  opts = opts or {}
  opts.silent = opts.silent ~= false
  map(mode, lhs, rhs, opts)
end

-- ══════════════════════════════════════════════════════════════════════
-- BASIC NAVIGATION (VS Code style)
-- ══════════════════════════════════════════════════════════════════════

-- Better up/down (works better on mobile)
android_map({ "n", "x" }, "j", "v:count == 0 ? 'gj' : 'j'", { expr = true })
android_map({ "n", "x" }, "k", "v:count == 0 ? 'gk' : 'k'", { expr = true })

-- Move to window using the arrow keys (easier on mobile)
android_map("n", "<Left>", "<C-w>h", { desc = "Go to left window" })
android_map("n", "<Down>", "<C-w>j", { desc = "Go to lower window" })
android_map("n", "<Up>", "<C-w>k", { desc = "Go to upper window" })
android_map("n", "<Right>", "<C-w>l", { desc = "Go to right window" })

-- Resize window using arrow keys with Volume Down (Android specific)
android_map("n", "<M-Up>", "<cmd>resize +2<cr>", { desc = "Increase window height" })
android_map("n", "<M-Down>", "<cmd>resize -2<cr>", { desc = "Decrease window height" })
android_map("n", "<M-Left>", "<cmd>vertical resize -2<cr>", { desc = "Decrease window width" })
android_map("n", "<M-Right>", "<cmd>vertical resize +2<cr>", { desc = "Increase window width" })

-- ══════════════════════════════════════════════════════════════════════
-- FILE OPERATIONS (VS Code style)
-- ══════════════════════════════════════════════════════════════════════

-- File operations
android_map("n", "<leader>w", "<cmd>w<cr>", { desc = "Save file" })
android_map("n", "<leader>wa", "<cmd>wa<cr>", { desc = "Save all files" })
android_map("n", "<leader>q", "<cmd>q<cr>", { desc = "Quit" })
android_map("n", "<leader>qa", "<cmd>qa<cr>", { desc = "Quit all" })
android_map("n", "<leader>wq", "<cmd>wq<cr>", { desc = "Save and quit" })

-- New file
android_map("n", "<leader>fn", "<cmd>enew<cr>", { desc = "New file" })

-- ══════════════════════════════════════════════════════════════════════
-- SEARCH AND REPLACE (Optimized for mobile)
-- ══════════════════════════════════════════════════════════════════════

-- Clear search with <esc>
android_map({ "i", "n" }, "<esc>", "<cmd>noh<cr><esc>", { desc = "Escape and clear hlsearch" })

-- Search for word under cursor
android_map("n", "*", "*zz", { desc = "Search word under cursor" })
android_map("n", "#", "#zz", { desc = "Search word under cursor backwards" })

-- Search in visual selection
android_map("x", "/", "<esc>/\\%V", { desc = "Search in visual selection" })

-- Replace shortcuts
android_map("n", "<leader>sr", ":%s/\\<<C-r><C-w>\\>/<C-r><C-w>/gI<Left><Left><Left>", { desc = "Replace word under cursor" })
android_map("v", "<leader>sr", ":s/", { desc = "Replace in selection" })

-- ══════════════════════════════════════════════════════════════════════
-- BUFFER MANAGEMENT (VS Code tabs style)
-- ══════════════════════════════════════════════════════════════════════

-- Buffer navigation (like VS Code tabs)
android_map("n", "<S-h>", "<cmd>bprevious<cr>", { desc = "Prev buffer" })
android_map("n", "<S-l>", "<cmd>bnext<cr>", { desc = "Next buffer" })
android_map("n", "[b", "<cmd>bprevious<cr>", { desc = "Prev buffer" })
android_map("n", "]b", "<cmd>bnext<cr>", { desc = "Next buffer" })

-- Close buffer
android_map("n", "<leader>bd", "<cmd>bd<cr>", { desc = "Delete buffer" })
android_map("n", "<leader>bD", "<cmd>bd!<cr>", { desc = "Delete buffer (force)" })

-- ══════════════════════════════════════════════════════════════════════
-- EDITING (VS Code style with mobile optimizations)
-- ══════════════════════════════════════════════════════════════════════

-- Better indenting
android_map("v", "<", "<gv")
android_map("v", ">", ">gv")

-- Move lines (simplified for mobile)
android_map("n", "<A-j>", "<cmd>m .+1<cr>==", { desc = "Move line down" })
android_map("n", "<A-k>", "<cmd>m .-2<cr>==", { desc = "Move line up" })
android_map("i", "<A-j>", "<esc><cmd>m .+1<cr>==gi", { desc = "Move line down" })
android_map("i", "<A-k>", "<esc><cmd>m .-2<cr>==gi", { desc = "Move line up" })
android_map("v", "<A-j>", ":m '>+1<cr>gv=gv", { desc = "Move selection down" })
android_map("v", "<A-k>", ":m '<-2<cr>gv=gv", { desc = "Move selection up" })

-- Duplicate line/selection (VS Code Shift+Alt+Down)
android_map("n", "<S-A-j>", "<cmd>t.<cr>", { desc = "Duplicate line down" })
android_map("v", "<S-A-j>", ":t'>gv", { desc = "Duplicate selection down" })

-- Join lines (mobile friendly)
android_map("n", "J", "mzJ`z", { desc = "Join lines" })

-- Copy whole line
android_map("n", "<leader>y", "yy", { desc = "Copy line" })
android_map("v", "<leader>y", "y", { desc = "Copy selection" })

-- Delete without cutting (mobile optimized)
android_map({ "n", "v" }, "<leader>d", [["_d]], { desc = "Delete without cutting" })

-- ══════════════════════════════════════════════════════════════════════
-- ANDROID SPECIFIC KEYMAPS (Volume buttons as modifiers)
-- ══════════════════════════════════════════════════════════════════════

-- Volume Down as additional modifier key
-- Note: These require Termux:API and proper keyboard setup

-- Volume Down + / for comment toggle (like Ctrl+/)
android_map("n", "<M-/>", "gcc", { desc = "Toggle comment", remap = true })
android_map("v", "<M-/>", "gc", { desc = "Toggle comment", remap = true })

-- Volume Down + Enter for command palette
android_map("n", "<M-CR>", "<cmd>Telescope commands<cr>", { desc = "Command palette" })

-- Volume Down + F for file search
android_map("n", "<M-f>", "<cmd>Telescope find_files<cr>", { desc = "Find files" })

-- Volume Down + G for text search
android_map("n", "<M-g>", "<cmd>Telescope live_grep<cr>", { desc = "Live grep" })

-- Volume Down + O for quick open
android_map("n", "<M-o>", "<cmd>Telescope oldfiles<cr>", { desc = "Recent files" })

-- ══════════════════════════════════════════════════════════════════════
-- TELESCOPE SHORTCUTS (File explorer like VS Code)
-- ══════════════════════════════════════════════════════════════════════

-- Quick file navigation
android_map("n", "<leader>ff", "<cmd>Telescope find_files<cr>", { desc = "Find files" })
android_map("n", "<leader>fr", "<cmd>Telescope oldfiles<cr>", { desc = "Recent files" })
android_map("n", "<leader>fg", "<cmd>Telescope live_grep<cr>", { desc = "Live grep" })
android_map("n", "<leader>fb", "<cmd>Telescope buffers<cr>", { desc = "Find buffers" })
android_map("n", "<leader>fh", "<cmd>Telescope help_tags<cr>", { desc = "Help tags" })
android_map("n", "<leader>fc", "<cmd>Telescope commands<cr>", { desc = "Commands" })
android_map("n", "<leader>fk", "<cmd>Telescope keymaps<cr>", { desc = "Key maps" })

-- Project navigation
android_map("n", "<leader>fp", "<cmd>Telescope projects<cr>", { desc = "Projects" })

-- ══════════════════════════════════════════════════════════════════════
-- LSP SHORTCUTS (VS Code IntelliSense style)
-- ══════════════════════════════════════════════════════════════════════

-- LSP actions (will be enhanced by lsp config)
android_map("n", "gd", "<cmd>Telescope lsp_definitions<cr>", { desc = "Go to definition" })
android_map("n", "gr", "<cmd>Telescope lsp_references<cr>", { desc = "Find references" })
android_map("n", "gi", "<cmd>Telescope lsp_implementations<cr>", { desc = "Go to implementation" })
android_map("n", "gt", "<cmd>Telescope lsp_type_definitions<cr>", { desc = "Go to type definition" })

-- Diagnostics
android_map("n", "<leader>dd", "<cmd>Telescope diagnostics<cr>", { desc = "Show diagnostics" })
android_map("n", "]d", vim.diagnostic.goto_next, { desc = "Next diagnostic" })
android_map("n", "[d", vim.diagnostic.goto_prev, { desc = "Previous diagnostic" })

-- ══════════════════════════════════════════════════════════════════════
-- TERMINAL (Optimized for mobile workflow)
-- ══════════════════════════════════════════════════════════════════════

-- Terminal toggle
android_map("n", "<leader>tt", "<cmd>ToggleTerm<cr>", { desc = "Toggle terminal" })
android_map("t", "<esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

-- ══════════════════════════════════════════════════════════════════════
-- MOBILE OPTIMIZATIONS
-- ══════════════════════════════════════════════════════════════════════

-- Easier scrolling on mobile
android_map("n", "<C-d>", "<C-d>zz", { desc = "Scroll down and center" })
android_map("n", "<C-u>", "<C-u>zz", { desc = "Scroll up and center" })

-- Better page navigation
android_map("n", "n", "nzz", { desc = "Next search result (centered)" })
android_map("n", "N", "Nzz", { desc = "Previous search result (centered)" })

-- Quick save with double tap (muscle memory)
android_map("n", "<leader><leader>", "<cmd>w<cr>", { desc = "Quick save" })

-- Explorer toggle (like VS Code sidebar)
android_map("n", "<leader>e", "<cmd>NvimTreeToggle<cr>", { desc = "Toggle file explorer" })

-- ══════════════════════════════════════════════════════════════════════
-- MOBILE KEYBOARD HELPERS
-- ══════════════════════════════════════════════════════════════════════

-- Easier access to command mode
android_map("n", ";", ":", { desc = "Command mode" })

-- Undo/Redo (mobile friendly)
android_map("n", "U", "<C-r>", { desc = "Redo" })

-- Select all
android_map("n", "<leader>a", "ggVG", { desc = "Select all" })

-- Paste mode toggle for better paste behavior on mobile
android_map("n", "<leader>tp", "<cmd>set paste!<cr>", { desc = "Toggle paste mode" })

-- ══════════════════════════════════════════════════════════════════════
-- GIT INTEGRATION (LazyGit style)
-- ══════════════════════════════════════════════════════════════════════

android_map("n", "<leader>gg", "<cmd>LazyGit<cr>", { desc = "LazyGit" })
android_map("n", "<leader>gb", "<cmd>Telescope git_branches<cr>", { desc = "Git branches" })
android_map("n", "<leader>gc", "<cmd>Telescope git_commits<cr>", { desc = "Git commits" })
android_map("n", "<leader>gs", "<cmd>Telescope git_status<cr>", { desc = "Git status" })

-- ══════════════════════════════════════════════════════════════════════
-- PLUGIN MANAGEMENT
-- ══════════════════════════════════════════════════════════════════════

android_map("n", "<leader>pm", "<cmd>Lazy<cr>", { desc = "Plugin manager" })
android_map("n", "<leader>mm", "<cmd>Mason<cr>", { desc = "Mason" })

-- ══════════════════════════════════════════════════════════════════════
-- DEBUG SHORTCUTS (Simplified for mobile)
-- ══════════════════════════════════════════════════════════════════════

-- Debug mappings (will be enhanced by DAP config)
android_map("n", "<F5>", "<cmd>lua require'dap'.continue()<cr>", { desc = "Debug: Continue" })
android_map("n", "<F10>", "<cmd>lua require'dap'.step_over()<cr>", { desc = "Debug: Step Over" })
android_map("n", "<F11>", "<cmd>lua require'dap'.step_into()<cr>", { desc = "Debug: Step Into" })
android_map("n", "<leader>db", "<cmd>lua require'dap'.toggle_breakpoint()<cr>", { desc = "Debug: Toggle Breakpoint" })

-- Android-specific: Volume Down + Enter for debug (alternative)
android_map("n", "<M-F5>", "<cmd>lua require'dap'.continue()<cr>", { desc = "Debug: Continue" })
