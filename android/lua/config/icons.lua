-- ══════════════════════════════════════════════════════════════════════
-- Icons Configuration for Android/Termux
-- Optimized for mobile display and terminal fonts
-- ══════════════════════════════════════════════════════════════════════

local M = {}

-- Check if we have nerd font support in Termux
local has_nerd_font = vim.fn.has("gui_running") == 0 and os.getenv("TERMUX_VERSION") ~= nil

-- Fallback to simple ASCII if nerd fonts aren't available
local function icon(nerd, ascii)
  return has_nerd_font and nerd or ascii
end

-- File type icons
M.file_icons = {
  default = icon("", ""),
  folder = icon("", "📁"),
  folder_open = icon("", "📂"),
  folder_empty = icon("", "📁"),
  folder_empty_open = icon("", "📂"),
  
  -- Common file types
  lua = icon("", "🌙"),
  vim = icon("", "🟢"),
  js = icon("", "📄"),
  ts = icon("", "📘"),
  jsx = icon("", "⚛️"),
  tsx = icon("", "⚛️"),
  html = icon("", "🌐"),
  css = icon("", "🎨"),
  scss = icon("", "🎨"),
  json = icon("", "📋"),
  md = icon("", "📝"),
  py = icon("", "🐍"),
  go = icon("", "🔵"),
  rs = icon("", "🦀"),
  java = icon("", "☕"),
  php = icon("", "🐘"),
  rb = icon("", "💎"),
  
  -- Config files
  config = icon("", "⚙️"),
  env = icon("", "🔐"),
  gitignore = icon("", "🙈"),
  dockerfile = icon("", "🐳"),
  
  -- Archives
  zip = icon("", "📦"),
  tar = icon("", "📦"),
  gz = icon("", "📦"),
  
  -- Images
  png = icon("", "🖼️"),
  jpg = icon("", "🖼️"),
  jpeg = icon("", "🖼️"),
  gif = icon("", "🖼️"),
  svg = icon("", "🖼️"),
}

-- Git icons (simplified for mobile)
M.git = {
  added = icon("", "+"),
  modified = icon("", "~"),
  deleted = icon("", "-"),
  renamed = icon("", "→"),
  untracked = icon("", "?"),
  ignored = icon("", "◌"),
  unstaged = icon("", "U"),
  staged = icon("", "S"),
  conflict = icon("", "!"),
  
  -- Git status
  branch = icon("", "⎇"),
  ahead = icon("", "↑"),
  behind = icon("", "↓"),
  diverged = icon("", "↕"),
  up_to_date = icon("", "✓"),
}

-- Diagnostic icons (mobile friendly)
M.diagnostics = {
  Error = icon("", "❌"),
  Warn = icon("", "⚠️"),
  Warning = icon("", "⚠️"),
  Hint = icon("", "💡"),
  Info = icon("", "ℹ️"),
  Information = icon("", "ℹ️"),
  Question = icon("", "❓"),
  
  -- Diagnostic severities
  error = icon("", "E"),
  warning = icon("", "W"),
  info = icon("", "I"),
  hint = icon("", "H"),
}

-- LSP icons
M.lsp = {
  -- LSP kinds
  Text = icon("", "T"),
  Method = icon("", "M"),
  Function = icon("", "F"),
  Constructor = icon("", "C"),
  Field = icon("", "f"),
  Variable = icon("", "v"),
  Class = icon("", "C"),
  Interface = icon("", "I"),
  Module = icon("", "M"),
  Property = icon("", "p"),
  Unit = icon("", "u"),
  Value = icon("", "V"),
  Enum = icon("", "E"),
  Keyword = icon("", "k"),
  Snippet = icon("", "s"),
  Color = icon("", "c"),
  File = icon("", "f"),
  Reference = icon("", "r"),
  Folder = icon("", "d"),
  EnumMember = icon("", "e"),
  Constant = icon("", "C"),
  Struct = icon("", "S"),
  Event = icon("", "E"),
  Operator = icon("", "o"),
  TypeParameter = icon("", "T"),
  
  -- LSP progress
  progress = {
    icon("", "⏳"),
    icon("", "⏳"),
    icon("", "⏳"),
  },
}

