# 🚀 Neovim VS Code Experience

Una configuración completa de Neovim que proporciona una experiencia similar a VS Code, optimizada tanto para **Windows** como para **Android (Termux)**. 

## ✨ Características Principales

- **🎯 Experiencia VS Code**: Atajos familiares y comportamientos similares
- **🌐 Multi-plataforma**: Funciona en Windows y Android/Termux
- **📊 LSP completo**: Soporte para 15+ lenguajes de programación
- **🎨 Tema moderno**: Tokyo Night con variaciones
- **⚡ Alto rendimiento**: Configuración optimizada y ligera
- **🔧 Extensible**: Fácil de personalizar y modificar

## 🖥️ Plataformas Soportadas

### Windows
- ✅ **Windows PowerShell 7+**
- ✅ **Windows Terminal** (recomendado)
- ✅ **Nerd Fonts** incluidas
- ✅ **Winget** para instalación automática

### Android (Termux)
- ✅ **Termux** desde F-Droid
- ✅ **Termux:API** para funciones adicionales
- ✅ **Optimizado para pantallas táctiles**
- ✅ **Gestión de energía**

## 🚀 Instalación Rápida

### Para Windows PowerShell

```powershell
# Instalación con un comando (como administrador)
Invoke-Expression (Invoke-WebRequest -Uri "https://raw.githubusercontent.com/sazardev/nvim-vscode-config/refs/heads/master/windows/install.ps1" -UseBasicParsing).Content
```

### Para Android (Termux)

```bash
# Instalación con un comando
curl -fsSL https://raw.githubusercontent.com/sazardev/nvim-vscode-config/main/android/install.sh | bash
```

## 📁 Estructura del Proyecto

```
nvim-vscode-config/
├── README.md                 # Este archivo
├── windows/                  # Configuración para Windows
│   ├── install.ps1           # Script de instalación PowerShell
│   ├── installation.md       # Guía detallada Windows
│   ├── init.lua              # Configuración principal
│   └── lua/
│       ├── config/           # Configuraciones base
│       └── plugins/          # Configuración de plugins
└── android/                  # Configuración para Android
    ├── install.sh            # Script de instalación Bash
    ├── README.md             # Guía específica Android
    ├── init.lua              # Configuración móvil
    └── lua/
        ├── config/           # Configuraciones optimizadas móvil
        └── plugins/          # Plugins optimizados móvil
```

## 🔧 Lenguajes Soportados

| Lenguaje | LSP Server | Formatter | Linter | Debug |
|----------|------------|-----------|--------|-------|
| **JavaScript/TypeScript** | ✅ typescript-language-server | ✅ Prettier | ✅ ESLint | ✅ DAP |
| **Python** | ✅ python-lsp-server | ✅ Black | ✅ Pylint | ✅ debugpy |
| **Go** | ✅ gopls | ✅ gofmt | ✅ staticcheck | ✅ delve |
| **Rust** | ✅ rust-analyzer | ✅ rustfmt | ✅ clippy | ✅ DAP |
| **Lua** | ✅ lua-language-server | ✅ stylua | ✅ luacheck | ❌ |
| **HTML/CSS** | ✅ vscode-langservers | ✅ Prettier | ✅ stylelint | ❌ |
| **JSON/YAML** | ✅ Built-in | ✅ Prettier | ✅ Built-in | ❌ |
| **Markdown** | ✅ marksman | ✅ Prettier | ✅ markdownlint | ❌ |
| **Astro** | ✅ @astrojs/language-server | ✅ Prettier | ✅ ESLint | ❌ |

## ⌨️ Atajos de Teclado Universales

### Navegación (VS Code style)
| Tecla | Acción |
|-------|--------|
| `<Space>` | Tecla líder principal |
| `<Ctrl+P>` | Buscar archivos rápido |
| `<Space>ff` | Buscar archivos |
| `<Space>fg` | Buscar en archivos (grep) |
| `<Space>fr` | Archivos recientes |
| `<Space>e` | Toggle explorador |
| `<Space>gg` | LazyGit |

