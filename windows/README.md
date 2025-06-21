# 🚀 Neovim VS Code Experience - Windows Configuration

Una configuración completa de Neovim que replica la experiencia de VS Code con todos los atajos de teclado familiares, plugins modernos y una interfaz hermosa.

## ✨ Características

- 🎨 **Tema moderno** - Tokyo Night con UI hermosa
- ⌨️ **Atajos VS Code** - Todos los shortcuts familiares (`Ctrl+S`, `Ctrl+P`, `Ctrl+/`, etc.)
- 🔍 **Fuzzy Finding** - Telescope integrado para búsqueda rápida
- 📁 **Explorador de archivos** - nvim-tree con iconos y git integration
- 🌐 **LSP completo** - Autocompletado, diagnósticos y refactoring
- 🐛 **Debugging** - DAP integrado para múltiples lenguajes
- 🧪 **Testing** - Neotest para ejecutar y ver resultados
- 📊 **Git Integration** - LazyGit, gitsigns y diffview
- 💻 **Terminal integrado** - ToggleTerm con múltiples terminales
- 🎯 **Formateo automático** - Conform.nvim con formatters populares

## 🛠️ Instalación Rápida

### Opción 1: Script Automático (Recomendado)

1. **Abre PowerShell como Administrador**
2. **Ejecuta el script de instalación:**

```powershell
Set-ExecutionPolicy Bypass -Scope Process -Force
Invoke-Expression (Invoke-WebRequest -Uri "https://raw.githubusercontent.com/tu-usuario/nvim-vscode-config/main/windows/install.ps1" -UseBasicParsing).Content
```

O si tienes el repositorio clonado localmente:

```powershell
cd ruta\al\repositorio\nvim-vscode-config\windows
.\install.ps1
```

### Opción 2: Instalación Manual

Sigue la [guía de instalación manual](installation.md) para un control total del proceso.

## 📋 Lo que incluye el script

- ✅ Neovim (última versión)
- ✅ Git, Node.js, Python
- ✅ Herramientas de búsqueda (ripgrep, fd, fzf)
- ✅ JetBrains Mono Nerd Font
- ✅ Language servers para:
  - TypeScript/JavaScript
  - Python
  - Lua
  - Go (opcional)
  - Rust (opcional)
  - HTML/CSS/JSON/YAML
  - Astro
- ✅ Formatters y linters
- ✅ Debuggers

## 🎮 Atajos de Teclado Principales

### 📁 Navegación de Archivos
- `Ctrl+P` - Buscar archivos (git-aware)
- `Ctrl+Shift+P` - Paleta de comandos
- `Space+e` - Toggle explorador de archivos
- `Space+ff` - Buscar archivos
- `Space+fg` - Buscar en contenido (grep)
- `Space+fb` - Buscar en buffers abiertos

### ✏️ Edición
- `Ctrl+S` - Guardar archivo
- `Ctrl+Z` - Deshacer
- `Ctrl+Y` - Rehacer
- `Ctrl+/` - Comentar/descomentar línea
- `Ctrl+D` - Duplicar línea
- `Alt+↑/↓` - Mover línea arriba/abajo
- `Ctrl+A` - Seleccionar todo

### 🔧 LSP y Desarrollo
- `F12` / `gd` - Ir a definición
- `Space+ca` - Acciones de código
- `Space+rn` - Renombrar símbolo
- `Space+f` - Formatear código
- `K` - Hover documentation
- `[e` / `]e` - Navegar diagnósticos

### 🐛 Debugging
- `F5` - Iniciar/continuar debug
- `F9` - Toggle breakpoint
- `F10` - Step over
- `F11` - Step into
- `Shift+F5` - Detener debug

### 🧪 Testing
- `Space+tt` - Ejecutar test más cercano
- `Space+tf` - Ejecutar tests del archivo
- `Space+ta` - Ejecutar todos los tests
- `Space+ts` - Toggle panel de tests

### 📊 Git
- `Space+gg` - Abrir LazyGit
- `Space+gd` - Diff view
- `Space+gh` - Historial de archivo
- `]c` / `[c` - Navegar cambios

