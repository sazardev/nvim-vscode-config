-- ══════════════════════════════════════════════════════════════════════
-- Autocmds Configuration for Android/Termux
-- Performance optimizations and mobile-specific behaviors
-- ══════════════════════════════════════════════════════════════════════

local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup

-- ══════════════════════════════════════════════════════════════════════
-- GENERAL AUTOCMDS
-- ══════════════════════════════════════════════════════════════════════

-- Highlight on yank
augroup("YankHighlight", { clear = true })
autocmd("TextYankPost", {
  group = "YankHighlight",
  callback = function()
    vim.highlight.on_yank()
  end,
})

-- Resize splits if window got resized (important for mobile orientation changes)
augroup("ResizeOnWindowResize", { clear = true })
autocmd({ "VimResized" }, {
  group = "ResizeOnWindowResize",
  callback = function()
    local current_tab = vim.fn.tabpagenr()
    vim.cmd("tabdo wincmd =")
    vim.cmd("tabnext " .. current_tab)
  end,
})

-- Go to last location when opening a buffer
augroup("LastLocation", { clear = true })
autocmd("BufReadPost", {
  group = "LastLocation",
  callback = function(event)
    local exclude = { "gitcommit" }
    local buf = event.buf
    if vim.tbl_contains(exclude, vim.bo[buf].filetype) or vim.b[buf].last_location then
      return
    end
    vim.b[buf].last_location = true
    local mark = vim.api.nvim_buf_get_mark(buf, '"')
    local lcount = vim.api.nvim_buf_line_count(buf)
    if mark[1] > 0 and mark[1] <= lcount then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})

-- Close some filetypes with <q>
augroup("CloseWithQ", { clear = true })
autocmd("FileType", {
  group = "CloseWithQ",
  pattern = {
    "PlenaryTestPopup",
    "help",
    "lspinfo",
    "man",
    "notify",
    "qf",
    "query",
    "spectre_panel",
    "startuptime",
    "tsplayground",
    "neotest-output",
    "checkhealth",
    "neotest-summary",
    "neotest-output-panel",
  },
  callback = function(event)
    vim.bo[event.buf].buflisted = false
    vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = event.buf, silent = true })
  end,
})

-- ══════════════════════════════════════════════════════════════════════
-- MOBILE/ANDROID SPECIFIC OPTIMIZATIONS
-- ══════════════════════════════════════════════════════════════════════

-- Battery optimization: Reduce updates when on battery
augroup("AndroidBatteryOptimization", { clear = true })
autocmd({ "BufEnter", "FocusGained" }, {
  group = "AndroidBatteryOptimization",
  callback = function()
    if vim.g.is_android then
      -- Reduce updatetime when in focus
      vim.opt.updatetime = 250
    end
  end,
})

autocmd({ "BufLeave", "FocusLost" }, {
  group = "AndroidBatteryOptimization",
  callback = function()
    if vim.g.is_android then
      -- Increase updatetime when out of focus to save battery
      vim.opt.updatetime = 1000
    end
  end,
})

-- Auto-save for mobile workflow (prevent data loss on unexpected app kills)
augroup("AndroidAutoSave", { clear = true })
autocmd({ "BufLeave", "FocusLost" }, {
  group = "AndroidAutoSave",
  callback = function()
    if vim.g.is_android and vim.bo.modified and vim.bo.buftype == "" then
      vim.cmd("silent! write")
    end
  end,
})

-- Optimize rendering for small screens
augroup("AndroidScreenOptimization", { clear = true })
autocmd("VimEnter", {
  group = "AndroidScreenOptimization",
  callback = function()
    if vim.g.is_android then
      -- Optimize for small screens
      local screen_width = vim.o.columns
      if screen_width < 80 then
        vim.opt.number = false -- Disable line numbers on very small screens
        vim.opt.relativenumber = false
        vim.opt.signcolumn = "no"
      end
    end
  end,
})

-- ══════════════════════════════════════════════════════════════════════
-- FILE TYPE SPECIFIC AUTOCMDS
-- ══════════════════════════════════════════════════════════════════════

-- Wrap and check for spell in text filetypes
augroup("WrapSpell", { clear = true })
autocmd("FileType", {
  group = "WrapSpell",
  pattern = { "gitcommit", "markdown", "text" },
  callback = function()
    vim.opt_local.wrap = true
    vim.opt_local.spell = true
  end,
})

-- Fix conceallevel for json files
augroup("JsonConceal", { clear = true })
autocmd({ "FileType" }, {
  group = "JsonConceal",
  pattern = { "json", "jsonc", "json5" },
  callback = function()
    vim.opt_local.conceallevel = 0
  end,
})

