#!/usr/bin/env bash
# ══════════════════════════════════════════════════════════════════════
# Neovim Installation Script for Android (Termux)
# ══════════════════════════════════════════════════════════════════════

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Configuration
SKIP_DEPENDENCIES=${SKIP_DEPENDENCIES:-false}
FORCE_INSTALL=${FORCE_INSTALL:-false}
CONFIG_SOURCE=${CONFIG_SOURCE:-"local"}

echo -e "${CYAN}╔════════════════════════════════════════════════════════════════╗${NC}"
echo -e "${CYAN}║              NVIM VS Code Experience - Installer              ║${NC}"
echo -e "${CYAN}║                      Para Android/Termux                      ║${NC}"
echo -e "${CYAN}╚════════════════════════════════════════════════════════════════╝${NC}"
echo ""

# Check if running in Termux
if [ ! -d "/data/data/com.termux" ]; then
    echo -e "${RED}❌ Este script debe ejecutarse en Termux${NC}"
    echo -e "${YELLOW}💡 Instala Termux desde F-Droid o Google Play Store${NC}"
    exit 1
fi

# Functions
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

install_package() {
    local package_name="$1"
    local display_name="$2"
    
    echo -e "${YELLOW}Instalando $display_name...${NC}"
    if pkg install -y "$package_name"; then
        echo -e "${GREEN}✅ $display_name instalado correctamente${NC}"
    else
        echo -e "${RED}❌ Error instalando $display_name${NC}"
        return 1
    fi
}

setup_storage() {
    echo -e "${YELLOW}Configurando acceso al almacenamiento...${NC}"
    if termux-setup-storage; then
        echo -e "${GREEN}✅ Acceso al almacenamiento configurado${NC}"
    else
        echo -e "${YELLOW}⚠️  No se pudo configurar el almacenamiento automáticamente${NC}"
        echo -e "${YELLOW}   Puedes hacerlo manualmente más tarde con: termux-setup-storage${NC}"
    fi
}

