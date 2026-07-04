#Requires -Version 5.1
<#
    GOD SERVER - Bootstrap Loader
    Launch with:
        irm https://raw.githubusercontent.com/sanjulaAI/GodServer/main/bootstrap.ps1 | iex
    Auto-elevates, downloads the latest GodServer.ps1 fresh, and runs it.
    Nothing is saved to disk after the run.
#>

$ErrorActionPreference = 'Stop'
$RepoBase = 'https://raw.githubusercontent.com/sanjulaAI/GodServer/main'

# Elevate if needed
$principal = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
if (-not $principal.IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator)) {
    $cmd = "irm $RepoBase/bootstrap.ps1?v=$(Get-Random) | iex"
    Start-Process powershell.exe -Verb RunAs -ArgumentList @('-NoProfile','-ExecutionPolicy','Bypass','-Command',$cmd)
    exit
}

$tmp = Join-Path $env:TEMP "GodServer_$(Get-Random).ps1"
try {
    Invoke-WebRequest -Uri "$RepoBase/GodServer.ps1?v=$(Get-Random)" -OutFile $tmp -UseBasicParsing
    & $tmp -NoElevate
} finally {
    Remove-Item $tmp -Force -ErrorAction SilentlyContinue
}
