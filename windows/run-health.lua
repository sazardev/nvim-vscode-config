-- Health check script
vim.opt.verbosefile = 'health-verbose.log'
vim.opt.verbose = 15

print("=== NEOVIM HEALTH CHECK START ===")
print("Neovim version: " .. vim.version().major .. "." .. vim.version().minor .. "." .. vim.version().patch)
print("Date: " .. os.date())
print("")

-- Capture health output
local health_file = io.open("health-complete.txt", "w")
if health_file then
  -- Redirect vim's output
  vim.cmd("redir! > health-output.log")
  
  -- Run specific health checks
  local checks = {
    "lazy",
    "mason", 
    "nvim-treesitter",
    "telescope",
    "lsp",
    "provider",
    "vim.lsp",
    "luasnip"
  }
  
  for _, check in ipairs(checks) do
    print("Checking: " .. check)
    health_file:write("=== " .. check .. " ===\n")
    local ok, result = pcall(vim.cmd, "checkhealth " .. check)
    if ok then
      health_file:write("OK\n")
    else
      health_file:write("ERROR: " .. tostring(result) .. "\n")
    end
    health_file:write("\n")
  end
  
  vim.cmd("redir END")
  health_file:close()
end

print("=== HEALTH CHECK COMPLETE ===")
vim.cmd("qa!")
