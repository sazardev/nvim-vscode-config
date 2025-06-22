# ══════════════════════════════════════════════════════════════════════
# Neovim Health Check Script
# Captures complete health check output for analysis
# ══════════════════════════════════════════════════════════════════════

Write-Host "🏥 Ejecutando checkhealth completo de Neovim..." -ForegroundColor Cyan
Write-Host "─────────────────────────────────────────────────────" -ForegroundColor Cyan
Write-Host ""

# Ensure Visual Studio Build Tools are available
$vsPaths = @(
    "C:\Program Files\Microsoft Visual Studio\2022\Community",
    "C:\Program Files (x86)\Microsoft Visual Studio\2022\BuildTools",
    "C:\Program Files\Microsoft Visual Studio\2022\BuildTools"
)

$vsPath = $null
foreach ($path in $vsPaths) {
    if (Test-Path "$path\VC\Auxiliary\Build\vcvars64.bat") {
        $vsPath = $path
        break
    }
}

if ($vsPath) {
    # Set up Visual Studio environment
    $vcvarsPath = "$vsPath\VC\Auxiliary\Build\vcvars64.bat"
    $psi = New-Object System.Diagnostics.ProcessStartInfo
    $psi.FileName = "cmd.exe"
    $psi.Arguments = "/c `"$vcvarsPath`" && set"
    $psi.RedirectStandardOutput = $true
    $psi.UseShellExecute = $false
    $psi.CreateNoWindow = $true
    
    $process = [System.Diagnostics.Process]::Start($psi)
    $output = $process.StandardOutput.ReadToEnd()
    $process.WaitForExit()
    
    foreach ($line in $output -split "`r`n") {
        if ($line -match "^(.+?)=(.*)$") {
            $name = $matches[1]
            $value = $matches[2]
            if ($name -match "^(PATH|INCLUDE|LIB|LIBPATH)$") {
                [Environment]::SetEnvironmentVariable($name, $value, "Process")
            }
        }
    }
}

# Create a temporary Lua script to capture health output
$healthScript = @'
-- Capture all health check output
local health_output = {}
local original_print = print

-- Override print to capture output
print = function(...)
  local args = {...}
  local msg = table.concat(vim.tbl_map(tostring, args), "\t")
  table.insert(health_output, msg)
  original_print(...)
end

-- Run health checks for key components
local health_checks = {
  "lazy",
  "mason",
  "nvim-treesitter", 
  "telescope",
  "lsp",
  "vim.lsp",
  "provider"
}

for _, check in ipairs(health_checks) do
  local ok, err = pcall(vim.cmd, "checkhealth " .. check)
  if not ok then
    table.insert(health_output, "Error checking " .. check .. ": " .. tostring(err))
  end
end

-- Write output to file
local file = io.open("health-detailed.txt", "w")
if file then
  file:write("=== NEOVIM HEALTH CHECK REPORT ===\n\n")
  file:write("Generated on: " .. os.date() .. "\n")
  file:write("Neovim version: " .. vim.version().major .. "." .. vim.version().minor .. "." .. vim.version().patch .. "\n\n")
  
  for _, line in ipairs(health_output) do
    file:write(line .. "\n")
  end
  file:close()
end

-- Also run general checkhealth
vim.cmd("checkhealth")
'@

# Write the Lua script to a temporary file
$tempScript = "temp_health.lua"
Set-Content -Path $tempScript -Value $healthScript -Encoding UTF8

try {
    # Run Neovim with the health script
    Write-Host "Ejecutando health checks..." -ForegroundColor Yellow
    
    $process = Start-Process -FilePath "nvim" -ArgumentList "--headless", "-S", $tempScript, "+qa!" -PassThru -RedirectStandardOutput "health-stdout.txt" -RedirectStandardError "health-stderr.txt" -Wait
    
    Write-Host "Health check completado. Código de salida: $($process.ExitCode)" -ForegroundColor Green
    
    # Display results
    Write-Host ""
    Write-Host "📊 RESULTADOS DEL HEALTH CHECK:" -ForegroundColor Cyan
    Write-Host "═══════════════════════════════════════════════════════════════" -ForegroundColor Cyan
    
    if (Test-Path "health-stdout.txt") {
        Write-Host ""
        Write-Host "📋 STDOUT:" -ForegroundColor Green
        Get-Content "health-stdout.txt" | ForEach-Object {
            if ($_ -match "ERROR|WARN|✗") {
                Write-Host $_ -ForegroundColor Red
            } elseif ($_ -match "OK|✓|SUCCESS") {
                Write-Host $_ -ForegroundColor Green
            } else {
                Write-Host $_
            }
        }
    }
    
    if (Test-Path "health-stderr.txt" -and (Get-Content "health-stderr.txt").Length -gt 0) {
        Write-Host ""
        Write-Host "⚠️ STDERR:" -ForegroundColor Yellow
        Get-Content "health-stderr.txt" | Write-Host -ForegroundColor Yellow
    }
    
    if (Test-Path "health-detailed.txt") {
        Write-Host ""
        Write-Host "📝 REPORTE DETALLADO:" -ForegroundColor Cyan
        Get-Content "health-detailed.txt" | ForEach-Object {
            if ($_ -match "ERROR|WARN|✗") {
                Write-Host $_ -ForegroundColor Red
            } elseif ($_ -match "OK|✓|SUCCESS") {
                Write-Host $_ -ForegroundColor Green
            } else {
                Write-Host $_
            }
        }
    }
    
} catch {
    Write-Host "❌ Error ejecutando health check: $($_.Exception.Message)" -ForegroundColor Red
} finally {
    # Cleanup
    if (Test-Path $tempScript) {
        Remove-Item $tempScript -Force
    }
}

Write-Host ""
Write-Host "🔍 Archivos de salida generados:" -ForegroundColor Cyan
@("health-stdout.txt", "health-stderr.txt", "health-detailed.txt") | ForEach-Object {
    if (Test-Path $_) {
        $size = (Get-Item $_).Length
        Write-Host "   • $_ ($size bytes)" -ForegroundColor White
    }
}

Write-Host ""
Write-Host "💡 Para revisar manualmente:" -ForegroundColor Yellow
Write-Host "   nvim +checkhealth" -ForegroundColor White
Write-Host ""
