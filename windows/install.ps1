# ══════════════════════════════════════════════════════════════════════
# Neovim Installation Script for Windows PowerShell
# ══════════════════════════════════════════════════════════════════════

param(
    [switch]$SkipDependencies,
    [switch]$ForceInstall,
    [string]$ConfigSource = "local"
)

# Require Administrator privileges
if (-NOT ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Host "Este script requiere privilegios de administrador. Ejecutando como administrador..." -ForegroundColor Yellow
    Start-Process PowerShell -Verb RunAs "-File `"$($MyInvocation.MyCommand.Path)`" $($MyInvocation.UnboundArguments)"
    exit
}

Write-Host "╔════════════════════════════════════════════════════════════════╗" -ForegroundColor Cyan
Write-Host "║              NVIM VS Code Experience - Installer              ║" -ForegroundColor Cyan  
Write-Host "║                        Para Windows                            ║" -ForegroundColor Cyan
Write-Host "╚════════════════════════════════════════════════════════════════╝" -ForegroundColor Cyan
Write-Host ""

# Functions
function Test-CommandExists {
    param($command)
    $null = Get-Command $command -ErrorAction SilentlyContinue
    return $?
}

function Install-WingetPackage {
    param($PackageName, $PackageId)
    
    Write-Host "Instalando $PackageName..." -ForegroundColor Yellow
    if (Test-CommandExists winget) {
        $result = winget install $PackageId --accept-package-agreements --accept-source-agreements
        if ($LASTEXITCODE -eq 0) {
            Write-Host "✅ $PackageName instalado correctamente" -ForegroundColor Green
        } else {
            Write-Host "❌ Error instalando $PackageName" -ForegroundColor Red
        }
    } else {
        Write-Host "❌ Winget no está disponible" -ForegroundColor Red
    }
}

function Install-ChocoPackage {
    param($PackageName, $PackageId)
    
    Write-Host "Instalando $PackageName con Chocolatey..." -ForegroundColor Yellow
    if (Test-CommandExists choco) {
        choco install $PackageId -y
        if ($LASTEXITCODE -eq 0) {
            Write-Host "✅ $PackageName instalado correctamente" -ForegroundColor Green
        } else {
            Write-Host "❌ Error instalando $PackageName" -ForegroundColor Red
        }
    } else {
        Write-Host "❌ Chocolatey no está disponible" -ForegroundColor Red
    }
}

function Install-NerdFont {
    Write-Host "Instalando JetBrains Mono Nerd Font..." -ForegroundColor Yellow
    
    $fontUrl = "https://github.com/ryanoasis/nerd-fonts/releases/download/v3.1.1/JetBrainsMono.zip"
    $fontPath = "$env:TEMP\JetBrainsMono.zip"
    $extractPath = "$env:TEMP\JetBrainsMono"

    try {
        # Download font
        Invoke-WebRequest -Uri $fontUrl -OutFile $fontPath -UseBasicParsing
        
        # Extract
        Expand-Archive -Path $fontPath -DestinationPath $extractPath -Force
        
        # Install fonts
        $fonts = Get-ChildItem -Path $extractPath -Filter "*.ttf"
        foreach ($font in $fonts) {
            $fontName = $font.Name
            $fontFile = $font.FullName
            
            # Copy to system fonts directory
            Copy-Item -Path $fontFile -Destination "$env:WINDIR\Fonts\$fontName" -Force
            
            # Register in registry
            $fontRegistryPath = "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Fonts"
            $fontDisplayName = $fontName -replace "\.ttf$", " (TrueType)"
            New-ItemProperty -Path $fontRegistryPath -Name $fontDisplayName -Value $fontName -PropertyType String -Force | Out-Null
        }
        
        # Cleanup
        Remove-Item -Path $fontPath -Force
        Remove-Item -Path $extractPath -Recurse -Force
        
        Write-Host "✅ JetBrains Mono Nerd Font instalado correctamente" -ForegroundColor Green
    }
    catch {
        Write-Host "❌ Error instalando JetBrains Mono Nerd Font: $($_.Exception.Message)" -ForegroundColor Red
    }
}

function Install-NodeLSPs {
    Write-Host "Instalando Language Servers de Node.js..." -ForegroundColor Yellow
    
    if (Test-CommandExists npm) {
        $packages = @(
            "typescript-language-server",
            "typescript",
            "@astrojs/language-server",
            "vscode-langservers-extracted",
            "@tailwindcss/language-server",
            "yaml-language-server"
        )
        
        foreach ($package in $packages) {
            Write-Host "Instalando $package..." -ForegroundColor Cyan
            npm install -g $package
        }
        
        Write-Host "✅ Language Servers de Node.js instalados" -ForegroundColor Green
    } else {
        Write-Host "❌ npm no está disponible" -ForegroundColor Red
    }
}

function Install-PythonLSPs {
    Write-Host "Instalando Language Servers de Python..." -ForegroundColor Yellow
    
    if (Test-CommandExists pip) {
        $packages = @(
            "python-lsp-server",
            "pylsp-mypy",
            "python-lsp-black",
            "pyls-isort",
            "debugpy"
        )
        
        foreach ($package in $packages) {
            Write-Host "Instalando $package..." -ForegroundColor Cyan
            pip install $package
        }
        
        Write-Host "✅ Language Servers de Python instalados" -ForegroundColor Green
    } else {
        Write-Host "❌ pip no está disponible" -ForegroundColor Red
    }
}

function Install-GoLSPs {
    Write-Host "Instalando Language Servers de Go..." -ForegroundColor Yellow
    
    if (Test-CommandExists go) {
        Write-Host "Instalando gopls..." -ForegroundColor Cyan
        go install golang.org/x/tools/gopls@latest
        
        Write-Host "Instalando delve (debugger)..." -ForegroundColor Cyan
        go install github.com/go-delve/delve/cmd/dlv@latest
        
        Write-Host "✅ Language Servers de Go instalados" -ForegroundColor Green
    } else {
        Write-Host "❌ go no está disponible" -ForegroundColor Red
    }
}

function Setup-NvimConfig {
    param($Source)
    
    Write-Host "Configurando Neovim..." -ForegroundColor Yellow
    
    $nvimConfigPath = "$env:LOCALAPPDATA\nvim"
    
    # Backup existing config
    if (Test-Path $nvimConfigPath) {
        $backupPath = "$nvimConfigPath.backup.$(Get-Date -Format 'yyyyMMdd_HHmmss')"
        Write-Host "Respaldando configuración existente en $backupPath" -ForegroundColor Cyan
        Move-Item $nvimConfigPath $backupPath
    }
    
    # Create config directory
    New-Item -ItemType Directory -Path $nvimConfigPath -Force | Out-Null
    
    if ($Source -eq "local") {
        # Copy from local windows folder
        $sourceConfig = Join-Path $PSScriptRoot "windows"
        if (Test-Path $sourceConfig) {
            Copy-Item -Path "$sourceConfig\*" -Destination $nvimConfigPath -Recurse -Force
            Write-Host "✅ Configuración copiada desde carpeta local" -ForegroundColor Green
        } else {
            Write-Host "❌ No se encontró la carpeta de configuración local" -ForegroundColor Red
            return $false
        }
    } else {
        # Clone from repository
        if (Test-CommandExists git) {
            try {
                git clone $Source $nvimConfigPath
                Write-Host "✅ Configuración clonada desde repositorio" -ForegroundColor Green
            }
            catch {
                Write-Host "❌ Error clonando repositorio: $($_.Exception.Message)" -ForegroundColor Red
                return $false
            }
        } else {
            Write-Host "❌ Git no está disponible para clonar repositorio" -ForegroundColor Red
            return $false
        }
    }
    
    return $true
}

function Test-Installation {
    Write-Host "Verificando instalación..." -ForegroundColor Yellow
    
    $checks = @{
        "Neovim" = { Test-CommandExists nvim }
        "Git" = { Test-CommandExists git }
        "Node.js" = { Test-CommandExists node }
        "Python" = { Test-CommandExists python }
        "Ripgrep" = { Test-CommandExists rg }
        "fd" = { Test-CommandExists fd }
        "fzf" = { Test-CommandExists fzf }
    }
    
    $allGood = $true
    foreach ($check in $checks.GetEnumerator()) {
        $result = & $check.Value
        if ($result) {
            Write-Host "✅ $($check.Key)" -ForegroundColor Green
        } else {
            Write-Host "❌ $($check.Key)" -ForegroundColor Red
            $allGood = $false
        }
    }
    
    return $allGood
}

# Main installation process
Write-Host "Iniciando instalación..." -ForegroundColor Green
Write-Host ""

if (-not $SkipDependencies) {
    Write-Host "📦 INSTALANDO DEPENDENCIAS" -ForegroundColor Magenta
    Write-Host "─────────────────────────────────────────" -ForegroundColor Magenta
    
    # Check if winget is available
    if (-not (Test-CommandExists winget)) {
        Write-Host "❌ Winget no está disponible. Por favor, instala App Installer desde Microsoft Store." -ForegroundColor Red
        exit 1
    }
    
    # Install core dependencies
    Install-WingetPackage "PowerShell 7" "Microsoft.PowerShell"
    Install-WingetPackage "Git" "Git.Git"
    Install-WingetPackage "Node.js" "OpenJS.NodeJS"
    Install-WingetPackage "Python" "Python.Python.3.12"
    Install-WingetPackage "Neovim" "Neovim.Neovim"
    Install-WingetPackage "Ripgrep" "BurntSushi.ripgrep.MSVC"
    Install-WingetPackage "fd" "sharkdp.fd"
    Install-WingetPackage "fzf" "junegunn.fzf"
    Install-WingetPackage "LazyGit" "JesseDuffield.lazygit"
    Install-WingetPackage "Windows Terminal" "Microsoft.WindowsTerminal"
    
    # Optional: Rust for additional tools
    Write-Host "¿Deseas instalar Rust? (y/N): " -ForegroundColor Yellow -NoNewline
    $rustChoice = Read-Host
    if ($rustChoice -eq "y" -or $rustChoice -eq "Y") {
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
    Write-Host "❌ Error configurando Neovim" -ForegroundColor Red
    exit 1
}
Write-Host ""

Write-Host "🌐 INSTALANDO LANGUAGE SERVERS" -ForegroundColor Magenta
Write-Host "─────────────────────────────────────────" -ForegroundColor Magenta
Install-NodeLSPs
Install-PythonLSPs

# Optional Go installation
Write-Host "¿Deseas instalar Go y sus LSPs? (y/N): " -ForegroundColor Yellow -NoNewline
$goChoice = Read-Host
if ($goChoice -eq "y" -or $goChoice -eq "Y") {
    Install-WingetPackage "Go" "GoLang.Go"
    # Refresh PATH
    $env:PATH = [System.Environment]::GetEnvironmentVariable("PATH", "Machine") + ";" + [System.Environment]::GetEnvironmentVariable("PATH", "User")
    Install-GoLSPs
}
Write-Host ""

Write-Host "✅ VERIFICANDO INSTALACIÓN" -ForegroundColor Magenta
Write-Host "─────────────────────────────────────────" -ForegroundColor Magenta
$installationOk = Test-Installation
Write-Host ""

if ($installationOk) {
    Write-Host "╔════════════════════════════════════════════════════════════════╗" -ForegroundColor Green
    Write-Host "║                    ¡INSTALACIÓN COMPLETADA!                   ║" -ForegroundColor Green
    Write-Host "╚════════════════════════════════════════════════════════════════╝" -ForegroundColor Green
    Write-Host ""
    Write-Host "🎉 Neovim está listo para usar con experiencia VS Code" -ForegroundColor Green
    Write-Host ""
    Write-Host "📋 PRÓXIMOS PASOS:" -ForegroundColor Cyan
    Write-Host "1. Reinicia tu terminal o PowerShell" -ForegroundColor White
    Write-Host "2. Configura Windows Terminal para usar JetBrains Mono Nerd Font" -ForegroundColor White
    Write-Host "3. Ejecuta 'nvim' para abrir Neovim" -ForegroundColor White
    Write-Host "4. Los plugins se instalarán automáticamente en el primer inicio" -ForegroundColor White
    Write-Host "5. Ejecuta ':checkhealth' para verificar la configuración" -ForegroundColor White
    Write-Host ""
    Write-Host "🔧 COMANDOS ÚTILES:" -ForegroundColor Cyan
    Write-Host "• <Space> - Tecla líder principal" -ForegroundColor White
    Write-Host "• <Space>ff - Buscar archivos" -ForegroundColor White
    Write-Host "• <Space>e - Explorador de archivos" -ForegroundColor White
    Write-Host "• <Space>gg - LazyGit" -ForegroundColor White
    Write-Host "• <Ctrl+/> - Comentar línea" -ForegroundColor White
    Write-Host "• <F5> - Iniciar debug" -ForegroundColor White
    Write-Host ""
} else {
    Write-Host "╔════════════════════════════════════════════════════════════════╗" -ForegroundColor Red
    Write-Host "║                  INSTALACIÓN INCOMPLETA                       ║" -ForegroundColor Red
    Write-Host "╚════════════════════════════════════════════════════════════════╝" -ForegroundColor Red
    Write-Host ""
    Write-Host "❌ Algunos componentes no se instalaron correctamente." -ForegroundColor Red
    Write-Host "   Revisa los errores anteriores y reinstala las dependencias faltantes." -ForegroundColor Red
    Write-Host ""
}

Write-Host "Presiona cualquier tecla para continuar..." -ForegroundColor Gray
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
