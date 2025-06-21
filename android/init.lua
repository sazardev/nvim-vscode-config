-- ══════════════════════════════════════════════════════════════════════
-- Neovim Configuration for Android/Termux
-- VS Code-like experience optimized for mobile devices
-- ══════════════════════════════════════════════════════════════════════

-- Set leader key early
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Android/Termux specific configurations
vim.g.is_android = true
vim.g.termux_path = os.getenv("PREFIX") or "/data/data/com.termux/files/usr"

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Load configuration modules
require("config.options")
require("config.keymaps")
require("config.autocmds")

-- Setup lazy.nvim with plugins
require("lazy").setup("plugins", {
  defaults = {
    lazy = false,
    version = false,
  },
  install = {
    colorscheme = { "tokyonight", "habamax" },
  },
  checker = {
    enabled = true,
    notify = false,
  },
  change_detection = {
    notify = false,
  },
  ui = {
    border = "rounded",
  },
  performance = {
    rtp = {
      -- disable some rtp plugins for better performance on Android
      disabled_plugins = {
        "gzip",
        "matchit",
        "matchparen",
        "netrwPlugin",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
      },
    },
  },
})
