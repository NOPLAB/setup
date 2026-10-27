param([switch]$ListOnly)

$ErrorActionPreference = 'Stop'
$packages = @(
    # Browsers and everyday apps
    'Google.Chrome'
    'Mozilla.Firefox'
    'AgileBits.1Password'
    'Anthropic.Claude'
    'Discord.Discord'
    'SlackTechnologies.Slack'
    'Microsoft.Teams'
    'Zoom.Zoom.EXE'
    'Microsoft.Office'
    'Google.GoogleDrive'
    'Obsidian.Obsidian'
    'DigitalScholar.Zotero'
    'Anki.Anki'
    'Amazon.Kindle'
    'Spotify.Spotify'
    'Valve.Steam'

    # Development
    'Git.Git'
    'GitHub.cli'
    'Microsoft.VisualStudioCode'
    'Microsoft.VisualStudio.Community'
    'Microsoft.VisualStudio.BuildTools'
    'JetBrains.Toolbox'
    'Neovim.Neovim'
    'vim.vim'
    'Helix.Helix'
    'ZedIndustries.Zed'
    'Docker.DockerDesktop'
    'RedHat.Podman-Desktop'
    'Podman.CLI'
    'Microsoft.WSL'
    'Microsoft.WindowsTerminal'
    'Microsoft.PowerShell'
    'Rustlang.Rustup'
    'GoLang.Go'
    'Python.PythonInstallManager'
    'Schniz.fnm'
    'pnpm.pnpm'
    'Microsoft.OpenJDK.25'
    'LLVM.LLVM'
    'GnuWin32.Make'
    'Arm.GnuArmEmbeddedToolchain'
    'nektos.act'

    # Creative and CAD
    'Adobe.Acrobat.Pro'
    'Adobe.CreativeCloud'
    'Autodesk.Fusion'
    'FreeCAD.FreeCAD'
    'KiCad.KiCad'
    'BlenderFoundation.Blender'
    'OBSProject.OBSStudio'

    # Utilities and remote access
    '7zip.7zip'
    'Microsoft.PowerToys'
    'voidtools.Everything'
    'AntibodySoftware.WizTree'
    'CrystalDewWorld.CrystalDiskInfo.ShizukuEdition'
    'CrystalDewWorld.CrystalDiskMark'
    'WiresharkFoundation.Wireshark'
    'Insecure.Nmap'
    'Tailscale.Tailscale'
    'Cloudflare.Warp'
    'Parsec.Parsec'
    'NoMachine.NoMachine'
    'Gyan.FFmpeg'
    'BurntSushi.ripgrep.MSVC'
    'jqlang.jq'
    'Microsoft.Coreutils'
    'JernejSimoncic.Wget'
    'Atuinsh.Atuin'
    'Fastfetch-cli.Fastfetch'
    'UB-Mannheim.TesseractOCR'
    'dorssel.usbipd-win'
    'LGUG2Z.whkd'
    'TeraTermProject.teraterm5'
    'Olivia.VIA'
)

if ($ListOnly) { $packages; return }
Get-Command winget -ErrorAction Stop | Out-Null

$failed = @()
foreach ($id in $packages) {
    winget install --id $id --exact --source winget --no-upgrade --silent --disable-interactivity --accept-source-agreements --accept-package-agreements
    if ($LASTEXITCODE -ne 0) { $failed += $id }
}
if ($failed.Count) { throw "winget install failed: $($failed -join ', ')" }
