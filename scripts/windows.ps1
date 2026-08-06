#Requires -Version 5.1

param(
    [switch] $Optional
)

$ErrorActionPreference = "Stop"

if (-not (Get-Command winget -ErrorAction SilentlyContinue)) {
    Write-Host "winget not found. Install 'App Installer' from the Microsoft Store." -ForegroundColor Red
    exit 1
}

function Install-Dep {
    param(
        [string] $Name,
        [string] $Probe,
        [string] $Id,
        [string] $Override
    )

    if ($Probe -and (Get-Command $Probe -ErrorAction SilentlyContinue)) {
        Write-Host "$Name already installed" -ForegroundColor DarkGray
        return
    }

    Write-Host "installing $Name" -ForegroundColor Cyan
    if ($Override) {
        winget install --id $Id -e --accept-package-agreements --accept-source-agreements --override $Override
    }
    else {
        winget install --id $Id -e --accept-package-agreements --accept-source-agreements
    }
}

Install-Dep -Name "Neovim"  -Probe "nvim"  -Id "Neovim.Neovim"
Install-Dep -Name "Git"     -Probe "git"   -Id "Git.Git"
Install-Dep -Name "CMake"   -Probe "cmake" -Id "Kitware.CMake"
Install-Dep -Name "Node.js" -Probe "node"  -Id "OpenJS.NodeJS.LTS"
Install-Dep -Name "ripgrep" -Probe "rg"    -Id "BurntSushi.ripgrep.MSVC"

Install-Dep -Name "MSVC build tools" -Probe "cl" -Id "Microsoft.VisualStudio.2022.BuildTools" `
    -Override "--quiet --wait --add Microsoft.VisualStudio.Workload.VCTools --includeRecommended"

Install-Dep -Name "JetBrainsMono Nerd Font" -Probe "" -Id "DEVCOM.JetBrainsMonoNerdFont"

if ($Optional) {
    Write-Host ""
    Write-Host "optional extras" -ForegroundColor Cyan
    Install-Dep -Name "Python 3" -Probe "python" -Id "Python.Python.3.13"
    Install-Dep -Name ".NET SDK" -Probe "dotnet" -Id "Microsoft.DotNet.SDK.9"
    Install-Dep -Name "rustup"   -Probe "rustup" -Id "Rustlang.Rustup"
    Install-Dep -Name "fd"       -Probe "fd"     -Id "sharkdp.fd"
    Install-Dep -Name "VS Code"  -Probe "code"   -Id "Microsoft.VisualStudioCode"
}
else {
    Write-Host ""
    Write-Host "skipped optional extras (Python, .NET SDK, rustup, fd, VS Code)." -ForegroundColor DarkGray
    Write-Host "re-run with -Optional to install them."  -ForegroundColor DarkGray
}

Write-Host ""
Write-Host "Done. Still to do by hand:" -ForegroundColor Green
Write-Host "  - set the Nerd Font in your terminal"
Write-Host "  - restart the shell so PATH updates take effect"
Write-Host "  - start nvim, then run :Lazy restore and the :MasonInstall line from the README"
