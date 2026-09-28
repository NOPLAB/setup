param(
    [string]$CodexHome = $(if ($env:CODEX_HOME) { $env:CODEX_HOME } else { Join-Path $HOME '.codex' }),
    [string]$SkillsHome = (Join-Path $HOME '.agents\skills')
)

$ErrorActionPreference = 'Stop'
$source = Join-Path $PSScriptRoot 'codex'
$agents = Join-Path $source 'AGENTS.md'
if (-not (Test-Path -LiteralPath $agents -PathType Leaf)) { throw "Missing $agents" }
$managedHeader = '<!-- Managed by setup/install-codex.ps1 -->'
$destinationAgents = Join-Path $CodexHome 'AGENTS.md'
$existingAgents = Get-Item -LiteralPath $destinationAgents -Force -ErrorAction SilentlyContinue
if ($existingAgents -and ($existingAgents.PSIsContainer -or $existingAgents.LinkType -or
    ($existingAgents.Length -gt 0 -and
    -not (Get-Content -LiteralPath $destinationAgents -Raw).StartsWith($managedHeader)))) {
    throw "Destination already exists: $destinationAgents"
}

$links = @()
$sourceSkills = Join-Path $source 'skills'
if (Test-Path -LiteralPath $sourceSkills) {
    foreach ($skill in Get-ChildItem -LiteralPath $sourceSkills -Directory) {
        if (-not (Test-Path -LiteralPath (Join-Path $skill.FullName 'SKILL.md') -PathType Leaf)) {
            throw "Missing SKILL.md in $($skill.FullName)"
        }
        $links += @{ Path = Join-Path $SkillsHome $skill.Name; Target = $skill.FullName }
    }
}

foreach ($link in $links) {
    $existing = Get-Item -LiteralPath $link.Path -Force -ErrorAction SilentlyContinue
    if (-not $existing) { continue }
    $target = @($existing.Target) | Select-Object -First 1
    if ($existing.LinkType -and $target -and
        [IO.Path]::GetFullPath($target) -eq [IO.Path]::GetFullPath($link.Target)) { continue }
    throw "Destination already exists: $($link.Path)"
}

New-Item -ItemType Directory -Path $CodexHome -Force | Out-Null
[IO.File]::WriteAllText($destinationAgents, "$managedHeader`n$(Get-Content -LiteralPath $agents -Raw)",
    [Text.UTF8Encoding]::new($false))
Write-Host "$destinationAgents <= $agents"

foreach ($link in $links) {
    $existing = Get-Item -LiteralPath $link.Path -Force -ErrorAction SilentlyContinue
    if ($existing -and $existing.LinkType) { continue }
    New-Item -ItemType Directory -Path (Split-Path $link.Path) -Force | Out-Null
    New-Item -ItemType Junction -Path $link.Path -Target $link.Target | Out-Null
    Write-Host "$($link.Path) -> $($link.Target)"
}
