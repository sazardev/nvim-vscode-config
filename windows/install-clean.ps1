# ══════════════════════════════════════════════════════════════════════
# Neovim Installation Script - Simple and Reliable
# ══════════════════════════════════════════════════════════════════════

Write-Host "╔════════════════════════════════════════════════════════════════╗" -ForegroundColor Cyan
Write-Host "║         NVIM VS Code Experience - Instalación Limpia          ║" -ForegroundColor Cyan  
Write-Host "║                        Para Windows                            ║" -ForegroundColor Cyan
Write-Host "╚════════════════════════════════════════════════════════════════╝" -ForegroundColor Cyan
Write-Host ""

function Test-CommandExists {
    param($command)
    $null = Get-Command $command -ErrorAction SilentlyContinue
    return $?
}

function Setup-NvimConfig {
    Write-Host "🛠️ Configurando Neovim..." -ForegroundColor Yellow
    
    $nvimConfigPath = "$env:LOCALAPPDATA\nvim"
    $scriptDir = $PSScriptRoot
    
    # Remove existing config completely
    if (Test-Path $nvimConfigPath) {
        Write-Host "🗑️ Eliminando configuración anterior..." -ForegroundColor Yellow
        Remove-Item $nvimConfigPath -Recurse -Force
    }
    
    # Remove plugin data too
    $nvimDataPath = "$env:LOCALAPPDATA\nvim-data"
    if (Test-Path $nvimDataPath) {
        Write-Host "🗑️ Eliminando datos de plugins..." -ForegroundColor Yellow
        Remove-Item $nvimDataPath -Recurse -Force
    }
    
    # Create new config directory
    New-Item -ItemType Directory -Path $nvimConfigPath -Force | Out-Null
    
    # Copy configuration files
    try {
        if (Test-Path "$scriptDir\init.lua") {
            Copy-Item -Path "$scriptDir\init.lua" -Destination $nvimConfigPath -Force
            Write-Host "✅ init.lua copiado" -ForegroundColor Green
        }
        
        if (Test-Path "$scriptDir\lua") {
            Copy-Item -Path "$scriptDir\lua" -Destination $nvimConfigPath -Recurse -Force
            Write-Host "✅ Configuración lua copiada" -ForegroundColor Green
        }
        
        Write-Host "✅ Configuración instalada desde directorio local" -ForegroundColor Green
        return $true
    }
    catch {
        Write-Host "❌ Error copiando configuración: $($_.Exception.Message)" -ForegroundColor Red
        return $false
    }
}

function Test-Installation {
    Write-Host "🔍 Verificando instalación..." -ForegroundColor Yellow
    
    $allGood = $true
    
    # Check Neovim
    if (Test-CommandExists nvim) {
        Write-Host "✅ Neovim" -ForegroundColor Green
    } else {
        Write-Host "❌ Neovim no encontrado" -ForegroundColor Red
        $allGood = $false
    }
    
    # Check config
    if (Test-Path "$env:LOCALAPPDATA\nvim\init.lua") {
        Write-Host "✅ Configuración de Neovim" -ForegroundColor Green
    } else {
        Write-Host "❌ Configuración de Neovim" -ForegroundColor Red
        $allGood = $false
    }
    
    return $allGood
}

function Test-NvimConfig {
    Write-Host "🧪 Probando configuración de Neovim..." -ForegroundColor Yellow
    
    try {
        # Test basic config loading
        $result = & nvim --headless "+echo 'Config test passed'" "+qa" 2>&1
        
        if ($LASTEXITCODE -eq 0) {
            Write-Host "✅ Configuración carga sin errores" -ForegroundColor Green
            return $true
        } else {
            Write-Host "❌ Error en configuración:" -ForegroundColor Red
            Write-Host $result -ForegroundColor Yellow
            return $false
        }
    }
    catch {
        Write-Host "❌ Error probando configuración: $($_.Exception.Message)" -ForegroundColor Red
        return $false
    }
}

# Main execution
Write-Host "🚀 Iniciando instalación limpia..." -ForegroundColor Green
Write-Host ""

# Setup configuration
$configSuccess = Setup-NvimConfig

if ($configSuccess) {
    Write-Host ""
    $testSuccess = Test-Installation
    
    if ($testSuccess) {
        Write-Host ""
        $configTestSuccess = Test-NvimConfig
        
        if ($configTestSuccess) {
            Write-Host ""
            Write-Host "╔════════════════════════════════════════════════════════════════╗" -ForegroundColor Green
            Write-Host "║                 ¡INSTALACIÓN COMPLETADA!                      ║" -ForegroundColor Green
            Write-Host "╚════════════════════════════════════════════════════════════════╝" -ForegroundColor Green
            Write-Host ""
            Write-Host "🎉 Neovim está configurado y listo para usar" -ForegroundColor Green
            Write-Host ""
            Write-Host "📋 PRÓXIMOS PASOS:" -ForegroundColor Cyan
            Write-Host "1. Ejecuta '.\nvim-with-buildtools.ps1' para usar Neovim con compilador" -ForegroundColor White
            Write-Host "2. O simplemente 'nvim' para uso normal" -ForegroundColor White
            Write-Host "3. Los plugins se instalarán automáticamente en el primer uso" -ForegroundColor White
            Write-Host ""
        } else {
            Write-Host "⚠️ Configuración instalada pero hay errores. Revisa los archivos." -ForegroundColor Yellow
        }
    } else {
        Write-Host "❌ Instalación incompleta" -ForegroundColor Red
    }
} else {
    Write-Host "❌ Error configurando Neovim" -ForegroundColor Red
}

Write-Host ""
Write-Host "Presiona cualquier tecla para continuar..." -ForegroundColor Gray
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