setup_nvim_config() {
    local source="$1"
    
    echo -e "${YELLOW}Configurando Neovim...${NC}"
    
    local nvim_config_path="$HOME/.config/nvim"
    
    # Backup existing config
    if [ -d "$nvim_config_path" ]; then
        local backup_path="$nvim_config_path.backup.$(date +%Y%m%d_%H%M%S)"
        echo -e "${CYAN}Respaldando configuración existente en $backup_path${NC}"
        mv "$nvim_config_path" "$backup_path"
    fi
    
    # Create config directory
    mkdir -p "$nvim_config_path"
    
    if [ "$source" = "local" ]; then
        # Copy from local android folder
        local script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
        if [ -f "$script_dir/init.lua" ]; then
            cp -r "$script_dir"/* "$nvim_config_path/"
            echo -e "${GREEN}✅ Configuración copiada desde carpeta local${NC}"
        else
            echo -e "${RED}❌ No se encontró la configuración local${NC}"
            echo -e "${YELLOW}💡 Asegúrate de estar ejecutando el script desde la carpeta android/${NC}"
            return 1
        fi
    else
        # Clone from repository
        if command_exists git; then
            if git clone "$source" "$nvim_config_path"; then
                echo -e "${GREEN}✅ Configuración clonada desde repositorio${NC}"
            else
                echo -e "${RED}❌ Error clonando repositorio${NC}"
                return 1
            fi
        else
            echo -e "${RED}❌ Git no está disponible${NC}"
            return 1
        fi
    fi
    
    return 0
}

install_node_lsps() {
    echo -e "${YELLOW}Instalando Language Servers de Node.js...${NC}"
    
    if command_exists npm; then
        local packages=(
            "typescript-language-server"
            "typescript"
            "@astrojs/language-server"
            "vscode-langservers-extracted"
            "@tailwindcss/language-server"
            "yaml-language-server"
        )
        
        for package in "${packages[@]}"; do
            echo -e "${CYAN}Instalando $package...${NC}"
            npm install -g "$package"
        done
        
        echo -e "${GREEN}✅ Language Servers de Node.js instalados${NC}"
    else
        echo -e "${RED}❌ npm no está disponible${NC}"
    fi
}

install_python_lsps() {
    echo -e "${YELLOW}Instalando Language Servers de Python...${NC}"
    
    if command_exists pip; then
        local packages=(
            "python-lsp-server"
            "pylsp-mypy"
            "python-lsp-black"
            "pyls-isort"
            "debugpy"
        )
        
        for package in "${packages[@]}"; do
            echo -e "${CYAN}Instalando $package...${NC}"
            pip install "$package"
        done
        
        echo -e "${GREEN}✅ Language Servers de Python instalados${NC}"
    else
        echo -e "${RED}❌ pip no está disponible${NC}"
    fi
}

install_go_lsps() {
    echo -e "${YELLOW}Instalando Language Servers de Go...${NC}"
    
    if command_exists go; then
        echo -e "${CYAN}Instalando gopls...${NC}"
        go install golang.org/x/tools/gopls@latest
        
        echo -e "${CYAN}Instalando delve (debugger)...${NC}"
        go install github.com/go-delve/delve/cmd/dlv@latest
        
        echo -e "${GREEN}✅ Language Servers de Go instalados${NC}"
    else
        echo -e "${RED}❌ go no está disponible${NC}"
    fi
}

setup_termux_extras() {
    echo -e "${YELLOW}Configurando extras de Termux...${NC}"
    
    # Setup termux api if available
    if command_exists termux-clipboard-get; then
        echo -e "${GREEN}✅ Termux:API detectado - Integración de clipboard disponible${NC}"
    else
        echo -e "${YELLOW}💡 Instala Termux:API desde F-Droid para funciones adicionales${NC}"
    fi
    
    # Setup better shell experience
    echo -e "${CYAN}Configurando shell...${NC}"
    if [ ! -f "$HOME/.termux/termux.properties" ]; then
        mkdir -p "$HOME/.termux"
        cat > "$HOME/.termux/termux.properties" << 'EOF'
# Termux configuration for Neovim development
extra-keys = [['ESC','/','-','HOME','UP','END','PGUP'], \
              ['TAB','CTRL','ALT','LEFT','DOWN','RIGHT','PGDN']]

# Enable hardware keyboard shortcuts
shortcut.create-session = ctrl + shift + n
shortcut.next-session = ctrl + shift + right
shortcut.previous-session = ctrl + shift + left
shortcut.rename-session = ctrl + shift + r

# Volume keys as modifier
use-volume-key = true
EOF
        echo -e "${GREEN}✅ Configuración de Termux actualizada${NC}"
        echo -e "${YELLOW}💡 Reinicia Termux para aplicar los cambios${NC}"
    fi
}

test_installation() {
    echo -e "${YELLOW}Verificando instalación...${NC}"
    
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
    for check in "${checks[@]}"; do
        local name="${check%:*}"
        local cmd="${check#*:}"
        
        if command_exists "$cmd"; then
            echo -e "${GREEN}✅ $name${NC}"
        else
            echo -e "${RED}❌ $name${NC}"
            all_good=false
        fi
    done
    
    # Check Neovim config
    if [ -f "$HOME/.config/nvim/init.lua" ]; then
        echo -e "${GREEN}✅ Configuración de Neovim${NC}"
    else
        echo -e "${RED}❌ Configuración de Neovim${NC}"
        all_good=false
    fi
    
    if [ "$all_good" = true ]; then
        return 0
    else
        return 1
    fi
}

# Main installation process
echo -e "${GREEN}Iniciando instalación...${NC}"
echo ""

# Setup storage access
setup_storage
echo ""

if [ "$SKIP_DEPENDENCIES" != "true" ]; then
    echo -e "${PURPLE}📦 ACTUALIZANDO PAQUETES${NC}"
    echo -e "${PURPLE}─────────────────────────────────────────${NC}"
    
    # Update package lists
    pkg update -y
    pkg upgrade -y
    
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
    install_package "lazygit" "LazyGit"
    install_package "curl" "cURL"
    install_package "wget" "wget"
    install_package "unzip" "unzip"
    install_package "make" "make"
    install_package "clang" "clang (for building)"
    
    echo ""
    echo -e "${PURPLE}🛠️ HERRAMIENTAS ADICIONALES${NC}"
    echo -e "${PURPLE}─────────────────────────────────────────${NC}"
    
    # Optional but useful packages
    install_package "tree" "tree (directory listing)"
    install_package "htop" "htop (process monitor)"
    install_package "jq" "jq (JSON processor)"
    
    echo ""
fi

echo -e "${PURPLE}🛠️ CONFIGURANDO NEOVIM${NC}"
echo -e "${PURPLE}─────────────────────────────────────────${NC}"
if ! setup_nvim_config "$CONFIG_SOURCE"; then
    echo -e "${RED}❌ Error configurando Neovim${NC}"
    exit 1
fi
echo ""

echo -e "${PURPLE}🌐 INSTALANDO LANGUAGE SERVERS${NC}"
echo -e "${PURPLE}─────────────────────────────────────────${NC}"
install_node_lsps
install_python_lsps

# Optional Go LSPs
echo ""
read -p "¿Deseas instalar Go y sus LSPs? (y/N): " go_choice
if [[ "$go_choice" =~ ^[Yy]$ ]]; then
    install_package "golang" "Go"
    if command_exists go; then
        install_go_lsps
    fi
fi
echo ""

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

if [ "$installation_ok" = true ]; then
    echo -e "${GREEN}╔════════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${GREEN}║                    ¡INSTALACIÓN COMPLETADA!                   ║${NC}"
    echo -e "${GREEN}╚════════════════════════════════════════════════════════════════╝${NC}"
    echo ""
    echo -e "${GREEN}🎉 Neovim está listo para usar con experiencia VS Code${NC}"
    echo ""
    echo -e "${CYAN}📋 PRÓXIMOS PASOS:${NC}"
    echo -e "${NC}1. Ejecuta 'nvim' para abrir Neovim${NC}"
    echo -e "${NC}2. Los plugins se instalarán automáticamente en el primer inicio${NC}"
    echo -e "${NC}3. Ejecuta ':checkhealth' para verificar la configuración${NC}"
    echo -e "${NC}4. Usa 'termux-setup-storage' si no tienes acceso al almacenamiento${NC}"
    echo ""
    echo -e "${CYAN}🔧 COMANDOS ÚTILES EN TERMUX:${NC}"
    echo -e "${NC}• Volume Down + Q = Ctrl${NC}"
    echo -e "${NC}• Volume Down + W = Alt${NC}"
    echo -e "${NC}• Volume Down + E = Esc${NC}"
    echo -e "${NC}• Volume Down + T = Tab${NC}"
    echo -e "${NC}• Volume Down + 1-9 = F1-F9${NC}"
    echo ""
    echo -e "${CYAN}🚀 ATAJOS DE NEOVIM:${NC}"
    echo -e "${NC}• <Space> - Tecla líder principal${NC}"
    echo -e "${NC}• <Space>ff - Buscar archivos${NC}"
    echo -e "${NC}• <Space>e - Explorador de archivos${NC}"
    echo -e "${NC}• <Space>gg - LazyGit${NC}"
    echo -e "${NC}• <Ctrl+/> - Comentar línea${NC}"
    echo -e "${NC}• <F5> - Iniciar debug${NC}"
    echo ""
    echo -e "${CYAN}💡 CONSEJOS PARA TERMUX:${NC}"
    echo -e "${NC}• Instala 'Termux:API' para funciones adicionales${NC}"
    echo -e "${NC}• Instala 'Termux:Widget' para accesos directos${NC}"
    echo -e "${NC}• Usa 'pkg list-installed' para ver paquetes instalados${NC}"
    echo -e "${NC}• Usa 'pkg upgrade' para actualizar paquetes${NC}"
    echo ""
else
    echo -e "${RED}╔════════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${RED}║                  INSTALACIÓN INCOMPLETA                       ║${NC}"
    echo -e "${RED}╚════════════════════════════════════════════════════════════════╝${NC}"
    echo ""
    echo -e "${RED}❌ Algunos componentes no se instalaron correctamente.${NC}"
    echo -e "${RED}   Revisa los errores anteriores y reinstala las dependencias faltantes.${NC}"
    echo ""
    echo -e "${YELLOW}💡 Comandos útiles para depuración:${NC}"
    echo -e "${NC}• pkg list-installed - Ver paquetes instalados${NC}"
    echo -e "${NC}• which <comando> - Verificar si un comando está disponible${NC}"
    echo -e "${NC}• pkg search <nombre> - Buscar paquetes disponibles${NC}"
    echo ""
fi

echo -e "${GRAY}Presiona cualquier tecla para continuar...${NC}"
read -n 1 -s
    echo -e "${GREEN}🎉 Neovim está listo para usar con experiencia VS Code en Android${NC}"
    echo ""
    echo -e "${CYAN}📋 PRÓXIMOS PASOS:${NC}"
    echo -e "${YELLOW}1. Ejecuta 'nvim' para abrir Neovim${NC}"
    echo -e "${YELLOW}2. Los plugins se instalarán automáticamente en el primer inicio${NC}"
    echo -e "${YELLOW}3. Ejecuta ':checkhealth' para verificar la configuración${NC}"
    echo -e "${YELLOW}4. Configura tu Git: git config --global user.name 'Tu Nombre'${NC}"
    echo -e "${YELLOW}5. Configura tu email: git config --global user.email 'tu@email.com'${NC}"
    echo ""
    echo -e "${CYAN}🔧 COMANDOS ÚTILES PARA ANDROID:${NC}"
    echo -e "${YELLOW}• <Space> - Tecla líder principal${NC}"
    echo -e "${YELLOW}• <Space>ff - Buscar archivos${NC}"
    echo -e "${YELLOW}• <Space>e - Explorador de archivos${NC}"
    echo -e "${YELLOW}• <Space>gg - LazyGit${NC}"
    echo -e "${YELLOW}• <Volume Down + /> - Comentar línea${NC}"
    echo -e "${YELLOW}• <Tab> / <Shift+Tab> - Cambiar entre buffers${NC}"
    echo -e "${YELLOW}• <F5> - Iniciar debug${NC}"
    echo ""
    echo -e "${CYAN}📱 TERMUX ESPECÍFICO:${NC}"
    echo -e "${YELLOW}• termux-setup-storage - Acceso a almacenamiento${NC}"
    echo -e "${YELLOW}• Volume Down = Alt key para shortcuts${NC}"
    echo -e "${YELLOW}• Extra keys habilitadas en el teclado${NC}"
    echo ""
else
    echo -e "${RED}╔════════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${RED}║                  INSTALACIÓN INCOMPLETA                       ║${NC}"
    echo -e "${RED}╚════════════════════════════════════════════════════════════════╝${NC}"
    echo ""
    echo -e "${RED}❌ Algunos componentes no se instalaron correctamente.${NC}"
    echo -e "${YELLOW}   Revisa los errores anteriores y ejecuta el script nuevamente.${NC}"
    echo ""
    echo -e "${CYAN}💡 COMANDOS PARA SOLUCIONAR PROBLEMAS:${NC}"
    echo -e "${YELLOW}• pkg update && pkg upgrade - Actualizar paquetes${NC}"
    echo -e "${YELLOW}• pkg install <paquete> - Instalar paquete específico${NC}"
    echo -e "${YELLOW}• termux-info - Información del sistema${NC}"
    echo ""
fi

echo -e "${NC}Presiona Enter para continuar...${NC}"
read -r
