# 🚀 Neovim VS Code Experience - Android Configuration

Una configuración completa de Neovim optimizada para dispositivos Android usando Termux, que proporciona una experiencia similar a VS Code pero adaptada para pantallas táctiles y teclados móviles.

## ✨ Características

- **🎯 Experiencia VS Code**: Atajos de teclado y comportamientos familiares
- **📱 Optimizado para móviles**: Interface adaptada para pantallas pequeñas
- **🔋 Eficiencia energética**: Configuraciones optimizadas para preservar batería
- **📊 LSP completo**: Soporte para JavaScript/TypeScript, Python, Go, Rust, y más
- **🎨 Tema moderno**: Tokyo Night con ajustes para móviles
- **⚡ Rendimiento**: Configuración ligera y rápida para dispositivos Android

## 🚀 Instalación Rápida

### Requisitos Previos

1. **Termux** instalado desde F-Droid o Google Play Store
2. **Acceso al almacenamiento** configurado
3. **Termux:API** (opcional, para funciones avanzadas)

### Instalación Automática

```bash
# Instalar con un solo comando
curl -fsSL https://raw.githubusercontent.com/tu-usuario/nvim-vscode-config/main/android/install.sh | bash
```

### Instalación Manual

```bash
# Actualizar paquetes
pkg update && pkg upgrade -y

# Clonar el repositorio
git clone https://github.com/tu-usuario/nvim-vscode-config.git ~/.config/nvim-config

# Ejecutar el instalador
cd ~/.config/nvim-config/android
chmod +x install.sh
./install.sh
```

## 📋 Lo que incluye la instalación

### Herramientas básicas
- ✅ Neovim (última versión)
- ✅ Git para control de versiones
- ✅ Node.js y npm para LSP servers
- ✅ Python y pip para herramientas de desarrollo
- ✅ Ripgrep, fd, fzf para búsquedas rápidas
- ✅ LazyGit para interface Git visual

### Language Servers instalados
- **JavaScript/TypeScript**: typescript-language-server
- **Python**: python-lsp-server con plugins
- **HTML/CSS**: vscode-langservers-extracted
- **JSON/YAML**: Soporte completo con esquemas
- **Astro**: @astrojs/language-server
- **Tailwind CSS**: @tailwindcss/language-server

### Características específicas para Android
- **🔗 Integración con clipboard**: Usando termux-clipboard-get/set
- **👆 Mapeos táctiles**: Volume Down como tecla modificadora
- **🔋 Gestión de energía**: Configuraciones optimizadas para batería
- **📱 UI móvil**: Elementos de interface adaptados para pantallas pequeñas

## ⌨️ Atajos de Teclado Principales

### Navegación básica (VS Code style)
| Tecla | Acción |
|-------|--------|
| `<Space>` | Tecla líder principal |
| `<Space>ff` | Buscar archivos |
| `<Space>fg` | Buscar texto en archivos |
| `<Space>fr` | Archivos recientes |
| `<Space>e` | Toggle explorador de archivos |
| `<Ctrl-p>` | Búsqueda rápida de archivos |

### Específicos para Android
| Tecla | Acción |
|-------|--------|
| `<M-/>` | Comentar línea (Volume Down + /) |
| `<M-CR>` | Paleta de comandos (Volume Down + Enter) |
| `<M-f>` | Buscar archivos (Volume Down + F) |
| `<M-g>` | Buscar texto (Volume Down + G) |
| `<Tab>` | Siguiente buffer |
| `<S-Tab>` | Buffer anterior |

### LSP y desarrollo
| Tecla | Acción |
|-------|--------|
| `gd` | Ir a definición |
| `gr` | Encontrar referencias |
| `K` | Mostrar documentación |
| `<Space>ca` | Acciones de código |
| `<Space>rn` | Renombrar símbolo |
| `]d` / `[d` | Siguiente/anterior diagnóstico |

### Git integration
| Tecla | Acción |
|-------|--------|
| `<Space>gg` | LazyGit |
| `<Space>gb` | Ramas de Git |
| `<Space>gc` | Commits de Git |
| `<Space>gs` | Estado de Git |

### Terminal y debugging
| Tecla | Acción |
|-------|--------|
| `<Space>tt` | Toggle terminal |
| `<F5>` | Iniciar/continuar debug |
| `<F10>` | Step over |
| `<F11>` | Step into |
| `<Space>db` | Toggle breakpoint |

## 🛠️ Configuración Android específica

### Termux:API Integration
Si tienes Termux:API instalado, obtienes funciones adicionales:
- **Vibración**: En errores y notificaciones importantes
- **Notificaciones**: Sistema de notificaciones nativo
- **Compartir**: Integración con el sistema de compartir de Android
- **Sensors**: Acceso a sensores del dispositivo (opcional)