-- ══════════════════════════════════════════════════════════════════════
-- TERMINAL SPECIFIC AUTOCMDS
-- ══════════════════════════════════════════════════════════════════════

-- Terminal settings for better mobile experience
augroup("TerminalSettings", { clear = true })
autocmd("TermOpen", {
  group = "TerminalSettings",
  callback = function()
    vim.opt_local.number = false
    vim.opt_local.relativenumber = false
    vim.opt_local.signcolumn = "no"
    vim.opt_local.statuscolumn = ""
  end,
})

-- Start terminal in insert mode
autocmd("TermOpen", {
  group = "TerminalSettings",
  command = "startinsert",
})

-- ══════════════════════════════════════════════════════════════════════
-- PERFORMANCE OPTIMIZATIONS FOR ANDROID
-- ══════════════════════════════════════════════════════════════════════

-- Disable syntax highlighting for large files (performance)
augroup("AndroidPerformance", { clear = true })
autocmd("BufReadPre", {
  group = "AndroidPerformance",
  callback = function()
    local file_size = vim.fn.getfsize(vim.fn.expand("%"))
    if file_size > 1024 * 1024 then -- 1MB
      vim.cmd("syntax off")
      vim.opt_local.foldmethod = "manual"
      vim.opt_local.undolevels = -1
    end
  end,
})

-- Garbage collection optimization for mobile
augroup("AndroidGC", { clear = true })
autocmd("VimEnter", {
  group = "AndroidGC",
  callback = function()
    if vim.g.is_android then
      -- Force garbage collection every 30 seconds to manage memory
      vim.fn.timer_start(30000, function()
        collectgarbage()
      end, { ["repeat"] = -1 })
    end
  end,
})

-- ══════════════════════════════════════════════════════════════════════
-- LSP OPTIMIZATIONS FOR MOBILE
-- ══════════════════════════════════════════════════════════════════════

-- Reduce LSP diagnostics frequency on mobile
augroup("AndroidLSPOptimization", { clear = true })
autocmd("LspAttach", {
  group = "AndroidLSPOptimization",
  callback = function(args)
    if vim.g.is_android then
      local client = vim.lsp.get_client_by_id(args.data.client_id)
      if client then
        -- Reduce update frequency for better performance
        client.config.flags = client.config.flags or {}
        client.config.flags.debounce_text_changes = 500
      end
    end
  end,
})

-- ══════════════════════════════════════════════════════════════════════
-- CLIPBOARD INTEGRATION FOR ANDROID
-- ══════════════════════════════════════════════════════════════════════

-- Enhanced clipboard integration for Termux
augroup("AndroidClipboard", { clear = true })
autocmd("TextYankPost", {
  group = "AndroidClipboard",
  callback = function()
    if vim.g.is_android and vim.v.event.operator == "y" then
      -- Automatically copy to system clipboard on yank
      vim.fn.system("termux-clipboard-set", vim.fn.getreg('"'))
    end
  end,
})

-- ══════════════════════════════════════════════════════════════════════
-- TERMUX SPECIFIC FEATURES
-- ══════════════════════════════════════════════════════════════════════

-- Setup Termux API integration
augroup("TermuxAPI", { clear = true })
autocmd("VimEnter", {
  group = "TermuxAPI",
  once = true,
  callback = function()
    if vim.g.is_android then
      -- Check if Termux:API is available
      local api_available = vim.fn.executable("termux-clipboard-get") == 1
      if api_available then
        vim.g.termux_api_available = true
        -- Setup vibration on errors (if available)
        autocmd("DiagnosticChanged", {
          callback = function()
            local diagnostics = vim.diagnostic.get(0, { severity = vim.diagnostic.severity.ERROR })
            if #diagnostics > 0 and vim.fn.executable("termux-vibrate") == 1 then
              vim.fn.system("termux-vibrate -d 200")
            end
          end,
        })
      end
    end
  end,
})

-- ══════════════════════════════════════════════════════════════════════
-- AUTO-COMPLETION OPTIMIZATIONS
-- ══════════════════════════════════════════════════════════════════════

-- Reduce completion menu size on small screens
augroup("AndroidCompletion", { clear = true })
autocmd("VimEnter", {
  group = "AndroidCompletion",
  callback = function()
    if vim.g.is_android and vim.o.columns < 100 then
      vim.opt.pumheight = 5 -- Smaller completion menu
    end
  end,
})
