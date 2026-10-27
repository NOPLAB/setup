param([string]$Source = (Join-Path $env:LOCALAPPDATA 'nvim'))

$ErrorActionPreference = 'Stop'
$destination = Join-Path $PSScriptRoot '../../config/nvim'
$requiredFiles = @('init.lua', 'lazy-lock.json', 'lua/config/lazy.lua')
foreach ($file in $requiredFiles) {
    if (-not (Test-Path -LiteralPath (Join-Path $Source $file) -PathType Leaf)) {
        throw "Missing configuration file: $(Join-Path $Source $file)"
    }
}
$plugins = @(
    Get-ChildItem -LiteralPath (Join-Path $Source 'lua/plugins') -File -Force |
        ForEach-Object { "lua/plugins/$($_.Name)" }
)
if ($plugins.Count -eq 0) {
    throw "No plugin files found in $(Join-Path $Source 'lua/plugins')"
}
$files = @('init.lua', 'lazy-lock.json') + @(
    Get-ChildItem -LiteralPath (Join-Path $Source 'lua/config') -File -Force |
        ForEach-Object { "lua/config/$($_.Name)" }
) + $plugins

foreach ($file in $files) {
    $target = Join-Path $destination $file
    New-Item -ItemType Directory -Path (Split-Path $target) -Force | Out-Null
    Copy-Item -LiteralPath (Join-Path $Source $file) -Destination $target -Force
    Write-Host "$target <= $file"
}
