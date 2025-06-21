#!/usr/bin/env bash
# ══════════════════════════════════════════════════════════════════════
# Neovim Installation Script for Android (Termux) - Enhanced Version
# ══════════════════════════════════════════════════════════════════════

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
GRAY='\033[0;37m'
NC='\033[0m' # No Color

# Configuration
SKIP_DEPENDENCIES=${SKIP_DEPENDENCIES:-false}
FORCE_INSTALL=${FORCE_INSTALL:-false}
CONFIG_SOURCE=${CONFIG_SOURCE:-"github"}
REPO_URL="https://github.com/sazardev/nvim-vscode-config.git"

echo -e "${CYAN}╔════════════════════════════════════════════════════════════════╗${NC}"
echo -e "${CYAN}║              NVIM VS Code Experience - Installer              ║${NC}"
echo -e "${CYAN}║                      Para Android/Termux                      ║${NC}"
echo -e "${CYAN}║                        Versión Mejorada                       ║${NC}"
echo -e "${CYAN}╚════════════════════════════════════════════════════════════════╝${NC}"
echo ""

# Check if running in Termux
if [ ! -d "/data/data/com.termux" ]; then
    echo -e "${RED}❌ Este script debe ejecutarse en Termux${NC}"
    echo -e "${YELLOW}💡 Pasos para instalar:${NC}"
    echo -e "${NC}   1. Instala Termux desde F-Droid o Google Play Store${NC}"
    echo -e "${NC}   2. Abre Termux y ejecuta: pkg update && pkg upgrade${NC}"
    echo -e "${NC}   3. Ejecuta: termux-setup-storage${NC}"
    echo -e "${NC}   4. Vuelve a ejecutar este script${NC}"
    exit 1
fi

# Functions
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

install_package() {
    local package_name="$1"
    local display_name="$2"
    
    echo -e "${YELLOW}📦 Instalando $display_name...${NC}"
    if pkg install -y "$package_name" >/dev/null 2>&1; then
        echo -e "${GREEN}✅ $display_name instalado correctamente${NC}"
        return 0
    else
        echo -e "${RED}❌ Error instalando $display_name${NC}"
        return 1
    fi
}

setup_storage() {
    echo -e "${YELLOW}📁 Configurando acceso al almacenamiento...${NC}"
    if termux-setup-storage >/dev/null 2>&1; then
        echo -e "${GREEN}✅ Acceso al almacenamiento configurado${NC}"
    else
        echo -e "${YELLOW}⚠️  Configuración de almacenamiento omitida${NC}"
        echo -e "${GRAY}   (puedes hacerlo manualmente con: termux-setup-storage)${NC}"
    fi
}

