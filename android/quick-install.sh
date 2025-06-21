#!/usr/bin/env bash
# ══════════════════════════════════════════════════════════════════════
# Quick Neovim VS Code Setup for Android (Termux) - One-liner installer
# ══════════════════════════════════════════════════════════════════════

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m'

# Quick check for Termux
if [ ! -d "/data/data/com.termux" ]; then
    echo -e "${RED}❌ Este script debe ejecutarse en Termux${NC}"
    echo -e "${YELLOW}📱 Instala Termux desde F-Droid y vuelve a intentar${NC}"
    exit 1
fi

echo -e "${CYAN}🚀 NVIM VS Code Quick Setup para Android${NC}"
echo -e "${YELLOW}⚡ Instalando dependencias mínimas...${NC}"

# Update and install essentials
pkg update -y && pkg upgrade -y
pkg install -y git curl neovim nodejs python

echo -e "${YELLOW}📥 Descargando configuración...${NC}"

# Setup config
NVIM_DIR="$HOME/.config/nvim"
[ -d "$NVIM_DIR" ] && mv "$NVIM_DIR" "$NVIM_DIR.backup.$(date +%s)"
mkdir -p "$NVIM_DIR"

# Download and extract config
curl -fsSL https://github.com/sazardev/nvim-vscode-config/archive/refs/heads/master.tar.gz | tar -xz --strip-components=2 -C "$NVIM_DIR" nvim-vscode-config-master/android

echo -e "${YELLOW}🔧 Configurando Termux...${NC}"

# Basic Termux setup
mkdir -p "$HOME/.termux"
cat > "$HOME/.termux/termux.properties" << 'EOF'
extra-keys = [['ESC','/','-','HOME','UP','END','PGUP'], ['TAB','CTRL','ALT','LEFT','DOWN','RIGHT','PGDN']]
use-volume-key = true
EOF

echo -e "${GREEN}✅ ¡Instalación básica completa!${NC}"
echo -e "${CYAN}Ejecuta 'nvim' para comenzar${NC}"
echo -e "${YELLOW}Para instalación completa con LSPs, ejecuta:${NC}"
echo -e "${NC}curl -fsSL https://raw.githubusercontent.com/sazardev/nvim-vscode-config/master/android/install-enhanced.sh | bash${NC}"
