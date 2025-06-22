# ══════════════════════════════════════════════════════════════════════
# Neovim Health Check Script for Windows
# Captures complete :checkhealth output for review
# ══════════════════════════════════════════════════════════════════════

Write-Host "🏥 Ejecutando Neovim Health Check..." -ForegroundColor Cyan
Write-Host "─────────────────────────────────────────" -ForegroundColor Cyan
Write-Host ""

# Define output file
$outputFile = Join-Path $PSScriptRoot "health-check-output.txt"
$scriptFile = Join-Path $PSScriptRoot "temp-health-script.lua"

# Create a Lua script to run checkhealth and save output
$luaScript = @'
-- Redirect output to file
local output_file = vim.fn.expand("~") .. "/Documents/terminal/nvim-vscode-config/windows/health-check-output.txt"

-- Open file for writing
local file = io.open(output_file, "w")
if not file then
    print("Error: Could not open output file")
    vim.cmd("qa!")
    return
end

-- Capture print output
local original_print = print
local function custom_print(...)
    local args = {...}
    local line = ""
    for i, v in ipairs(args) do
        line = line .. tostring(v)
        if i < #args then
            line = line .. "\t"
        end
    end
    file:write(line .. "\n")
    file:flush()
end

-- Override print temporarily
print = custom_print

-- Capture vim.health output
local health_reports = {}
local original_report_start = vim.health.report_start or function() end
local original_report_ok = vim.health.report_ok or function() end
local original_report_warn = vim.health.report_warn or function() end
local original_report_error = vim.health.report_error or function() end
local original_report_info = vim.health.report_info or function() end

vim.health.report_start = function(name)
    file:write("\n" .. string.rep("=", 60) .. "\n")
    file:write("HEALTH CHECK: " .. name .. "\n")
    file:write(string.rep("=", 60) .. "\n")
    file:flush()
    return original_report_start(name)
end

vim.health.report_ok = function(msg)
    file:write("✓ OK: " .. msg .. "\n")
    file:flush()
    return original_report_ok(msg)
end

vim.health.report_warn = function(msg, advice)
    file:write("⚠ WARNING: " .. msg .. "\n")
    if advice then
        file:write("  ADVICE: " .. advice .. "\n")
    end
    file:flush()
    return original_report_warn(msg, advice)
end

vim.health.report_error = function(msg, advice)
    file:write("✗ ERROR: " .. msg .. "\n")
    if advice then
        file:write("  ADVICE: " .. advice .. "\n")
    end
    file:flush()
    return original_report_error(msg, advice)
end

vim.health.report_info = function(msg)
    file:write("ℹ INFO: " .. msg .. "\n")
    file:flush()
    return original_report_info(msg)
end

-- Write header
file:write("NEOVIM HEALTH CHECK REPORT\n")
file:write("Generated: " .. os.date("%Y-%m-%d %H:%M:%S") .. "\n")
file:write("Neovim Version: " .. tostring(vim.version()) .. "\n")
file:write(string.rep("=", 80) .. "\n\n")

-- Run checkhealth
print("Starting health check...")
vim.cmd("checkhealth")

-- Restore original functions
print = original_print
vim.health.report_start = original_report_start
vim.health.report_ok = original_report_ok
vim.health.report_warn = original_report_warn
vim.health.report_error = original_report_error
vim.health.report_info = original_report_info

-- Close file and quit
file:write("\n" .. string.rep("=", 80) .. "\n")
file:write("HEALTH CHECK COMPLETED\n")
file:close()

print("Health check saved to: " .. output_file)
vim.cmd("qa!")
'@

# Write the Lua script to temp file
Set-Content -Path $scriptFile -Value $luaScript -Encoding UTF8

