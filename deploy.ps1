# 按 MANIFEST 把仓库里的文件软链接到 $HOME 下（Windows 版）
# 用法：.\deploy.ps1 [MANIFEST]
# 创建软链接需要管理员权限，或在 设置 -> 开发者选项 里打开"开发人员模式"

param([string]$Manifest = "MANIFEST")

$ErrorActionPreference = "Stop"

# Emacs 在 Windows 上默认把 %APPDATA% 当家目录；设置 HOME 让它和 Linux 一样用用户目录
if (-not $env:HOME) {
    Write-Output "Creating HOME environment variable and targeting it to $env:USERPROFILE"
    [Environment]::SetEnvironmentVariable("HOME", $env:USERPROFILE, "User")
    $env:HOME = $env:USERPROFILE
} else {
    Write-Warning "HOME environment variable already exists ($env:HOME). Not modifying it."
}

function Symlink-File($File, $DestDir) {
    $Source = Join-Path $PSScriptRoot $File
    $Dir = if ($DestDir) { Join-Path $env:HOME $DestDir } else { $env:HOME }
    $Destination = Join-Path $Dir $File

    New-Item -ItemType Directory -Force -Path (Split-Path $Destination) | Out-Null

    $Existing = Get-Item $Destination -Force -ErrorAction SilentlyContinue
    if ($Existing -and $Existing.LinkType -eq "SymbolicLink") {
        Write-Warning "$Source already symlinked"
        return
    }

    if ($Existing) {
        Write-Error "$Destination exists but it's not a symlink. Please fix that manually"
        exit 1
    }

    New-Item -ItemType SymbolicLink -Path $Destination -Target $Source | Out-Null
    Write-Output "[OK] $Source -> $Destination"
}

foreach ($Row in Get-Content (Join-Path $PSScriptRoot $Manifest)) {
    if (-not $Row -or $Row.StartsWith("#")) {
        continue
    }

    $File, $Operation, $DestDir = $Row.Split("|")

    switch ($Operation) {
        "symlink" { Symlink-File $File $DestDir }
        default   { Write-Warning "Unknown operation $Operation. Skipping..." }
    }
}
