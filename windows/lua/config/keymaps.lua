-- ══════════════════════════════════════════════════════════════════════
-- Keymaps Configuration - VS Code Style
-- ══════════════════════════════════════════════════════════════════════

local function map(mode, lhs, rhs, opts)
  opts = opts or {}
  opts.silent = opts.silent ~= false
  vim.keymap.set(mode, lhs, rhs, opts)
end

-- ══════════════════════════════════════════════════════════════════════
-- GENERAL MAPPINGS
-- ══════════════════════════════════════════════════════════════════════

-- Better up/down
map({ "n", "x" }, "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
map({ "n", "x" }, "<Down>", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
map({ "n", "x" }, "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
map({ "n", "x" }, "<Up>", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })

-- Move to window using the <ctrl> hjkl keys
map("n", "<C-h>", "<C-w>h", { desc = "Go to left window", remap = true })
map("n", "<C-j>", "<C-w>j", { desc = "Go to lower window", remap = true })
map("n", "<C-k>", "<C-w>k", { desc = "Go to upper window", remap = true })
map("n", "<C-l>", "<C-w>l", { desc = "Go to right window", remap = true })

-- Resize window using <ctrl> arrow keys
map("n", "<C-Up>", "<cmd>resize +2<cr>", { desc = "Increase window height" })
map("n", "<C-Down>", "<cmd>resize -2<cr>", { desc = "Decrease window height" })
map("n", "<C-Left>", "<cmd>vertical resize -2<cr>", { desc = "Decrease window width" })
map("n", "<C-Right>", "<cmd>vertical resize +2<cr>", { desc = "Increase window width" })

-- ══════════════════════════════════════════════════════════════════════
-- VS CODE STYLE SHORTCUTS
-- ══════════════════════════════════════════════════════════════════════

-- File operations
map("n", "<C-s>", "<cmd>w<cr><esc>", { desc = "Save file" })
map("n", "<C-n>", "<cmd>enew<cr>", { desc = "New file" })
map("n", "<C-w>", "<cmd>bd<cr>", { desc = "Close buffer" })
map("n", "<C-q>", "<cmd>qa<cr>", { desc = "Quit all" })

-- Undo/Redo
map("n", "<C-z>", "u", { desc = "Undo" })
map("n", "<C-y>", "<C-r>", { desc = "Redo" })

-- Select all
map("n", "<C-a>", "ggVG", { desc = "Select all" })

-- Copy/Paste/Cut (VS Code style)
map("v", "<C-c>", '"+y', { desc = "Copy to clipboard" })
map("n", "<C-v>", '"+p', { desc = "Paste from clipboard" })
map("v", "<C-x>", '"+d', { desc = "Cut to clipboard" })
map("i", "<C-v>", '<C-r>+', { desc = "Paste from clipboard in insert mode" })

-- Find and replace
map("n", "<C-f>", "/", { desc = "Find" })
map("n", "<C-h>", ":%s/", { desc = "Find and replace" })

-- Comment toggle (will be handled by Comment plugin)
map("n", "<C-/>", "gcc", { desc = "Toggle comment", remap = true })
map("v", "<C-/>", "gc", { desc = "Toggle comment", remap = true })

-- Duplicate line
map("n", "<C-d>", "yyp", { desc = "Duplicate line" })
map("v", "<C-d>", "y'>p", { desc = "Duplicate selection" })

-- Move lines up/down (Alt + Arrow)
map("n", "<A-Up>", "<cmd>m .-2<cr>==", { desc = "Move line up" })
map("n", "<A-Down>", "<cmd>m .+1<cr>==", { desc = "Move line down" })
map("i", "<A-Up>", "<esc><cmd>m .-2<cr>==gi", { desc = "Move line up" })
map("i", "<A-Down>", "<esc><cmd>m .+1<cr>==gi", { desc = "Move line down" })
map("v", "<A-Up>", ":m '<-2<cr>gv=gv", { desc = "Move selection up" })
map("v", "<A-Down>", ":m '>+1<cr>gv=gv", { desc = "Move selection down" })

-- Tab navigation
map("n", "<C-Tab>", "<cmd>bnext<cr>", { desc = "Next buffer" })
map("n", "<C-S-Tab>", "<cmd>bprevious<cr>", { desc = "Previous buffer" })
map("n", "<C-PageUp>", "<cmd>bprevious<cr>", { desc = "Previous buffer" })
map("n", "<C-PageDown>", "<cmd>bnext<cr>", { desc = "Next buffer" })

-- ══════════════════════════════════════════════════════════════════════
-- LEADER KEY MAPPINGS
-- ══════════════════════════════════════════════════════════════════════

-- File explorer
map("n", "<leader>e", "<cmd>NvimTreeToggle<cr>", { desc = "Toggle file explorer" })
map("n", "<leader>E", "<cmd>NvimTreeFocus<cr>", { desc = "Focus file explorer" })

-- Telescope (fuzzy finder)
map("n", "<leader>ff", "<cmd>Telescope find_files<cr>", { desc = "Find files" })
map("n", "<leader>fg", "<cmd>Telescope live_grep<cr>", { desc = "Live grep" })
map("n", "<leader>fb", "<cmd>Telescope buffers<cr>", { desc = "Find buffers" })
map("n", "<leader>fh", "<cmd>Telescope help_tags<cr>", { desc = "Help tags" })
map("n", "<leader>fr", "<cmd>Telescope oldfiles<cr>", { desc = "Recent files" })
map("n", "<leader>fc", "<cmd>Telescope grep_string<cr>", { desc = "Find word under cursor" })

-- Git
map("n", "<leader>gg", "<cmd>LazyGit<cr>", { desc = "LazyGit" })
map("n", "<leader>gb", "<cmd>Telescope git_branches<cr>", { desc = "Git branches" })
map("n", "<leader>gc", "<cmd>Telescope git_commits<cr>", { desc = "Git commits" })
map("n", "<leader>gs", "<cmd>Telescope git_status<cr>", { desc = "Git status" })

-- LSP
map("n", "<leader>lf", "<cmd>lua vim.lsp.buf.format()<cr>", { desc = "Format code" })
map("n", "<leader>lr", "<cmd>lua vim.lsp.buf.rename()<cr>", { desc = "Rename symbol" })
map("n", "<leader>la", "<cmd>lua vim.lsp.buf.code_action()<cr>", { desc = "Code actions" })
map("n", "<leader>ld", "<cmd>Telescope lsp_definitions<cr>", { desc = "Go to definition" })
map("n", "<leader>li", "<cmd>Telescope lsp_implementations<cr>", { desc = "Go to implementation" })
map("n", "<leader>lt", "<cmd>Telescope lsp_type_definitions<cr>", { desc = "Go to type definition" })
map("n", "<leader>lr", "<cmd>Telescope lsp_references<cr>", { desc = "Find references" })

-- Diagnostics
map("n", "<leader>dd", "<cmd>Telescope diagnostics<cr>", { desc = "Show diagnostics" })
map("n", "<leader>dn", "<cmd>lua vim.diagnostic.goto_next()<cr>", { desc = "Next diagnostic" })
map("n", "<leader>dp", "<cmd>lua vim.diagnostic.goto_prev()<cr>", { desc = "Previous diagnostic" })

-- Buffer management
map("n", "<leader>bd", "<cmd>bd<cr>", { desc = "Delete buffer" })
map("n", "<leader>ba", "<cmd>%bd|e#|bd#<cr>", { desc = "Delete all buffers except current" })
map("n", "<leader>bl", "<cmd>Telescope buffers<cr>", { desc = "List buffers" })

-- Terminal
map("n", "<leader>tt", "<cmd>ToggleTerm<cr>", { desc = "Toggle terminal" })
map("n", "<leader>tf", "<cmd>ToggleTerm direction=float<cr>", { desc = "Float terminal" })
map("n", "<leader>th", "<cmd>ToggleTerm direction=horizontal<cr>", { desc = "Horizontal terminal" })
map("n", "<leader>tv", "<cmd>ToggleTerm direction=vertical size=80<cr>", { desc = "Vertical terminal" })

-- Window management
map("n", "<leader>wh", "<C-w>s", { desc = "Split horizontal" })
map("n", "<leader>wv", "<C-w>v", { desc = "Split vertical" })
map("n", "<leader>wc", "<C-w>c", { desc = "Close window" })
map("n", "<leader>wo", "<C-w>o", { desc = "Close other windows" })

-- ══════════════════════════════════════════════════════════════════════
-- UTILITY MAPPINGS
-- ══════════════════════════════════════════════════════════════════════

-- Clear search highlighting
map("n", "<Esc>", "<cmd>nohlsearch<cr>", { desc = "Clear search highlighting" })

-- Better indenting
map("v", "<", "<gv")
map("v", ">", ">gv")

-- Paste without yanking in visual mode
map("v", "p", '"_dP')

-- Keep cursor centered when scrolling
map("n", "<C-d>", "<C-d>zz")
map("n", "<C-u>", "<C-u>zz")
map("n", "n", "nzzzv")
map("n", "N", "Nzzzv")

-- Join lines without moving cursor
map("n", "J", "mzJ`z")

-- Quick fix list
map("n", "<leader>qo", "<cmd>copen<cr>", { desc = "Open quickfix list" })
map("n", "<leader>qc", "<cmd>cclose<cr>", { desc = "Close quickfix list" })
map("n", "<leader>qn", "<cmd>cnext<cr>", { desc = "Next quickfix item" })
map("n", "<leader>qp", "<cmd>cprev<cr>", { desc = "Previous quickfix item" })

-- Location list
map("n", "<leader>lo", "<cmd>lopen<cr>", { desc = "Open location list" })
map("n", "<leader>lc", "<cmd>lclose<cr>", { desc = "Close location list" })
map("n", "<leader>ln", "<cmd>lnext<cr>", { desc = "Next location item" })
map("n", "<leader>lp", "<cmd>lprev<cr>", { desc = "Previous location item" })

-- Plugin manager
map("n", "<leader>pm", "<cmd>Lazy<cr>", { desc = "Plugin manager" })
map("n", "<leader>pc", "<cmd>Lazy clean<cr>", { desc = "Clean plugins" })
map("n", "<leader>pu", "<cmd>Lazy update<cr>", { desc = "Update plugins" })

-- Mason (LSP manager)
map("n", "<leader>mm", "<cmd>Mason<cr>", { desc = "Mason" })

-- ══════════════════════════════════════════════════════════════════════
-- SPECIAL KEYS
-- ══════════════════════════════════════════════════════════════════════

-- Function keys
map("n", "<F1>", "<cmd>Telescope help_tags<cr>", { desc = "Help" })
map("n", "<F2>", "<cmd>lua vim.lsp.buf.rename()<cr>", { desc = "Rename" })
map("n", "<F5>", "<cmd>lua require('dap').continue()<cr>", { desc = "Debug: Continue" })
map("n", "<F9>", "<cmd>lua require('dap').toggle_breakpoint()<cr>", { desc = "Debug: Toggle breakpoint" })
map("n", "<F10>", "<cmd>lua require('dap').step_over()<cr>", { desc = "Debug: Step over" })
map("n", "<F11>", "<cmd>lua require('dap').step_into()<cr>", { desc = "Debug: Step into" })
map("n", "<F12>", "<cmd>lua vim.lsp.buf.definition()<cr>", { desc = "Go to definition" })

-- Terminal mode mappings
map("t", "<Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })
map("t", "<C-h>", "<cmd>wincmd h<cr>", { desc = "Go to left window" })
map("t", "<C-j>", "<cmd>wincmd j<cr>", { desc = "Go to lower window" })
map("t", "<C-k>", "<cmd>wincmd k<cr>", { desc = "Go to upper window" })
map("t", "<C-l>", "<cmd>wincmd l<cr>", { desc = "Go to right window" })

-- ══════════════════════════════════════════════════════════════════════
-- AUTOCOMPLETE MAPPINGS (handled by nvim-cmp)
-- ══════════════════════════════════════════════════════════════════════

-- Tab for completion
-- <Tab> and <S-Tab> will be handled by nvim-cmp configuration
-- <C-Space> for trigger completion
-- <CR> for confirm completion
-- <C-e> for abort completion

-- ══════════════════════════════════════════════════════════════════════
-- CUSTOM COMMANDS
-- ══════════════════════════════════════════════════════════════════════

-- Format current buffer
vim.api.nvim_create_user_command("Format", function()
  vim.lsp.buf.format()
end, { desc = "Format current buffer" })

-- Reload configuration
vim.api.nvim_create_user_command("ReloadConfig", function()
  vim.cmd("source $MYVIMRC")
  print("Configuration reloaded!")
end, { desc = "Reload Neovim configuration" })

-- Toggle relative line numbers
vim.api.nvim_create_user_command("ToggleRelativeNumbers", function()
  vim.opt.relativenumber = not vim.opt.relativenumber:get()
end, { desc = "Toggle relative line numbers" })
