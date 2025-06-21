# NVIM a VS Code configuration

This repository contains a configuration for Neovim for my tablet (Android & Termux) and desktop (Windows Powershell). 

The idea is to have a consistent development environment across devices, leveraging Neovim's capabilities and plugins to provide a rich coding experience similar to VS Code.

Same shortcuts and keybindings as VS Code, with a focus on Go, Python, React and Astro development.

## Features
- **Keybindings**: Mimics VS Code shortcuts for a familiar experience.
- **Language Support**: Enhanced support for Go, Python, React, and Astro.
- **Plugins**: A curated set of plugins to enhance functionality and productivity.
- **LSP Integration**: Language Server Protocol support for better code intelligence.
- **Debugging**: Integrated debugging capabilities.
- **Terminal Integration**: Built-in terminal for running commands and scripts.

## 🚀 Quick Installation

### Windows (PowerShell)

**One-line installation:**
```powershell
Set-ExecutionPolicy Bypass -Scope Process -Force; Invoke-Expression (Invoke-WebRequest -Uri "https://raw.githubusercontent.com/your-username/nvim-vscode-config/main/windows/install.ps1" -UseBasicParsing).Content
```

**Or manual installation:**
1. Open PowerShell as Administrator
2. Navigate to the `windows` folder
3. Run `.\install.ps1`

See [Windows README](windows/README.md) for detailed instructions.

### Android (Termux)

Coming soon! Configuration for Android devices using Termux.

## 📁 Structure

```
nvim-vscode-config/
├── windows/                 # Windows PowerShell configuration
│   ├── init.lua            # Main configuration file
│   ├── lua/                # Lua configuration modules
│   ├── install.ps1         # Automated installation script
│   ├── installation.md     # Manual installation guide
│   └── README.md           # Windows-specific documentation
├── android/                # Android/Termux configuration (coming soon)
└── README.md              # This file
```

## 🎯 Supported Languages

- **JavaScript/TypeScript** - Full LSP, debugging, testing
- **Python** - Complete development environment
- **Go** - LSP, debugging, testing
- **Rust** - Language server and debugging
- **Lua** - Neovim configuration development
- **Astro** - Modern web framework support
- **HTML/CSS** - Web development essentials
- **JSON/YAML** - Configuration files
- **Markdown** - Documentation with preview

## 🎮 Key Features

### VS Code-like Experience
- `Ctrl+P` - Quick file search
- `Ctrl+S` - Save file
- `Ctrl+/` - Toggle comments
- `F5` - Start debugging
- `F12` - Go to definition
- `Ctrl+Shift+P` - Command palette

### Modern Development Tools
- **Telescope** - Fuzzy finder for everything
- **nvim-tree** - File explorer with Git integration
- **LazyGit** - Beautiful Git interface
- **Mason** - Easy LSP server management
- **DAP** - Debug Adapter Protocol
- **Neotest** - Modern testing interface

### Beautiful UI
- Tokyo Night theme
- Nerd Font icons
- Smooth animations
- Modern statusline and tabline
- Floating windows with borders

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## 📝 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
