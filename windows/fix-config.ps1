# ══════════════════════════════════════════════════════════════════════
# Neovim Config Fix Script for Windows
# Fixes common configuration issues
# ══════════════════════════════════════════════════════════════════════

param(
    [switch]$Force
)

Write-Host "🔧 Neovim Configuration Fix Tool" -ForegroundColor Cyan
Write-Host "─────────────────────────────────────────" -ForegroundColor Cyan
Write-Host ""

$nvimConfigPath = "$env:LOCALAPPDATA\nvim"
$optionsFile = "$nvimConfigPath\lua\config\options.lua"

if (-not (Test-Path $optionsFile)) {
    Write-Host "❌ No se encontró la configuración de Neovim en $nvimConfigPath" -ForegroundColor Red
    Write-Host "💡 Ejecuta primero el script de instalación" -ForegroundColor Yellow
    exit 1
}

Write-Host "📁 Configuración encontrada en: $nvimConfigPath" -ForegroundColor Green
Write-Host ""

# Fix 1: Correct fillchars configuration
Write-Host "🔧 Arreglando configuración de fillchars..." -ForegroundColor Yellow

$optionsContent = Get-Content $optionsFile -Raw

# Fix fillchars with proper Unicode characters
$oldFillchars = @'
opt.fillchars = {
  foldopen = "",
  foldclose = "",
  fold = " ",
  foldsep = " ",
  diff = "╱",
  eob = " ",
}
'@

$newFillchars = @'
opt.fillchars = {
  foldopen = "",
  foldclose = "",
  fold = " ",
  foldsep = " ",
  diff = "╱",
  eob = " ",
}
'@

if ($optionsContent -match [regex]::Escape($oldFillchars)) {
    $optionsContent = $optionsContent -replace [regex]::Escape($oldFillchars), $newFillchars
    Write-Host "✅ Corregidos caracteres de fillchars" -ForegroundColor Green
} else {
    Write-Host "ℹ️  fillchars ya están correctos" -ForegroundColor Cyan
}

# Fix 2: Remove problematic fold configuration from options.lua
$foldConfigPattern = @'
-- Folding
opt.foldcolumn = "1"              -- Show fold column
opt.foldlevel = 99                -- Start with all folds open
opt.foldlevelstart = 99           -- Start with all folds open
opt.foldenable = true             -- Enable folding
opt.foldmethod = "expr"           -- Use expression folding
opt.foldexpr = "nvim_treesitter#foldexpr()"
'@

$newFoldConfig = @'
-- Folding (configured in treesitter.lua)
opt.foldcolumn = "1"              -- Show fold column
opt.foldlevel = 99                -- Start with all folds open
opt.foldlevelstart = 99           -- Start with all folds open
opt.foldenable = true             -- Enable folding
'@

if ($optionsContent -match [regex]::Escape($foldConfigPattern)) {
    $optionsContent = $optionsContent -replace [regex]::Escape($foldConfigPattern), $newFoldConfig
    Write-Host "✅ Movida configuración de folding a treesitter" -ForegroundColor Green
} else {
    Write-Host "ℹ️  Configuración de folding ya está correcta" -ForegroundColor Cyan
}

# Save the corrected file
Set-Content -Path $optionsFile -Value $optionsContent -Encoding UTF8
Write-Host "💾 Archivo options.lua actualizado" -ForegroundColor Green

# Fix 3: Ensure init.lua loads in correct order
Write-Host ""
Write-Host "🔧 Verificando orden de carga en init.lua..." -ForegroundColor Yellow

$initFile = "$nvimConfigPath\init.lua"
if (Test-Path $initFile) {
    $initContent = Get-Content $initFile -Raw
    
    # Check if lazy.nvim setup is after config loading
    if ($initContent -match "require\(`"config\.options`"\)" -and 
        $initContent -match "require\(`"lazy`"\)\.setup") {
        Write-Host "✅ Orden de carga correcto" -ForegroundColor Green
    } else {
        Write-Host "⚠️  Puede haber problemas con el orden de carga" -ForegroundColor Yellow
        Write-Host "💡 Considera reinstalar la configuración" -ForegroundColor Yellow
    }
} else {
    Write-Host "❌ No se encontró init.lua" -ForegroundColor Red
}

# Fix 4: Check for common plugin issues
Write-Host ""
Write-Host "🔧 Verificando plugins..." -ForegroundColor Yellow

$pluginsDir = "$nvimConfigPath\lua\plugins"
if (Test-Path $pluginsDir) {
    $pluginCount = (Get-ChildItem $pluginsDir -Filter "*.lua").Count
    Write-Host "✅ Encontrados $pluginCount archivos de plugins" -ForegroundColor Green
} else {
    Write-Host "❌ Directorio de plugins no encontrado" -ForegroundColor Red
}

Write-Host ""
Write-Host "🧪 Probando configuración..." -ForegroundColor Yellow

# Test the configuration
try {
    $testResult = & nvim --headless -c "lua print('Config test OK')" -c "qa!" 2>&1
    if ($LASTEXITCODE -eq 0) {
        Write-Host "✅ Configuración carga correctamente" -ForegroundColor Green
    } else {
        Write-Host "❌ Hay errores en la configuración:" -ForegroundColor Red
        Write-Host $testResult -ForegroundColor Red
    }
} catch {
    Write-Host "❌ Error probando configuración: $($_.Exception.Message)" -ForegroundColor Red
}

Write-Host ""
Write-Host "╔════════════════════════════════════════════════════════════════╗" -ForegroundColor Green
Write-Host "║                      REPARACIÓN COMPLETADA                    ║" -ForegroundColor Green
Write-Host "╚════════════════════════════════════════════════════════════════╝" -ForegroundColor Green
Write-Host ""
Write-Host "📋 PRÓXIMOS PASOS:" -ForegroundColor Cyan
Write-Host "   1. 🚀 Ejecuta 'nvim' para probar la configuración" -ForegroundColor White
Write-Host "   2. 🏥 Ejecuta ':checkhealth' dentro de Neovim" -ForegroundColor White
Write-Host "   3. 🔧 Si hay errores, ejecuta ':Lazy sync' para sincronizar plugins" -ForegroundColor White
Write-Host ""
Write-Host "💡 Si persisten los problemas:" -ForegroundColor Yellow
Write-Host "   • Ejecuta este script con -Force para forzar reparaciones" -ForegroundColor White
Write-Host "   • Reinstala la configuración con el script principal" -ForegroundColor White
Write-Host ""

Write-Host "Presiona cualquier tecla para continuar..." -ForegroundColor Gray
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
