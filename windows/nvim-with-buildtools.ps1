# ══════════════════════════════════════════════════════════════════════
# Neovim Launcher with Visual Studio Build Tools
# This script sets up the development environment before launching Neovim
# ══════════════════════════════════════════════════════════════════════

# Find Visual Studio Build Tools installation
$vsPaths = @(
    "C:\Program Files\Microsoft Visual Studio\2022\Community",
    "C:\Program Files (x86)\Microsoft Visual Studio\2022\BuildTools",
    "C:\Program Files\Microsoft Visual Studio\2022\BuildTools",
    "C:\Program Files (x86)\Microsoft Visual Studio\2019\BuildTools",
    "C:\Program Files\Microsoft Visual Studio\2019\BuildTools"
)

$vsPath = $null
foreach ($path in $vsPaths) {
    if (Test-Path "$path\VC\Auxiliary\Build\vcvars64.bat") {
        $vsPath = $path
        break
    }
}

if ($vsPath) {
    Write-Host "🔧 Configurando entorno de Visual Studio Build Tools..." -ForegroundColor Cyan
    
    # Set up Visual Studio environment variables
    $vcvarsPath = "$vsPath\VC\Auxiliary\Build\vcvars64.bat"
    
    # Run vcvars64.bat and capture environment variables
    $psi = New-Object System.Diagnostics.ProcessStartInfo
    $psi.FileName = "cmd.exe"
    $psi.Arguments = "/c `"$vcvarsPath`" && set"
    $psi.RedirectStandardOutput = $true
    $psi.UseShellExecute = $false
    $psi.CreateNoWindow = $true
    
    $process = [System.Diagnostics.Process]::Start($psi)
    $output = $process.StandardOutput.ReadToEnd()
    $process.WaitForExit()
    
    # Parse and set environment variables
    foreach ($line in $output -split "`r`n") {
        if ($line -match "^(.+?)=(.*)$") {
            $name = $matches[1]
            $value = $matches[2]
            
            # Only set important variables for compilation
            if ($name -match "^(PATH|INCLUDE|LIB|LIBPATH|VSINSTALLDIR|VCINSTALLDIR|WindowsSdkDir)$") {
                [Environment]::SetEnvironmentVariable($name, $value, "Process")
            }
        }
    }
    
    # Verify compiler is available
    $clPath = Get-Command cl.exe -ErrorAction SilentlyContinue
    if ($clPath) {
        Write-Host "✅ Compilador MSVC configurado correctamente" -ForegroundColor Green
        Write-Host "📍 Ruta del compilador: $($clPath.Source)" -ForegroundColor Gray
    } else {
        Write-Host "⚠️  Advertencia: No se pudo configurar el compilador" -ForegroundColor Yellow
    }
} else {
    Write-Host "⚠️  Visual Studio Build Tools no encontrado" -ForegroundColor Yellow
    Write-Host "💡 Instala con: winget install Microsoft.VisualStudio.2022.BuildTools" -ForegroundColor Gray
}

# Launch Neovim
Write-Host "🚀 Iniciando Neovim..." -ForegroundColor Green
if ($args.Count -gt 0) {
    & nvim @args
} else {
    & nvim
}