### Optimizaciones de rendimiento
- **Lazy loading**: Plugins se cargan solo cuando se necesitan
- **Garbage collection**: Recolección automática de memoria cada 30 segundos
- **Render reduction**: Menos actualizaciones cuando la app no está en foco
- **Battery optimization**: Configuraciones que preservan la batería

### Configuración de pantalla
- **Responsive UI**: Interface que se adapta al tamaño de pantalla
- **Touch-friendly**: Elementos optimizados para navegación táctil
- **Font scaling**: Tamaños de fuente apropiados para móviles
- **Color optimization**: Colores optimizados para pantallas OLED/AMOLED

## 📱 Uso en Android

### Configuración del teclado
Termux incluye una configuración especial para teclados con teclas extras:

```bash
# Configuración automática incluida en el script
extra-keys = [['ESC','/','-','HOME','UP','END','PGUP'], \
              ['TAB','CTRL','ALT','LEFT','DOWN','RIGHT','PGDN']]
```

### Gestos y navegación
- **Pinch to zoom**: Cambiar tamaño de fuente (en algunos terminales)
- **Swipe**: Navegación entre buffers
- **Long press**: Menús contextuales
- **Volume keys**: Como teclas modificadoras (Alt/Meta)

### Proyectos típicos en Android
```bash
# Crear un proyecto de desarrollo web
mkdir ~/storage/shared/projects/mi-app
cd ~/storage/shared/projects/mi-app
npm init -y
nvim .

# Trabajar con Python
mkdir ~/storage/shared/projects/python-app
cd ~/storage/shared/projects/python-app
python -m venv venv
source venv/bin/activate
pip install flask
nvim app.py
```

## 🔧 Personalización

### Temas
El tema Tokyo Night está optimizado para Android, pero puedes cambiarlo:

```lua
-- En ~/.config/nvim/lua/plugins/ui.lua
vim.cmd("colorscheme tokyonight-storm") -- Más oscuro
vim.cmd("colorscheme tokyonight-day")   -- Más claro
```

### Tamaño de fuente
```lua
-- En ~/.config/nvim/lua/config/options.lua
vim.opt.guifont = "JetBrains Mono Nerd Font:h14" -- Tamaño más grande
```

### Configuraciones específicas para tu dispositivo
```lua
-- En init.lua, puedes añadir configuraciones específicas
if vim.fn.system("getprop ro.product.model"):match("Galaxy") then
  -- Configuraciones específicas para Samsung Galaxy
  vim.opt.updatetime = 500 -- Más lento para ahorrar batería
end
```

## 🚨 Solución de Problemas

### Problemas comunes

**No se puede abrir nvim:**
```bash
pkg reinstall neovim
```

**Plugins no se instalan:**
```bash
rm -rf ~/.local/share/nvim
nvim --headless "+Lazy! sync" +qa
```

**LSP no funciona:**
```bash
:checkhealth
:Mason
```

**Errores de permisos:**
```bash
termux-setup-storage
chmod +x ~/.config/nvim-config/android/install.sh
```

### Logs y debugging
```bash
# Ver logs de Termux
logcat | grep termux

# Debug de Neovim
nvim --startuptime startup.log
nvim -V9log.txt
```

## 🔄 Actualizaciones

### Actualizar la configuración
```bash
cd ~/.config/nvim-config
git pull
cd android
./install.sh
```

### Actualizar paquetes
```bash
pkg update && pkg upgrade
:Lazy sync
:Mason update
```

## 🤝 Contribuir

¿Encontraste un bug o tienes una mejora? ¡Contribuye!

1. Fork del repositorio
2. Crea una rama para tu feature
3. Haz tus cambios
4. Prueba en Android
5. Envía un Pull Request

## 📄 Licencia

MIT License - Ver LICENSE file para más detalles.

## 🆘 Soporte