download_config() {
    local temp_dir="/tmp/nvim-config-temp"
    local nvim_config_path="$HOME/.config/nvim"
    
    echo -e "${YELLOW}📥 Descargando configuración desde GitHub...${NC}"
    
    # Clean temp directory
    rm -rf "$temp_dir"
    
    # Clone repository
    if git clone --depth 1 "$REPO_URL" "$temp_dir" >/dev/null 2>&1; then
        echo -e "${GREEN}✅ Repositorio clonado exitosamente${NC}"
    else
        echo -e "${RED}❌ Error clonando repositorio${NC}"
        return 1
    fi
    
    # Backup existing config
    if [ -d "$nvim_config_path" ]; then
        local backup_path="$nvim_config_path.backup.$(date +%Y%m%d_%H%M%S)"
        echo -e "${CYAN}💾 Respaldando configuración existente en ${backup_path}${NC}"
        mv "$nvim_config_path" "$backup_path"
    fi
    
    # Create config directory
    mkdir -p "$nvim_config_path"
    
    # Copy Android configuration
    if [ -d "$temp_dir/android" ]; then
        cp -r "$temp_dir/android"/* "$nvim_config_path/"
        echo -e "${GREEN}✅ Configuración instalada correctamente${NC}"
    else
        echo -e "${RED}❌ No se encontró la configuración de Android${NC}"
        return 1
    fi
    
    # Clean temp directory
    rm -rf "$temp_dir"
    
    return 0
}

install_node_lsps() {
    echo -e "${YELLOW}🌐 Instalando Language Servers de Node.js...${NC}"
    
    if command_exists npm; then
        local packages=(
            "typescript-language-server"
            "typescript"
            "@astrojs/language-server"
            "vscode-langservers-extracted"
            "@tailwindcss/language-server"
            "yaml-language-server"
            "bash-language-server"
        )
        
        echo -e "${CYAN}📦 Instalando ${#packages[@]} paquetes de Node.js...${NC}"
        for package in "${packages[@]}"; do
            echo -e "${GRAY}   • Instalando $package...${NC}"
            npm install -g "$package" >/dev/null 2>&1
        done
        
        echo -e "${GREEN}✅ Language Servers de Node.js instalados${NC}"
    else
        echo -e "${RED}❌ npm no está disponible${NC}"
        return 1
    fi
}

install_python_lsps() {
    echo -e "${YELLOW}🐍 Instalando Language Servers de Python...${NC}"
    
    if command_exists pip; then
        local packages=(
            "python-lsp-server[all]"
            "debugpy"
            "black"
            "isort"
            "flake8"
        )
        
        echo -e "${CYAN}📦 Instalando ${#packages[@]} paquetes de Python...${NC}"
        for package in "${packages[@]}"; do
            echo -e "${GRAY}   • Instalando $package...${NC}"
            pip install "$package" >/dev/null 2>&1
        done
        
        echo -e "${GREEN}✅ Language Servers de Python instalados${NC}"
    else
        echo -e "${RED}❌ pip no está disponible${NC}"
        return 1
    fi
}

install_go_tools() {
    echo -e "${YELLOW}🔧 Instalando herramientas de Go...${NC}"
    
    if command_exists go; then
        # Set up Go environment
        export GOPATH="$HOME/go"
        export PATH="$PATH:$GOPATH/bin"
        
        echo -e "${CYAN}📦 Instalando gopls y delve...${NC}"
        go install golang.org/x/tools/gopls@latest >/dev/null 2>&1
        go install github.com/go-delve/delve/cmd/dlv@latest >/dev/null 2>&1
        
        # Add to shell profile
        if ! grep -q "GOPATH" "$HOME/.bashrc" 2>/dev/null; then
            cat >> "$HOME/.bashrc" << 'EOF'

# Go environment
export GOPATH="$HOME/go"
export PATH="$PATH:$GOPATH/bin"
EOF
        fi
        
        echo -e "${GREEN}✅ Herramientas de Go instaladas${NC}"
    else
        echo -e "${RED}❌ Go no está disponible${NC}"
        return 1
    fi
}

setup_termux_extras() {
    echo -e "${YELLOW}⚙️ Configurando extras de Termux...${NC}"
    
    # Check for Termux:API
    if command_exists termux-clipboard-get >/dev/null 2>&1; then
        echo -e "${GREEN}✅ Termux:API detectado - Funciones de clipboard disponibles${NC}"
    else
        echo -e "${GRAY}💡 Considera instalar Termux:API para funciones adicionales${NC}"
    fi
    
    # Setup termux properties
    local termux_props="$HOME/.termux/termux.properties"
    if [ ! -f "$termux_props" ]; then
        mkdir -p "$HOME/.termux"
        cat > "$termux_props" << 'EOF'
# Termux configuration for Neovim development
# Extra keys for better Neovim experience
extra-keys = [ \
  ['ESC','/','-','HOME','UP','END','PGUP'], \
  ['TAB','CTRL','ALT','LEFT','DOWN','RIGHT','PGDN'] \
]

# Hardware keyboard shortcuts
shortcut.create-session = ctrl + shift + n
shortcut.next-session = ctrl + shift + right
shortcut.previous-session = ctrl + shift + left
shortcut.rename-session = ctrl + shift + r

# Volume keys behavior
use-volume-key = true
EOF
        echo -e "${GREEN}✅ Configuración de Termux actualizada${NC}"
        echo -e "${YELLOW}   ⚠️  Reinicia Termux para aplicar los cambios${NC}"
    else
        echo -e "${GRAY}   • Configuración de Termux ya existe${NC}"
    fi
    
    # Setup shell aliases
    local shell_config="$HOME/.bashrc"
    if ! grep -q "nvim aliases" "$shell_config" 2>/dev/null; then
        cat >> "$shell_config" << 'EOF'

# Neovim aliases
alias vim='nvim'
alias vi='nvim'
alias v='nvim'

# Development shortcuts
alias ll='ls -la'
alias la='ls -la'
alias ..='cd ..'
alias ...='cd ../..'
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

# Git shortcuts
alias gs='git status'
alias ga='git add'
alias gc='git commit'
alias gp='git push'
alias gl='git log --oneline'
alias gd='git diff'
EOF
        echo -e "${GREEN}✅ Aliases útiles agregados a ~/.bashrc${NC}"
    fi
}

test_installation() {
    echo -e "${YELLOW}🔍 Verificando instalación...${NC}"
    
    local checks=(
        "neovim:nvim"
        "git:git"
        "nodejs:node"
        "python:python"
        "ripgrep:rg"
        "fd:fd"
        "fzf:fzf"
        "lazygit:lazygit"
    )
    
    local all_good=true
    local passed=0
    local total=${#checks[@]}
    
    for check in "${checks[@]}"; do
        local name="${check%:*}"
        local cmd="${check#*:}"
        
        if command_exists "$cmd"; then
            echo -e "${GREEN}   ✅ $name${NC}"
            ((passed++))
        else
            echo -e "${RED}   ❌ $name${NC}"
            all_good=false
        fi
    done
    
    # Check Neovim config
    if [ -f "$HOME/.config/nvim/init.lua" ]; then
        echo -e "${GREEN}   ✅ Configuración de Neovim${NC}"
        ((passed++))
        ((total++))
    else
        echo -e "${RED}   ❌ Configuración de Neovim${NC}"
        all_good=false
        ((total++))
    fi
    
    echo ""
    echo -e "${CYAN}📊 Resultado: $passed/$total componentes instalados${NC}"
    
    if [ "$all_good" = true ]; then
        return 0
    else
        return 1
    fi
}

show_success_message() {
    echo -e "${GREEN}╔════════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${GREEN}║                    ¡INSTALACIÓN COMPLETADA!                   ║${NC}"
    echo -e "${GREEN}╚════════════════════════════════════════════════════════════════╝${NC}"
    echo ""
    echo -e "${GREEN}🎉 Neovim con experiencia VS Code está listo para usar${NC}"
    echo ""
    echo -e "${CYAN}📋 PRÓXIMOS PASOS:${NC}"
    echo -e "${NC}   1. 🚀 Ejecuta ${YELLOW}nvim${NC} para abrir Neovim"
    echo -e "${NC}   2. 🔧 Los plugins se instalarán automáticamente"
    echo -e "${NC}   3. 🏥 Ejecuta ${YELLOW}:checkhealth${NC} para verificar la configuración"
    echo -e "${NC}   4. 📱 Reinicia Termux para aplicar la configuración de teclado"
    echo ""
    echo -e "${CYAN}🎮 CONTROLES PRINCIPALES:${NC}"
    echo -e "${NC}   • ${YELLOW}Volumen ↓ + Q${NC} = Ctrl"
    echo -e "${NC}   • ${YELLOW}Volumen ↓ + W${NC} = Alt"
    echo -e "${NC}   • ${YELLOW}Volumen ↓ + E${NC} = Esc"
    echo -e "${NC}   • ${YELLOW}Volumen ↓ + T${NC} = Tab"
    echo ""
    echo -e "${CYAN}⌨️ ATAJOS DE NEOVIM:${NC}"
    echo -e "${NC}   • ${YELLOW}<Space>${NC} - Tecla líder principal"
    echo -e "${NC}   • ${YELLOW}<Space>ff${NC} - Buscar archivos"
    echo -e "${NC}   • ${YELLOW}<Space>e${NC} - Explorador de archivos"
    echo -e "${NC}   • ${YELLOW}<Space>gg${NC} - LazyGit"
    echo -e "${NC}   • ${YELLOW}<F5>${NC} - Iniciar debug"
    echo ""
    echo -e "${CYAN}💡 CONSEJOS:${NC}"
    echo -e "${NC}   • Usa ${YELLOW}source ~/.bashrc${NC} para cargar los nuevos aliases"
    echo -e "${NC}   • Instala ${YELLOW}Termux:API${NC} para funciones adicionales"
    echo -e "${NC}   • Usa ${YELLOW}pkg upgrade${NC} regularmente para actualizar"
    echo ""
}

show_error_message() {
    echo -e "${RED}╔════════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${RED}║                  INSTALACIÓN INCOMPLETA                       ║${NC}"
    echo -e "${RED}╚════════════════════════════════════════════════════════════════╝${NC}"
    echo ""
    echo -e "${RED}❌ Algunos componentes no se instalaron correctamente.${NC}"
    echo -e "${YELLOW}   🔧 Comandos para depuración:${NC}"
    echo -e "${NC}   • ${YELLOW}pkg list-installed${NC} - Ver paquetes instalados"
    echo -e "${NC}   • ${YELLOW}which <comando>${NC} - Verificar disponibilidad"
    echo -e "${NC}   • ${YELLOW}pkg search <nombre>${NC} - Buscar paquetes"
    echo -e "${NC}   • ${YELLOW}pkg install <paquete>${NC} - Instalar manualmente"
    echo ""
    echo -e "${YELLOW}💡 Intenta ejecutar el script nuevamente o instala manualmente los componentes faltantes.${NC}"
    echo ""
}

# Main installation process
echo -e "${GREEN}🚀 Iniciando instalación...${NC}"
echo ""

# Setup storage access first
setup_storage
echo ""

if [ "$SKIP_DEPENDENCIES" != "true" ]; then
    echo -e "${PURPLE}📦 ACTUALIZANDO SISTEMA${NC}"
    echo -e "${PURPLE}─────────────────────────────────────────${NC}"
    
    # Update package lists
    echo -e "${CYAN}🔄 Actualizando listas de paquetes...${NC}"
    pkg update -y >/dev/null 2>&1
    pkg upgrade -y >/dev/null 2>&1
    echo -e "${GREEN}✅ Sistema actualizado${NC}"
    
    echo ""
    echo -e "${PURPLE}📦 INSTALANDO DEPENDENCIAS BÁSICAS${NC}"
    echo -e "${PURPLE}─────────────────────────────────────────${NC}"
    
    # Install core dependencies
    install_package "git" "Git"
    install_package "neovim" "Neovim"
    install_package "nodejs" "Node.js"
    install_package "python" "Python"
    install_package "ripgrep" "Ripgrep"
    install_package "fd" "fd (find alternative)"
    install_package "fzf" "fzf (fuzzy finder)"
    install_package "curl" "cURL"
    install_package "wget" "wget"
    install_package "unzip" "unzip"
    install_package "make" "make"
    install_package "clang" "clang (compiler)"
    
    # Try to install lazygit
    if ! install_package "lazygit" "LazyGit"; then
        echo -e "${YELLOW}⚠️  LazyGit no disponible, se puede instalar manualmente más tarde${NC}"
    fi
    
    echo ""
    echo -e "${PURPLE}🛠️ HERRAMIENTAS ADICIONALES${NC}"
    echo -e "${PURPLE}─────────────────────────────────────────${NC}"
    
    # Optional but useful packages
    install_package "tree" "tree (directory listing)"
    install_package "htop" "htop (process monitor)"
    install_package "jq" "jq (JSON processor)"
    install_package "zip" "zip"
    
    echo ""
fi

echo -e "${PURPLE}🛠️ CONFIGURANDO NEOVIM${NC}"
echo -e "${PURPLE}─────────────────────────────────────────${NC}"
if ! download_config; then
    echo -e "${RED}❌ Error configurando Neovim${NC}"
    exit 1
fi
echo ""

echo -e "${PURPLE}🌐 INSTALANDO LANGUAGE SERVERS${NC}"
echo -e "${PURPLE}─────────────────────────────────────────${NC}"
install_node_lsps
install_python_lsps
echo ""

# Optional Go installation
echo -e "${YELLOW}❓ ¿Deseas instalar Go y sus LSPs? (y/N): ${NC}"
read -t 10 -n 1 go_choice
echo ""
if [[ "$go_choice" =~ ^[Yy]$ ]]; then
    echo -e "${PURPLE}🔧 INSTALANDO GO${NC}"
    echo -e "${PURPLE}─────────────────────────────────────────${NC}"
    if install_package "golang" "Go"; then
        install_go_tools
    fi
    echo ""
fi

echo -e "${PURPLE}⚙️ CONFIGURANDO TERMUX${NC}"
echo -e "${PURPLE}─────────────────────────────────────────${NC}"
setup_termux_extras
echo ""

echo -e "${PURPLE}✅ VERIFICANDO INSTALACIÓN${NC}"
echo -e "${PURPLE}─────────────────────────────────────────${NC}"
if test_installation; then
    installation_ok=true
else
    installation_ok=false
fi
echo ""

# Show final message
if [ "$installation_ok" = true ]; then
    show_success_message
else
    show_error_message
fi

echo -e "${GRAY}Presiona Enter para continuar...${NC}"
read -r