### 💻 Terminal
- `Ctrl+\`` - Toggle terminal flotante
- `Space+th` - Terminal horizontal
- `Space+tv` - Terminal vertical
- `Space+tn` - Terminal Node.js
- `Space+tp` - Terminal Python

## 🎨 Personalización

### Cambiar Tema

```lua
-- En init.lua, cambia:
vim.cmd.colorscheme("tokyonight-night")

-- Por ejemplo:
vim.cmd.colorscheme("tokyonight-storm")  -- Más claro
vim.cmd.colorscheme("tokyonight-moon")   -- Alternativo
vim.cmd.colorscheme("tokyonight-day")    -- Claro
```

### Agregar Language Servers

```lua
-- En lua/plugins/lsp.lua, agrega al array ensure_installed:
ensure_installed = {
  "lua_ls",
  "tsserver",
  "pyright",
  -- Agrega aquí nuevos LSPs
  "clangd",        -- C/C++
  "bashls",        -- Bash
  "dockerls",      -- Docker
}
```

### Configurar Formatters

```lua
-- En lua/plugins/tools.lua, agrega a formatters_by_ft:
formatters_by_ft = {
  lua = { "stylua" },
  python = { "isort", "black" },
  -- Agrega nuevos formatters
  cpp = { "clang-format" },
  sh = { "shfmt" },
}
```

## 📁 Estructura del Proyecto

```
windows/
├── init.lua                 # Configuración principal
├── lua/
│   ├── config/
│   │   ├── options.lua      # Opciones de Neovim
│   │   ├── keymaps.lua      # Atajos de teclado
│   │   ├── autocmds.lua     # Auto comandos
│   │   └── icons.lua        # Iconos
│   └── plugins/
│       ├── ui.lua           # Tema y UI
│       ├── explorer.lua     # Explorador de archivos
│       ├── telescope.lua    # Fuzzy finder
│       ├── lsp.lua          # Language servers
│       ├── completion.lua   # Autocompletado
│       ├── treesitter.lua   # Syntax highlighting
│       ├── git.lua          # Integración Git
│       ├── debug.lua        # Debugging
│       └── tools.lua        # Herramientas adicionales
├── install.ps1             # Script de instalación
└── installation.md         # Guía manual
```

## 🔧 Solución de Problemas

### Los plugins no se cargan
```powershell
# Elimina el caché y reinstala
Remove-Item -Path "$env:LOCALAPPDATA\nvim-data" -Recurse -Force
nvim --headless -c "autocmd User LazyDone quitall" -c "Lazy! sync"
```

### LSP no funciona
```vim
:Mason
# Instala o reinstala el language server necesario
```

### Fuente no se ve bien
1. Verifica que JetBrains Mono Nerd Font esté instalada
2. Configura Windows Terminal:
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

### Rendimiento lento
```lua
-- En lua/config/options.lua, ajusta:
opt.updatetime = 250        -- Reduce para menos delay
opt.timeoutlen = 300        -- Reduce para shortcuts más rápidos
```

## 🤝 Contribuir

1. Fork el repositorio
2. Crea una rama para tu feature (`git checkout -b feature/nueva-funcionalidad`)
3. Commit tus cambios (`git commit -am 'Agrega nueva funcionalidad'`)
4. Push a la rama (`git push origin feature/nueva-funcionalidad`)
5. Abre un Pull Request

## 📝 Licencia

Este proyecto está bajo la Licencia MIT - ve el archivo [LICENSE](../LICENSE) para detalles.

## 💡 Inspiración

Esta configuración está inspirada en:
- [LazyVim](https://github.com/LazyVim/LazyVim)
- [NvChad](https://github.com/NvChad/NvChad)
- [AstroNvim](https://github.com/AstroNvim/AstroNvim)
- VS Code keybindings y UX

## 🎯 Roadmap

- [ ] Configuración para Android/Termux
- [ ] Más language servers
- [ ] Integración con Docker
- [ ] Snippets personalizados
- [ ] Configuración de workspace
- [ ] Auto-update script

---

**¿Tienes preguntas?** Abre un issue o inicia una discusión en el repositorio.
