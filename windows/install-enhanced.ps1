# ══════════════════════════════════════════════════════════════════════
# Enhanced Neovim Installation Script for Windows PowerShell
# Resolves issues with remote execution and improved error handling
# ══════════════════════════════════════════════════════════════════════

param(
    [switch]$SkipDependencies,
    [switch]$ForceInstall,
    [string]$ConfigSource = "github"
)

# Enhanced privilege check
if (-NOT ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Host "⚠️  Se recomienda ejecutar como administrador para mejor compatibilidad" -ForegroundColor Yellow
    $choice = Read-Host "¿Continuar sin privilegios de admin? (y/N)"
    if ($choice -notmatch '^[Yy]$') {
        Write-Host "Reiniciando como administrador..." -ForegroundColor Yellow
        Start-Process PowerShell -Verb RunAs "-File `"$($MyInvocation.MyCommand.Path)`" $($MyInvocation.UnboundArguments)"
        exit
    }
}

Write-Host "╔════════════════════════════════════════════════════════════════╗" -ForegroundColor Cyan
Write-Host "║           NVIM VS Code Experience - Enhanced Installer        ║" -ForegroundColor Cyan  
Write-Host "║                        Para Windows                            ║" -ForegroundColor Cyan
Write-Host "╚════════════════════════════════════════════════════════════════╝" -ForegroundColor Cyan
Write-Host ""

# Enhanced functions
function Test-CommandExists {
    param($command)
    try {
        $null = Get-Command $command -ErrorAction Stop
        return $true
    }
    catch {
        return $false
    }
}

function Install-WingetPackage {
    param($PackageName, $PackageId, [switch]$Optional)
    
    Write-Host "📦 Instalando $PackageName..." -ForegroundColor Yellow
    if (Test-CommandExists winget) {
        try {
            $result = winget install $PackageId --accept-package-agreements --accept-source-agreements --silent
            if ($LASTEXITCODE -eq 0) {
                Write-Host "✅ $PackageName instalado correctamente" -ForegroundColor Green
                return $true
            } else {
                if ($Optional) {
                    Write-Host "⚠️  $PackageName no pudo instalarse (opcional)" -ForegroundColor Yellow
                    return $true
                } else {
                    Write-Host "❌ Error instalando $PackageName" -ForegroundColor Red
                    return $false
                }
            }
        }
        catch {
            Write-Host "❌ Error instalando $PackageName : $($_.Exception.Message)" -ForegroundColor Red
            return $false
        }
    } else {
        Write-Host "❌ Winget no está disponible" -ForegroundColor Red
        return $false
    }
}

function Install-NerdFont {
    Write-Host "🎨 Instalando JetBrains Mono Nerd Font..." -ForegroundColor Yellow
    
    try {
        $fontUrl = "https://github.com/ryanoasis/nerd-fonts/releases/download/v3.1.1/JetBrainsMono.zip"
        $fontPath = "$env:TEMP\JetBrainsMono.zip"
        $extractPath = "$env:TEMP\JetBrainsMono"

        # Download with progress
        $webClient = New-Object System.Net.WebClient
        $webClient.DownloadFile($fontUrl, $fontPath)
        
        # Extract
        Expand-Archive -Path $fontPath -DestinationPath $extractPath -Force
        
        # Install fonts
        $fonts = Get-ChildItem -Path $extractPath -Filter "*.ttf"
        $installedCount = 0
        
        foreach ($font in $fonts) {
            try {
                $fontName = $font.Name
                $fontFile = $font.FullName
                
                # Copy to system fonts directory
                $destinationPath = "$env:WINDIR\Fonts\$fontName"
                if (-not (Test-Path $destinationPath)) {
                    Copy-Item -Path $fontFile -Destination $destinationPath -Force
                    
                    # Register in registry
                    $fontRegistryPath = "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Fonts"
                    $fontDisplayName = $fontName -replace "\.ttf$", " (TrueType)"
                    New-ItemProperty -Path $fontRegistryPath -Name $fontDisplayName -Value $fontName -PropertyType String -Force | Out-Null
                    $installedCount++
                }
            }
            catch {
                # Continue with next font
            }
        }
        
        # Cleanup
        Remove-Item -Path $fontPath -Force
        Remove-Item -Path $extractPath -Recurse -Force
        
        Write-Host "✅ JetBrains Mono Nerd Font instalado ($installedCount fuentes)" -ForegroundColor Green
        return $true
    }
    catch {
        Write-Host "❌ Error instalando fuente: $($_.Exception.Message)" -ForegroundColor Red
        return $false
    }
}

function Install-NodeLSPs {
    Write-Host "🌐 Instalando Language Servers de Node.js..." -ForegroundColor Yellow
    
    if (Test-CommandExists npm) {
        $packages = @(
            "typescript-language-server",
            "typescript",
            "@astrojs/language-server",
            "vscode-langservers-extracted",
            "@tailwindcss/language-server",
            "yaml-language-server",
            "bash-language-server"
        )
        
        $successCount = 0
        foreach ($package in $packages) {
            Write-Host "   📦 Instalando $package..." -ForegroundColor Cyan
            try {
                $null = npm install -g $package --silent
                if ($LASTEXITCODE -eq 0) { $successCount++ }
            }
            catch {
                # Continue with next package
            }
        }
        
        Write-Host "✅ Language Servers de Node.js instalados ($successCount/$($packages.Count))" -ForegroundColor Green
        return $true
    } else {
        Write-Host "❌ npm no está disponible" -ForegroundColor Red
        return $false
    }
}

function Install-PythonLSPs {
    Write-Host "🐍 Instalando Language Servers de Python..." -ForegroundColor Yellow
    
    if (Test-CommandExists pip) {
        $packages = @(
            "python-lsp-server[all]",
            "debugpy",
            "black",
            "isort",
            "flake8"
        )
        
        $successCount = 0
        foreach ($package in $packages) {
            Write-Host "   📦 Instalando $package..." -ForegroundColor Cyan
            try {
                $null = pip install $package --quiet
                if ($LASTEXITCODE -eq 0) { $successCount++ }
            }
            catch {
                # Continue with next package
            }
        }
        
        Write-Host "✅ Language Servers de Python instalados ($successCount/$($packages.Count))" -ForegroundColor Green
        return $true
    } else {
        Write-Host "❌ pip no está disponible" -ForegroundColor Red
        return $false
    }
}

function Install-GoLSPs {
    Write-Host "🔧 Instalando Language Servers de Go..." -ForegroundColor Yellow
    
    if (Test-CommandExists go) {
        try {
            Write-Host "   📦 Instalando gopls..." -ForegroundColor Cyan
            go install golang.org/x/tools/gopls@latest
            
            Write-Host "   📦 Instalando delve (debugger)..." -ForegroundColor Cyan
            go install github.com/go-delve/delve/cmd/dlv@latest
            
            Write-Host "✅ Language Servers de Go instalados" -ForegroundColor Green
            return $true
        }
        catch {
            Write-Host "❌ Error instalando herramientas de Go" -ForegroundColor Red
            return $false
        }
    } else {
        Write-Host "❌ go no está disponible" -ForegroundColor Red
        return $false
    }
}

function Setup-NvimConfig {
    param($Source)
    
    Write-Host "⚙️ Configurando Neovim..." -ForegroundColor Yellow
    
    $nvimConfigPath = "$env:LOCALAPPDATA\nvim"
    
    # Backup existing config
    if (Test-Path $nvimConfigPath) {
        $backupPath = "$nvimConfigPath.backup.$(Get-Date -Format 'yyyyMMdd_HHmmss')"
        Write-Host "💾 Respaldando configuración existente en $backupPath" -ForegroundColor Cyan
        Move-Item $nvimConfigPath $backupPath
    }
    
    # Create config directory
    New-Item -ItemType Directory -Path $nvimConfigPath -Force | Out-Null
    
    if ($Source -eq "github" -or $Source -eq "remote") {
        # Download from GitHub
        Write-Host "📥 Descargando configuración desde GitHub..." -ForegroundColor Cyan
        
        try {
            $repoUrl = "https://github.com/sazardev/nvim-vscode-config.git"
            $tempPath = "$env:TEMP\nvim-config-temp"
            
            # Clean temp directory
            if (Test-Path $tempPath) {
                Remove-Item -Path $tempPath -Recurse -Force
            }
            
            # Clone repository
            git clone --depth 1 $repoUrl $tempPath
            
            # Copy Windows configuration
            if (Test-Path "$tempPath\windows") {
                Copy-Item -Path "$tempPath\windows\*" -Destination $nvimConfigPath -Recurse -Force
                Write-Host "✅ Configuración descargada e instalada" -ForegroundColor Green
                
                # Apply fixes immediately
                Write-Host "🔧 Aplicando correcciones de configuración..." -ForegroundColor Cyan
                $optionsFile = "$nvimConfigPath\lua\config\options.lua"
                if (Test-Path $optionsFile) {
                    $content = Get-Content $optionsFile -Raw
                    
                    # Fix fillchars
                    $content = $content -replace 'foldopen = ""', 'foldopen = ""'
                    $content = $content -replace 'foldclose = ""', 'foldclose = ""'
                    
                    # Remove problematic fold settings from options.lua
                    $content = $content -replace 'opt\.foldmethod = "expr".*\r?\n', ''
                    $content = $content -replace 'opt\.foldexpr = "nvim_treesitter#foldexpr\(\)".*\r?\n', ''
                    
                    Set-Content -Path $optionsFile -Value $content -Encoding UTF8
                    Write-Host "✅ Correcciones aplicadas" -ForegroundColor Green
                }
            } else {
                throw "No se encontró la configuración de Windows en el repositorio"
            }
            
            # Cleanup
            Remove-Item -Path $tempPath -Recurse -Force
            return $true
        }
        catch {
            Write-Host "❌ Error descargando configuración: $($_.Exception.Message)" -ForegroundColor Red
            return $false
        }
    } else {
        # Try to find local configuration
        $possiblePaths = @(
            ".\windows",
            "..\windows", 
            ".\lua",
            "."
        )
        
        $sourceFound = $false
        foreach ($possiblePath in $possiblePaths) {
            $resolvedPath = Resolve-Path $possiblePath -ErrorAction SilentlyContinue
            if ($resolvedPath -and (Test-Path "$resolvedPath\init.lua" -Or Test-Path "$resolvedPath\lua")) {
                Copy-Item -Path "$resolvedPath\*" -Destination $nvimConfigPath -Recurse -Force
                Write-Host "✅ Configuración copiada desde carpeta local" -ForegroundColor Green
                $sourceFound = $true
                break
            }
        }
        
        if (-not $sourceFound) {
            Write-Host "⚠️  No se encontró configuración local, descargando desde GitHub..." -ForegroundColor Yellow
            return Setup-NvimConfig "github"
        }
        
        return $true
    }
}

function Test-Installation {
    Write-Host "🔍 Verificando instalación..." -ForegroundColor Yellow
    
    $checks = @{
        "Neovim" = { Test-CommandExists nvim }
        "Git" = { Test-CommandExists git }
        "Node.js" = { Test-CommandExists node }
        "Python" = { Test-CommandExists python }
        "Ripgrep" = { Test-CommandExists rg }
        "fd" = { Test-CommandExists fd }
        "fzf" = { Test-CommandExists fzf }
    }
    
    $passed = 0
    $total = $checks.Count
    
    foreach ($check in $checks.GetEnumerator()) {
        $result = & $check.Value
        if ($result) {
            Write-Host "   ✅ $($check.Key)" -ForegroundColor Green
            $passed++
        } else {
            Write-Host "   ❌ $($check.Key)" -ForegroundColor Red
        }
    }
    
    # Check config
    if (Test-Path "$env:LOCALAPPDATA\nvim\init.lua") {
        Write-Host "   ✅ Configuración de Neovim" -ForegroundColor Green
        $passed++
        $total++
    } else {
        Write-Host "   ❌ Configuración de Neovim" -ForegroundColor Red
        $total++
    }
    
    Write-Host ""
    Write-Host "📊 Resultado: $passed/$total componentes verificados" -ForegroundColor Cyan
    
    return ($passed -eq $total)
}

function Show-FinalMessage {
    param([bool]$Success)
    
    if ($Success) {
        Write-Host "╔════════════════════════════════════════════════════════════════╗" -ForegroundColor Green
        Write-Host "║                    ¡INSTALACIÓN COMPLETADA!                   ║" -ForegroundColor Green
        Write-Host "╚════════════════════════════════════════════════════════════════╝" -ForegroundColor Green
        Write-Host ""
        Write-Host "🎉 Neovim con experiencia VS Code está listo para usar" -ForegroundColor Green
        Write-Host ""
        Write-Host "📋 PRÓXIMOS PASOS:" -ForegroundColor Cyan
        Write-Host "   1. 🔄 Reinicia tu terminal o PowerShell" -ForegroundColor White
        Write-Host "   2. 🎨 Configura Windows Terminal para usar JetBrains Mono Nerd Font" -ForegroundColor White
        Write-Host "   3. 🚀 Ejecuta 'nvim' para abrir Neovim" -ForegroundColor White
        Write-Host "   4. 🔧 Los plugins se instalarán automáticamente" -ForegroundColor White
        Write-Host "   5. 🏥 Ejecuta ':checkhealth' para verificar la configuración" -ForegroundColor White
        Write-Host ""
        Write-Host "⌨️ ATAJOS PRINCIPALES:" -ForegroundColor Cyan
        Write-Host "   • <Space> - Tecla líder principal" -ForegroundColor White
        Write-Host "   • <Space>ff - Buscar archivos" -ForegroundColor White
        Write-Host "   • <Space>e - Explorador de archivos" -ForegroundColor White
        Write-Host "   • <Space>gg - LazyGit" -ForegroundColor White
        Write-Host "   • <Ctrl+/> - Comentar línea" -ForegroundColor White
        Write-Host "   • <F5> - Iniciar debug" -ForegroundColor White
        Write-Host ""
    } else {
        Write-Host "╔════════════════════════════════════════════════════════════════╗" -ForegroundColor Red
        Write-Host "║                  INSTALACIÓN INCOMPLETA                       ║" -ForegroundColor Red
        Write-Host "╚════════════════════════════════════════════════════════════════╝" -ForegroundColor Red
        Write-Host ""
        Write-Host "❌ Algunos componentes no se instalaron correctamente." -ForegroundColor Red
        Write-Host ""
        Write-Host "🔧 SOLUCIONES SUGERIDAS:" -ForegroundColor Yellow
        Write-Host "   • Ejecuta el script como administrador" -ForegroundColor White
        Write-Host "   • Instala manualmente los componentes faltantes" -ForegroundColor White
        Write-Host "   • Verifica tu conexión a internet" -ForegroundColor White
        Write-Host "   • Actualiza winget: winget upgrade --all" -ForegroundColor White
        Write-Host ""
    }
}

# Main installation process
Write-Host "🚀 Iniciando instalación mejorada..." -ForegroundColor Green
Write-Host ""

if (-not $SkipDependencies) {
    Write-Host "📦 VERIFICANDO WINGET" -ForegroundColor Magenta
    Write-Host "─────────────────────────────────────────" -ForegroundColor Magenta
    
    if (-not (Test-CommandExists winget)) {
        Write-Host "❌ Winget no está disponible" -ForegroundColor Red
        Write-Host "💡 Instala App Installer desde Microsoft Store" -ForegroundColor Yellow
        Write-Host "   O descarga desde: https://aka.ms/getwinget" -ForegroundColor Yellow
        exit 1
    }
    Write-Host "✅ Winget disponible" -ForegroundColor Green
    
    Write-Host ""
    Write-Host "📦 INSTALANDO DEPENDENCIAS PRINCIPALES" -ForegroundColor Magenta
    Write-Host "─────────────────────────────────────────" -ForegroundColor Magenta
    
    # Core dependencies
    $mainPackages = @(
        @("Git", "Git.Git"),
        @("Node.js", "OpenJS.NodeJS"),
        @("Python", "Python.Python.3.12"),
        @("Neovim", "Neovim.Neovim")
    )
    
    foreach ($package in $mainPackages) {
        Install-WingetPackage $package[0] $package[1]
    }
    
    Write-Host ""
    Write-Host "📦 INSTALANDO HERRAMIENTAS DE DESARROLLO" -ForegroundColor Magenta
    Write-Host "─────────────────────────────────────────" -ForegroundColor Magenta
    
    # Development tools
    $devPackages = @(
        @("Ripgrep", "BurntSushi.ripgrep.MSVC"),
        @("fd", "sharkdp.fd"),
        @("fzf", "junegunn.fzf"),
        @("LazyGit", "JesseDuffield.lazygit"),
        @("Windows Terminal", "Microsoft.WindowsTerminal")
    )
    
    foreach ($package in $devPackages) {
        Install-WingetPackage $package[0] $package[1] -Optional
    }
    
    # Optional: Rust
    Write-Host ""
    $rustChoice = Read-Host "¿Deseas instalar Rust? (y/N)"
    if ($rustChoice -match '^[Yy]$') {
        Install-WingetPackage "Rust" "Rustlang.Rust.MSVC"
    }
    
    Write-Host ""
}

Write-Host "🎨 INSTALANDO FUENTES" -ForegroundColor Magenta
Write-Host "─────────────────────────────────────────" -ForegroundColor Magenta
Install-NerdFont
Write-Host ""

Write-Host "🛠️ CONFIGURANDO NEOVIM" -ForegroundColor Magenta
Write-Host "─────────────────────────────────────────" -ForegroundColor Magenta
$configSuccess = Setup-NvimConfig $ConfigSource
if (-not $configSuccess) {
    Write-Host "❌ Error crítico configurando Neovim" -ForegroundColor Red
    exit 1
}
Write-Host ""

Write-Host "🌐 INSTALANDO LANGUAGE SERVERS" -ForegroundColor Magenta
Write-Host "─────────────────────────────────────────" -ForegroundColor Magenta
Install-NodeLSPs
Install-PythonLSPs

# Optional Go installation
Write-Host ""
$goChoice = Read-Host "¿Deseas instalar Go y sus LSPs? (y/N)"
if ($goChoice -match '^[Yy]$') {
    Install-WingetPackage "Go" "GoLang.Go"
    # Refresh PATH for current session
    $env:PATH = [System.Environment]::GetEnvironmentVariable("PATH", "Machine") + ";" + [System.Environment]::GetEnvironmentVariable("PATH", "User")
    Install-GoLSPs
}
Write-Host ""

Write-Host "✅ VERIFICANDO INSTALACIÓN" -ForegroundColor Magenta
Write-Host "─────────────────────────────────────────" -ForegroundColor Magenta
$installationOk = Test-Installation
Write-Host ""

# Show final message
Show-FinalMessage $installationOk

Write-Host "Presiona cualquier tecla para continuar..." -ForegroundColor Gray
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