### LSP (Intellisense)
| Tecla | Acción |
|-------|--------|
| `gd` | Ir a definición |
| `gr` | Buscar referencias |
| `gi` | Ir a implementación |
| `K` | Hover documentation |
| `<Space>ca` | Code actions |
| `<Space>rn` | Renombrar |
| `]d` / `[d` | Next/Previous diagnostic |

### Debugging
| Tecla | Acción |
|-------|--------|
| `<F5>` | Start/Continue |
| `<F10>` | Step Over |
| `<F11>` | Step Into |
| `<F12>` | Step Out |
| `<Space>b` | Toggle breakpoint |
| `<Space>B` | Conditional breakpoint |

## 📊 Plugins Incluidos

### Core
- **lazy.nvim** - Plugin manager moderno
- **plenary.nvim** - Utilidades Lua
- **nvim-web-devicons** - Iconos

### UI/UX
- **tokyonight.nvim** - Tema principal
- **lualine.nvim** - Statusline elegante
- **bufferline.nvim** - Pestañas de buffers
- **alpha-nvim** - Dashboard de inicio
- **nvim-notify** - Notificaciones mejoradas
- **indent-blankline.nvim** - Guías de indentación

### Navegación
- **telescope.nvim** - Fuzzy finder
- **nvim-tree.lua** - Explorador de archivos
- **harpoon** - Navegación rápida de archivos
- **trouble.nvim** - Lista de problemas

### Desarrollo
- **nvim-lspconfig** - LSP configuration
- **mason.nvim** - LSP installer
- **nvim-cmp** - Auto-completion
- **nvim-treesitter** - Syntax highlighting
- **gitsigns.nvim** - Git integration
- **lazygit.nvim** - Git UI

### Herramientas
- **nvim-dap** - Debug Adapter Protocol
- **conform.nvim** - Formatting
- **nvim-lint** - Linting
- **neotest** - Testing framework
- **todo-comments.nvim** - TODO highlighting

## 🚨 Solución de Problemas

### Windows
```powershell
# Si falla la instalación, ejecutar como administrador
# Si PATH no se actualiza:
$env:PATH = [System.Environment]::GetEnvironmentVariable("PATH", "Machine") + ";" + [System.Environment]::GetEnvironmentVariable("PATH", "User")

# Reinstalar Neovim
winget uninstall Neovim.Neovim
winget install Neovim.Neovim
```

### Android
```bash
# Actualizar paquetes
pkg update && pkg upgrade

# Reinstalar Neovim
pkg reinstall neovim

# Limpiar caché de plugins
rm -rf ~/.local/share/nvim
```

### General
```vim
" En Neovim, verificar salud del sistema
:checkhealth

" Reinstalar plugins
:Lazy clean
:Lazy sync

" Actualizar LSP servers
:Mason
```

## 🤝 Contribuir

¡Las contribuciones son bienvenidas!

1. **Fork** el repositorio
2. Crea una **branch** para tu feature (`git checkout -b feature/AmazingFeature`)
3. **Commit** tus cambios (`git commit -m 'Add some AmazingFeature'`)
4. **Push** a la branch (`git push origin feature/AmazingFeature`)
5. Abre un **Pull Request**

### Estructura de contribuciones
- **Windows**: Cambios en `/windows/`
- **Android**: Cambios en `/android/`
- **Universal**: Cambios que aplican a ambos

## 📄 Licencia

Este proyecto está bajo la Licencia MIT - ver el archivo [LICENSE](LICENSE) para más detalles.

## 🆘 Soporte

- **🐛 Bugs**: [GitHub Issues](https://github.com/sazardev/nvim-vscode-config/issues)
- **💬 Discusiones**: [GitHub Discussions](https://github.com/sazardev/nvim-vscode-config/discussions)

## ⭐ Show your support

Si te gusta este proyecto, ¡dale una ⭐ en GitHub!

---

**¿Te resultó útil?** Considera darle una estrella ⭐ al repositorio y compartirlo con otros desarrolladores.

Hecho con ❤️ para la comunidad de desarrolladores que aman Neovim.
