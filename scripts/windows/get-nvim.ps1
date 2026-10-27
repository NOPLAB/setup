param([string]$Source = (Join-Path $env:LOCALAPPDATA 'nvim'))

$ErrorActionPreference = 'Stop'
$destination = Join-Path $PSScriptRoot '../../config/nvim'
$files = @('init.lua', 'lua/config/lazy.lua') + @(
    Get-ChildItem -LiteralPath (Join-Path $Source 'lua/plugins') -File |
        ForEach-Object { "lua/plugins/$($_.Name)" }
)

foreach ($file in $files) {
    $target = Join-Path $destination $file
    New-Item -ItemType Directory -Path (Split-Path $target) -Force | Out-Null
    Copy-Item -LiteralPath (Join-Path $Source $file) -Destination $target -Force
    Write-Host "$target <= $file"
}
