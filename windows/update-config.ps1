#!/usr/bin/env pwsh

<#
.SYNOPSIS
    Update Neovim Configuration - Copy local config to Neovim directory
.DESCRIPTION
    This script copies the corrected local Neovim configuration from the current workspace
    to the Neovim configuration directory, overwriting any existing configuration.
.NOTES
    Author: Neovim VS Code Config
    Version: 1.0
#>

param(
    [switch]$Force,
    [switch]$Backup
)

# Set error action preference
$ErrorActionPreference = 'Stop'

# Colors for output
$colors = @{
    Success = 'Green'
    Error   = 'Red'
    Warning = 'Yellow'
    Info    = 'Cyan'
    Header  = 'Magenta'
}

function Write-ColorText {
    param([string]$Text, [string]$Color = 'White')
    Write-Host $Text -ForegroundColor $colors[$Color]
}

function Write-Header {
    param([string]$Text)
    Write-Host ""
    Write-ColorText "=== $Text ===" -Color Header
    Write-Host ""
}

function Test-Administrator {
    $currentUser = [Security.Principal.WindowsIdentity]::GetCurrent()
    $principal = New-Object Security.Principal.WindowsPrincipal($currentUser)
    return $principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
}

function Backup-ExistingConfig {
    param([string]$ConfigPath)
    
    if (Test-Path $ConfigPath) {
        $backupPath = "$ConfigPath.backup.$(Get-Date -Format 'yyyyMMdd-HHmmss')"
        Write-ColorText "Creating backup at: $backupPath" -Color Info
        Copy-Item -Path $ConfigPath -Destination $backupPath -Recurse -Force
        return $backupPath
    }
    return $null
}

# Main execution
try {
    Write-Header "Neovim Configuration Update"
    
    # Get script directory
    $scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
    if ([string]::IsNullOrEmpty($scriptDir)) {
        $scriptDir = Get-Location
    }
    
    Write-ColorText "Script directory: $scriptDir" -Color Info
    
    # Define paths
    $sourceConfigPath = Join-Path $scriptDir "."
    $nvimConfigPath = "$env:LOCALAPPDATA\nvim"
    
    # Verify source configuration exists
    $sourceInitLua = Join-Path $sourceConfigPath "init.lua"
    if (-not (Test-Path $sourceInitLua)) {
        throw "Source configuration not found at: $sourceConfigPath"
    }
    
    Write-ColorText "Source config found: $sourceConfigPath" -Color Success
    Write-ColorText "Target config path: $nvimConfigPath" -Color Info
    
    # Create backup if requested
    if ($Backup -and (Test-Path $nvimConfigPath)) {
        $backupPath = Backup-ExistingConfig $nvimConfigPath
        if ($backupPath) {
            Write-ColorText "Backup created successfully" -Color Success
        }
    }
    
    # Remove existing configuration if it exists
    if (Test-Path $nvimConfigPath) {
        if ($Force -or $Backup) {
            Write-ColorText "Removing existing configuration..." -Color Warning
            Remove-Item -Path $nvimConfigPath -Recurse -Force
        } else {
            $response = Read-Host "Existing configuration found. Remove it? (y/N)"
            if ($response -eq 'y' -or $response -eq 'Y') {
                Remove-Item -Path $nvimConfigPath -Recurse -Force
            } else {
                throw "Installation cancelled by user"
            }
        }
    }
    
    # Create nvim config directory
    Write-ColorText "Creating Neovim configuration directory..." -Color Info
    New-Item -ItemType Directory -Path $nvimConfigPath -Force | Out-Null
    
    # Copy configuration files
    Write-ColorText "Copying configuration files..." -Color Info
    
    # Copy init.lua
    Copy-Item -Path (Join-Path $sourceConfigPath "init.lua") -Destination $nvimConfigPath -Force
    
    # Copy lua directory
    $sourceLuaPath = Join-Path $sourceConfigPath "lua"
    $targetLuaPath = Join-Path $nvimConfigPath "lua"
    
    if (Test-Path $sourceLuaPath) {
        Copy-Item -Path $sourceLuaPath -Destination $targetLuaPath -Recurse -Force
    }
    
    # Verify installation
    Write-ColorText "Verifying installation..." -Color Info
    
    $requiredFiles = @(
        "init.lua",
        "lua\config\options.lua",
        "lua\config\keymaps.lua",
        "lua\config\autocmds.lua",
        "lua\plugins\lsp.lua"
    )
    
    $allFilesExist = $true
    foreach ($file in $requiredFiles) {
        $filePath = Join-Path $nvimConfigPath $file
        if (Test-Path $filePath) {
            Write-ColorText "✓ $file" -Color Success
        } else {
            Write-ColorText "✗ $file (missing)" -Color Error
            $allFilesExist = $false
        }
    }
    
    if ($allFilesExist) {
        Write-Header "Configuration Update Completed Successfully!"
        Write-ColorText "Your Neovim configuration has been updated with the corrected settings." -Color Success
        Write-ColorText "You can now launch Neovim with: nvim" -Color Info
        Write-Host ""
        Write-ColorText "To test the configuration:" -Color Info
        Write-ColorText "  nvim --version" -Color Info
        Write-ColorText "  nvim +checkhealth" -Color Info
        Write-Host ""
    } else {
        throw "Some configuration files are missing. Installation may be incomplete."
    }
    
} catch {
    Write-Header "Configuration Update Failed"
    Write-ColorText "Error: $($_.Exception.Message)" -Color Error
    Write-ColorText "Please check the error details and try again." -Color Warning
    exit 1
}
