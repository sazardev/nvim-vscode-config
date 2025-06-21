# Installation guide for Windows & Setup Instructions for Neovim Configuration

## Prerrequisitos

Antes de instalar Neovim, asegúrate de tener los siguientes componentes instalados:

### 1. Windows PowerShell 7+
```powershell
# Instalar PowerShell 7 si no lo tienes
winget install Microsoft.PowerShell
```

### 2. Git
```powershell
# Instalar Git
winget install Git.Git
```

### 3. Node.js (para LSP servers)
```powershell
# Instalar Node.js
winget install OpenJS.NodeJS
```

### 4. Python (para algunos plugins)
```powershell
# Instalar Python
winget install Python.Python.3.12
```

### 5. Rust y Cargo (para herramientas adicionales)
```powershell
# Instalar Rust
winget install Rustlang.Rust.MSVC
```

## Instalación de Neovim

### Opción 1: Usando winget (Recomendado)
```powershell
winget install Neovim.Neovim
```

### Opción 2: Usando Chocolatey
```powershell
# Primero instalar Chocolatey si no lo tienes
Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))

# Luego instalar Neovim
choco install neovim
```

### Opción 3: Descarga manual
Descarga el ejecutable desde [GitHub releases](https://github.com/neovim/neovim/releases) y añádelo al PATH.

## Herramientas adicionales

### 1. Ripgrep (para búsqueda rápida)
```powershell
winget install BurntSushi.ripgrep.MSVC
```

### 2. fd (para búsqueda de archivos)
```powershell
winget install sharkdp.fd
```

### 3. Fzf (para fuzzy finding)
```powershell
winget install junegunn.fzf
```

### 4. Lazygit (para gestión de Git)
```powershell
winget install JesseDuffield.lazygit
```

### 5. Windows Terminal (para mejor experiencia de terminal)
```powershell
winget install Microsoft.WindowsTerminal
```

## Fonts (Nerd Fonts)

Para que los iconos se muestren correctamente, instala una Nerd Font:

```powershell
# Descargar e instalar JetBrains Mono Nerd Font
$fontUrl = "https://github.com/ryanoasis/nerd-fonts/releases/download/v3.1.1/JetBrainsMono.zip"
$fontPath = "$env:TEMP\JetBrainsMono.zip"
$extractPath = "$env:TEMP\JetBrainsMono"

Invoke-WebRequest -Uri $fontUrl -OutFile $fontPath
Expand-Archive -Path $fontPath -DestinationPath $extractPath -Force

# Instalar las fuentes
$fonts = Get-ChildItem -Path $extractPath -Filter "*.ttf"
foreach ($font in $fonts) {
    $fontName = $font.Name
    $fontFile = $font.FullName
    
    # Copiar al directorio de fuentes del sistema
    Copy-Item -Path $fontFile -Destination "$env:WINDIR\Fonts\$fontName" -Force
    
    # Registrar en el registro
    $fontRegistryPath = "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Fonts"
    $fontDisplayName = $fontName -replace "\.ttf$", " (TrueType)"
    Set-ItemProperty -Path $fontRegistryPath -Name $fontDisplayName -Value $fontName
}

# Limpiar archivos temporales
Remove-Item -Path $fontPath -Force
Remove-Item -Path $extractPath -Recurse -Force

Write-Host "JetBrains Mono Nerd Font instalada correctamente"
```

## Configuración de Neovim

### 1. Crear directorios de configuración
```powershell
# Crear el directorio de configuración de Neovim
$nvimConfigPath = "$env:LOCALAPPDATA\nvim"
if (-not (Test-Path $nvimConfigPath)) {
    New-Item -ItemType Directory -Path $nvimConfigPath -Force
}

# Crear subdirectorios
@("lua", "lua\config", "lua\plugins") | ForEach-Object {
    $dir = Join-Path $nvimConfigPath $_
    if (-not (Test-Path $dir)) {
        New-Item -ItemType Directory -Path $dir -Force
    }
}
```

### 2. Clonar esta configuración
```powershell
# Navegar al directorio de configuración
cd $env:LOCALAPPDATA

# Respaldar configuración existente si existe
if (Test-Path "nvim") {
    Rename-Item "nvim" "nvim.backup.$(Get-Date -Format 'yyyyMMdd_HHmmss')"
}

# Clonar la configuración
git clone https://github.com/tu-usuario/nvim-vscode-config.git nvim

# O copiar los archivos de configuración de este repositorio
```

## Instalación de Language Servers

### Typescript/JavaScript
```powershell
npm install -g typescript-language-server typescript
```

### Python
```powershell
pip install python-lsp-server
```

### Go
```powershell
go install golang.org/x/tools/gopls@latest
```

### Rust
```powershell
rustup component add rust-analyzer
```

### Lua
```powershell
# Descargar lua-language-server desde GitHub releases
winget install sumneko.lua-language-server
```

## Configuración de Windows Terminal

Actualiza tu `settings.json` de Windows Terminal para usar JetBrains Mono:

```json
{
    "profiles": {
        "defaults": {
            "font": {
                "face": "JetBrainsMono Nerd Font",
                "size": 12
            }
        }
    }
}
```

## Verificación de la instalación

```powershell
# Verificar que Neovim está instalado
nvim --version

# Verificar herramientas adicionales
git --version
node --version
python --version
rg --version
fd --version
fzf --version
lazygit --version
```

## Primeros pasos

1. Abre PowerShell o Windows Terminal
2. Ejecuta `nvim` para abrir Neovim
3. La primera vez, los plugins se instalarán automáticamente
4. Reinicia Neovim después de la instalación inicial
5. Ejecuta `:checkhealth` para verificar que todo esté funcionando

## Comandos útiles

- `:PackerSync` - Sincronizar plugins
- `:Mason` - Gestionar Language Servers
- `:checkhealth` - Verificar configuración
- `:Telescope` - Navegador de archivos y fuzzy finder
- `<Space>` - Tecla líder principal

## Troubleshooting

### Error de plugins
```powershell
# Limpiar caché de plugins
Remove-Item -Path "$env:LOCALAPPDATA\nvim-data" -Recurse -Force
```

### Problemas de PATH
```powershell
# Agregar Neovim al PATH manualmente
$env:PATH += ";C:\Program Files\Neovim\bin"
# Para hacerlo permanente, usa el Panel de Control > Sistema > Variables de entorno
```