- **Issues**: [GitHub Issues](https://github.com/tu-usuario/nvim-vscode-config/issues)
- **Discussions**: [GitHub Discussions](https://github.com/tu-usuario/nvim-vscode-config/discussions)
- **Android/Termux específico**: Incluye información del dispositivo y versión de Android

---

Hecho con ❤️ para desarrolladores que aman Android y Neovim
- **Responsive UI**: Se adapta automáticamente al tamaño de pantalla
- **Touch optimizations**: Elementos de UI más grandes para dedos
- **Text scaling**: Texto optimizado para legibilidad móvil

## 📁 Estructura del proyecto

```
android/
├── install.sh              # Script de instalación automática
├── init.lua                # Configuración principal
├── lua/
│   ├── config/
│   │   ├── options.lua     # Opciones específicas Android
│   │   ├── keymaps.lua     # Mapas de teclas móviles
│   │   ├── autocmds.lua    # Auto-comandos optimizados
│   │   └── icons.lua       # Iconos para terminal
│   └── plugins/
│       ├── ui.lua          # Interface de usuario móvil
│       ├── explorer.lua    # Explorador de archivos
│       ├── telescope.lua   # Búsqueda y navegación
│       ├── lsp.lua         # Language servers
│       ├── completion.lua  # Auto-completado
│       ├── treesitter.lua  # Syntax highlighting
│       ├── git.lua         # Integración Git
│       ├── terminal.lua    # Terminal integrado
│       ├── debug.lua       # Debugging (DAP)
│       └── tools.lua       # Herramientas adicionales
└── README.md               # Esta documentación
```

## 🎨 Temas y personalización

### Tema principal: Tokyo Night
- **Colores optimizados** para pantallas móviles
- **Contraste mejorado** para legibilidad
- **Elementos UI grandes** para interacción táctil

### Personalización
```lua
-- En ~/.config/nvim/lua/config/options.lua
-- Ajustar el tema
vim.g.tokyonight_style = "night" -- storm, moon, night, day
vim.g.tokyonight_transparent = false -- Para mejor visibilidad
```

## 🔧 Solución de problemas

### Problemas comunes

**1. Fuentes no se muestran correctamente**
```bash
# Instalar fuentes Nerd Font
pkg install fontconfig
# O usar fuentes simples ASCII
echo 'vim.g.use_nerd_font = false' >> ~/.config/nvim/init.lua
```

**2. LSP servers no funcionan**
```bash
# Verificar instalación de Node.js
node --version
npm --version

# Reinstalar language servers
npm install -g typescript-language-server typescript
```

**3. Git no funciona**
```bash
# Configurar Git
git config --global user.name "Tu Nombre"
git config --global user.email "tu@email.com"
```

**4. Termux:API no responde**
```bash
# Verificar Termux:API
termux-clipboard-get
# Si falla, instalar Termux:API desde F-Droid
```

### Optimización de rendimiento

**Para dispositivos con poca RAM:**
```lua
-- Añadir a init.lua
vim.g.android_low_memory = true
vim.opt.updatetime = 1000
vim.opt.timeoutlen = 500
```

**Para mejor duración de batería:**
```lua
-- Reducir frecuencia de actualizaciones
vim.opt.updatetime = 2000
vim.g.lazy_redraw = true
```

## 📚 Comandos útiles

### Gestión de plugins
```vim
:Lazy                " Gestor de plugins
:Lazy update         " Actualizar plugins
:Lazy clean          " Limpiar plugins no usados
:Mason               " Gestor de LSP servers
```

### Información del sistema
```vim
:checkhealth         " Verificar configuración
:LspInfo             " Estado de LSP servers
:version             " Versión de Neovim
```

### Termux específicos
```bash
# Información del sistema
termux-info

# Gestión de paquetes
pkg list-installed
pkg search <nombre>
pkg show <paquete>

# Acceso a almacenamiento
termux-setup-storage
```

## 🤝 Contribuir

¡Las contribuciones son bienvenidas! Por favor:

1. Fork el repositorio
2. Crea una rama para tu feature (`git checkout -b feature/amazing-feature`)
3. Commit tus cambios (`git commit -m 'Add amazing feature'`)
4. Push a la rama (`git push origin feature/amazing-feature`)
5. Abre un Pull Request

### Áreas donde puedes contribuir
- Optimizaciones específicas para diferentes dispositivos Android
- Nuevos language servers y herramientas
- Mejoras en la UI móvil
- Integración con más APIs de Termux
- Documentación y tutoriales

## 📄 Licencia

Este proyecto está bajo la Licencia MIT. Ver el archivo `LICENSE` para más detalles.

## 🙏 Agradecimientos

- **Neovim team** por el increíble editor
- **Termux team** por hacer posible Linux en Android
- **Tokyo Night** por el hermoso tema
- **Comunidad de plugins** por las increíbles herramientas

---

## 📞 Soporte

¿Tienes problemas o preguntas?

- 🐛 **Issues**: [GitHub Issues](https://github.com/tu-usuario/nvim-vscode-config/issues)
- 💬 **Discusiones**: [GitHub Discussions](https://github.com/tu-usuario/nvim-vscode-config/discussions)
- 📧 **Email**: tu-email@ejemplo.com

---

**¡Disfruta programando en tu dispositivo Android! 🚀📱**
