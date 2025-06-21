-- ══════════════════════════════════════════════════════════════════════
-- Icons Configuration
-- ══════════════════════════════════════════════════════════════════════

local M = {}

M.ui = {
  ArrowRight = "",
  ArrowLeft = "",
  Lock = "",
  Circle = "●",
  BigCircle = "",
  BigUnfilledCircle = "",
  Close = "",
  NewFile = "",
  Search = "",
  Lightbulb = "",
  Project = "",
  Dashboard = "",
  History = "",
  Comment = "",
  Bug = "",
  Code = "",
  Telescope = "",
  Gear = "",
  Package = "",
  List = "",
  SignIn = "",
  SignOut = "",
  Check = "",
  Fire = "",
  Note = "",
  BookMark = "",
  Pencil = "",
  ChevronRight = "",
  Table = "",
  Calendar = "",
  CloudDownload = "",
}

M.diagnostics = {
  Error = "",
  Warning = "",
  Information = "",
  Question = "",
  Hint = "",
}

M.misc = {
  Robot = "ﮧ",
  Squirrel = "",
  Tag = "",
  Watch = "",
  Smiley = "",
  Package = "",
  CircuitBoard = "",
}

M.git = {
  Add = "",
  Mod = "",
  Remove = "",
  Ignore = "",
  Rename = "",
  Diff = "",
  Repo = "",
  Branch = "",
  Merge = "",
}

M.lsp = {
  Server = "",
  Client = "",
}

M.cmp = {
  nvim_lsp = "",
  nvim_lua = "",
  buffer = "",
  path = "",
  luasnip = "",
}

M.dap = {
  Stopped = { "󰁕 ", "DiagnosticWarn", "DapStoppedLine" },
  Breakpoint = " ",
  BreakpointCondition = " ",
  BreakpointRejected = { " ", "DiagnosticError" },
  LogPoint = ".>",
}

M.kinds = {
  Array = "",
  Boolean = "",
  Class = "",
  Color = "",
  Constant = "",
  Constructor = "",
  Copilot = "",
  Enum = "",
  EnumMember = "",
  Event = "",
  Field = "",
  File = "",
  Folder = "",
  Function = "",
  Interface = "",
  Key = "",
  Keyword = "",
  Method = "",
  Module = "",
  Namespace = "",
  Null = "",
  Number = "",
  Object = "",
  Operator = "",
  Package = "",
  Property = "",
  Reference = "",
  Snippet = "",
  String = "",
  Struct = "",
  Text = "",
  TypeParameter = "",
  Unit = "",
  Value = "",
  Variable = "",
}

return M