try {
    # Remove old output file if exists
    if (Test-Path $outputFile) {
        Remove-Item $outputFile -Force
    }

    Write-Host "📝 Ejecutando health check y guardando en archivo..." -ForegroundColor Yellow
    
    # Run Neovim with the health check script
    $result = & nvim --headless --clean -u $scriptFile 2>&1
    
    Write-Host "✅ Health check ejecutado" -ForegroundColor Green
    
    # Wait a moment for file to be written
    Start-Sleep -Seconds 2
    
    # Check if output file was created
    if (Test-Path $outputFile) {
        $fileSize = (Get-Item $outputFile).Length
        Write-Host "📄 Archivo de salida creado: $outputFile" -ForegroundColor Green
        Write-Host "📊 Tamaño del archivo: $fileSize bytes" -ForegroundColor Cyan
        
        # Show first few lines
        Write-Host ""
        Write-Host "🔍 Primeras líneas del health check:" -ForegroundColor Cyan
        Write-Host "─────────────────────────────────────────" -ForegroundColor Cyan
        Get-Content $outputFile -Head 20 | ForEach-Object { Write-Host $_ -ForegroundColor White }
        
        # Show file location for easy access
        Write-Host ""
        Write-Host "📍 Ubicación completa del archivo:" -ForegroundColor Cyan
        Write-Host $outputFile -ForegroundColor Yellow
        Write-Host ""
        Write-Host "💡 Puedes abrir el archivo completo con:" -ForegroundColor Cyan
        Write-Host "   notepad `"$outputFile`"" -ForegroundColor White
        Write-Host "   o" -ForegroundColor White
        Write-Host "   Get-Content `"$outputFile`"" -ForegroundColor White
        Write-Host ""
        
        # Try to run a simple health check for essential components
        Write-Host "🔍 Resumen rápido de componentes críticos:" -ForegroundColor Cyan
        Write-Host "─────────────────────────────────────────" -ForegroundColor Cyan
        
        $content = Get-Content $outputFile -Raw
        
        # Check for Mason
        if ($content -match "mason") {
            Write-Host "✅ Mason encontrado en health check" -ForegroundColor Green
        } else {
            Write-Host "❌ Mason no encontrado en health check" -ForegroundColor Red
        }
        
        # Check for LSP
        if ($content -match "lsp") {
            Write-Host "✅ LSP encontrado en health check" -ForegroundColor Green
        } else {
            Write-Host "❌ LSP no encontrado en health check" -ForegroundColor Red
        }
        
        # Check for treesitter
        if ($content -match "treesitter") {
            Write-Host "✅ Treesitter encontrado en health check" -ForegroundColor Green
        } else {
            Write-Host "❌ Treesitter no encontrado en health check" -ForegroundColor Red
        }
        
        # Count errors and warnings
        $errors = ($content | Select-String "✗ ERROR:" -AllMatches).Matches.Count
        $warnings = ($content | Select-String "⚠ WARNING:" -AllMatches).Matches.Count
        $oks = ($content | Select-String "✓ OK:" -AllMatches).Matches.Count
        
        Write-Host ""
        Write-Host "📊 Resumen del health check:" -ForegroundColor Cyan
        Write-Host "   ✅ OK: $oks" -ForegroundColor Green
        Write-Host "   ⚠️  Warnings: $warnings" -ForegroundColor Yellow
        Write-Host "   ❌ Errors: $errors" -ForegroundColor Red
        
    } else {
        Write-Host "❌ No se pudo crear el archivo de salida" -ForegroundColor Red
        Write-Host "🔍 Salida de Neovim:" -ForegroundColor Yellow
        Write-Host $result -ForegroundColor White
    }
    
} catch {
    Write-Host "❌ Error ejecutando health check: $($_.Exception.Message)" -ForegroundColor Red
} finally {
    # Clean up temp script
    if (Test-Path $scriptFile) {
        Remove-Item $scriptFile -Force
    }
}

Write-Host ""
Write-Host "🎯 Para revisar el health check completo, comparte el contenido del archivo:" -ForegroundColor Cyan
Write-Host "   $outputFile" -ForegroundColor Yellow