-- Debug icons (DAP)
M.dap = {
  Breakpoint = { icon("", "🔴"), "DiagnosticInfo" },
  BreakpointCondition = { icon("", "🟡"), "DiagnosticInfo" },
  BreakpointRejected = { icon("", "⚫"), "DiagnosticError" },
  LogPoint = { icon("", "📝"), "DiagnosticInfo" },
  Stopped = { icon("", "➡️"), "DiagnosticWarn" },
  
  -- Debug controls
  play = icon("", "▶️"),
  pause = icon("", "⏸️"),
  stop = icon("", "⏹️"),
  restart = icon("", "🔄"),
  step_over = icon("", "⏭️"),
  step_into = icon("", "⬇️"),
  step_out = icon("", "⬆️"),
  step_back = icon("", "⏮️"),
}

-- UI icons (mobile optimized)
M.ui = {
  -- General UI
  close = icon("", "✕"),
  check = icon("", "✓"),
  cross = icon("", "✗"),
  arrow_right = icon("", "→"),
  arrow_left = icon("", "←"),
  arrow_up = icon("", "↑"),
  arrow_down = icon("", "↓"),
  
  -- Separators (mobile friendly)
  separator = icon("", "|"),
  vertical_separator = icon("", "│"),
  
  -- Special symbols
  ellipsis = icon("", "…"),
  search = icon("", "🔍"),
  settings = icon("", "⚙️"),
  home = icon("", "🏠"),
  
  -- Menu indicators
  submenu = icon("", "▶"),
  selected = icon("", "●"),
  unselected = icon("", "○"),
  
  -- Loading
  loading = icon("", "⏳"),
  
  -- Mobile specific
  touch = icon("", "👆"),
  swipe = icon("", "👆"),
}

-- Plugin specific icons
M.plugins = {
  -- Telescope
  telescope = icon("", "🔭"),
  
  -- File explorer
  explorer = icon("", "📁"),
  
  -- Terminal
  terminal = icon("", "💻"),
  
  -- Package manager
  package = icon("", "📦"),
  package_installed = icon("", "✓"),
  package_pending = icon("", "⏳"),
  package_uninstalled = icon("", "✗"),
  
  -- Git
  git = icon("", "🌿"),
  
  -- Note taking
  note = icon("", "📝"),
  
  -- Calendar/Time
  calendar = icon("", "📅"),
  clock = icon("", "🕒"),
  
  -- Android specific
  android = icon("", "🤖"),
  mobile = icon("", "📱"),
}

-- Window decorations (simplified for mobile)
M.borders = {
  single = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
  double = { "═", "║", "═", "║", "╔", "╗", "╝", "╚" },
  rounded = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
  solid = { " ", " ", " ", " ", " ", " ", " ", " " },
  shadow = { "", "", "", "", "", "", "", "" },
}

-- Status line icons (compact for mobile)
M.statusline = {
  readonly = icon("", "🔒"),
  modified = icon("", "●"),
  
  -- Mode indicators
  normal = icon("", "N"),
  insert = icon("", "I"),
  visual = icon("", "V"),
  replace = icon("", "R"),
  command = icon("", "C"),
  terminal = icon("", "T"),
  
  -- Git branch
  branch = icon("", "⎇"),
  
  -- File info
  line_column = icon("", "⌘"),
  percentage = icon("", "%"),
  
  -- LSP status
  lsp_ok = icon("", "✓"),
  lsp_error = icon("", "❌"),
  lsp_warn = icon("", "⚠️"),
  lsp_info = icon("", "ℹ️"),
  lsp_hint = icon("", "💡"),
}

-- Android specific icons
M.android = {
  back = icon("", "←"),
  home = icon("", "⌂"),
  menu = icon("", "☰"),
  share = icon("", "📤"),
  volume_up = icon("", "🔊"),
  volume_down = icon("", "🔉"),
  battery = icon("", "🔋"),
  wifi = icon("", "📶"),
  bluetooth = icon("", "📱"),
  location = icon("", "📍"),
  notification = icon("", "🔔"),
}

return M
