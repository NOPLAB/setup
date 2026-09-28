param([string]$Destination = (Join-Path $env:LOCALAPPDATA 'nvim'))

$ErrorActionPreference = 'Stop'
$source = Join-Path $PSScriptRoot 'nvim'
$files = @('init.lua', 'lua/config/lazy.lua') + @(
    Get-ChildItem -LiteralPath (Join-Path $source 'lua/plugins') -File |
        ForEach-Object { "lua/plugins/$($_.Name)" }
)

foreach ($file in $files) {
    $target = Join-Path $Destination $file
    New-Item -ItemType Directory -Path (Split-Path $target) -Force | Out-Null
    Copy-Item -LiteralPath (Join-Path $source $file) -Destination $target -Force
    Write-Host "$target <= $file"
}
