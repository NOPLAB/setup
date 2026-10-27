param([string]$Destination = (Join-Path $env:LOCALAPPDATA 'nvim'))

$ErrorActionPreference = 'Stop'
$source = Join-Path $PSScriptRoot '../../config/nvim'
$requiredFiles = @('init.lua', 'lazy-lock.json', 'lua/config/lazy.lua')
foreach ($file in $requiredFiles) {
    if (-not (Test-Path -LiteralPath (Join-Path $source $file) -PathType Leaf)) {
        throw "Missing configuration file: $(Join-Path $source $file)"
    }
}
$plugins = @(
    Get-ChildItem -LiteralPath (Join-Path $source 'lua/plugins') -File -Force |
        ForEach-Object { "lua/plugins/$($_.Name)" }
)
if ($plugins.Count -eq 0) {
    throw "No plugin files found in $(Join-Path $source 'lua/plugins')"
}
$files = @('init.lua', 'lazy-lock.json') + @(
    Get-ChildItem -LiteralPath (Join-Path $source 'lua/config') -File -Force |
        ForEach-Object { "lua/config/$($_.Name)" }
) + $plugins

foreach ($file in $files) {
    $target = Join-Path $Destination $file
    New-Item -ItemType Directory -Path (Split-Path $target) -Force | Out-Null
    Copy-Item -LiteralPath (Join-Path $source $file) -Destination $target -Force
    Write-Host "$target <= $file"
}
