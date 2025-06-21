# ══════════════════════════════════════════════════════════════════════
# Quick Neovim Launcher for Windows
# ══════════════════════════════════════════════════════════════════════

Write-Host "🚀 Iniciando Neovim con configuración VS Code..." -ForegroundColor Cyan
Write-Host ""

# Refresh PATH
$env:PATH = [System.Environment]::GetEnvironmentVariable("PATH", "Machine") + ";" + [System.Environment]::GetEnvironmentVariable("PATH", "User")

# Check if nvim is available
if (-not (Get-Command nvim -ErrorAction SilentlyContinue)) {
    Write-Host "❌ Neovim no está en el PATH" -ForegroundColor Red
    Write-Host "💡 Ejecuta el script de instalación primero" -ForegroundColor Yellow
    exit 1
}

# Check configuration
$configPath = "$env:LOCALAPPDATA\nvim"
if (-not (Test-Path "$configPath\init.lua")) {
    Write-Host "❌ No se encontró la configuración de Neovim" -ForegroundColor Red
    Write-Host "💡 Ejecuta el script de instalación primero" -ForegroundColor Yellow
    exit 1
}

Write-Host "✅ Configuración encontrada en: $configPath" -ForegroundColor Green
Write-Host ""

# Test configuration loads without errors
Write-Host "🧪 Probando configuración..." -ForegroundColor Yellow
try {
    $testResult = & nvim --headless -c "lua print('Config OK')" -c "qa!" 2>&1
    if ($LASTEXITCODE -eq 0) {
        Write-Host "✅ Configuración carga correctamente" -ForegroundColor Green
    } else {
        Write-Host "⚠️  Hay advertencias en la configuración:" -ForegroundColor Yellow
        Write-Host $testResult -ForegroundColor Yellow
    }
} catch {
    Write-Host "❌ Error en la configuración: $($_.Exception.Message)" -ForegroundColor Red
    Write-Host "🔧 Ejecuta el script fix-config.ps1 para reparar" -ForegroundColor Yellow
}

Write-Host ""
Write-Host "📋 CONSEJOS RÁPIDOS:" -ForegroundColor Cyan
Write-Host "   • <Space> es la tecla líder principal" -ForegroundColor White
Write-Host "   • <Space>ff para buscar archivos" -ForegroundColor White
Write-Host "   • <Space>e para el explorador" -ForegroundColor White
Write-Host "   • :checkhealth para verificar la configuración" -ForegroundColor White
Write-Host "   • :Lazy para gestionar plugins" -ForegroundColor White
Write-Host ""

Write-Host "🎨 Asegúrate de configurar tu terminal para usar JetBrains Mono Nerd Font" -ForegroundColor Yellow
Write-Host ""

# Launch Neovim
Write-Host "Iniciando Neovim..." -ForegroundColor Green
Start-Sleep -Seconds 1
& nvim $args
