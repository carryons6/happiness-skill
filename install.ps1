#!/usr/bin/env pwsh
#
# Happiness skill installer for Codex (Windows)
#
#   iwr -useb https://raw.githubusercontent.com/carryons6/happiness-skill/main/install.ps1 | iex
#
# Installs the skill into  $env:CODEX_HOME\skills\happiness  (default ~\.codex\skills\happiness).
# Re-running updates an existing install. Environment overrides:
#   CODEX_HOME            Codex home dir            (default: ~\.codex)
#   HAPPINESS_REF         branch or tag to install  (default: main)
#   HAPPINESS_REPO_URL    git clone URL
#   HAPPINESS_REPO_ZIP    zip URL used when git is unavailable
#
$ErrorActionPreference = 'Stop'

$SkillName = 'happiness'
$Ref       = if ($env:HAPPINESS_REF)      { $env:HAPPINESS_REF }      else { 'main' }
$RepoUrl   = if ($env:HAPPINESS_REPO_URL) { $env:HAPPINESS_REPO_URL } else { 'https://github.com/carryons6/happiness-skill.git' }
$RepoZip   = if ($env:HAPPINESS_REPO_ZIP) { $env:HAPPINESS_REPO_ZIP } else { "https://github.com/carryons6/happiness-skill/archive/refs/heads/$Ref.zip" }
$CodexHome = if ($env:CODEX_HOME)         { $env:CODEX_HOME }         else { Join-Path $HOME '.codex' }
$SkillsDir = Join-Path $CodexHome 'skills'
$TargetDir = Join-Path $SkillsDir $SkillName

function Info($m) { Write-Host "==> $m" -ForegroundColor Cyan }
function Warn($m) { Write-Host "warning: $m" -ForegroundColor Yellow }

Info "Installing the '$SkillName' skill into $TargetDir"
New-Item -ItemType Directory -Force -Path $SkillsDir | Out-Null

# Back up a pre-existing non-git install so we never clobber local edits silently.
if ((Test-Path $TargetDir) -and -not (Test-Path (Join-Path $TargetDir '.git'))) {
  $backup = "$TargetDir.backup.$(Get-Date -Format 'yyyyMMddHHmmss')"
  Warn "Existing install found at $TargetDir; moving it to $backup"
  Move-Item -Path $TargetDir -Destination $backup
}

$git = Get-Command git -ErrorAction SilentlyContinue
if ($git) {
  if (Test-Path (Join-Path $TargetDir '.git')) {
    Info "Updating existing install (git)"
    git -C $TargetDir fetch --depth 1 origin $Ref
    git -C $TargetDir checkout -q -B $Ref "origin/$Ref"
    git -C $TargetDir reset --hard -q "origin/$Ref"
  } else {
    Info "Cloning $RepoUrl ($Ref)"
    git clone --depth 1 --branch $Ref $RepoUrl $TargetDir
  }
} else {
  Warn "git not found; falling back to downloading a zip"
  $tmp = Join-Path ([System.IO.Path]::GetTempPath()) ("happiness-" + [System.Guid]::NewGuid().ToString())
  New-Item -ItemType Directory -Force -Path $tmp | Out-Null
  try {
    $zip = Join-Path $tmp 'happiness.zip'
    Invoke-WebRequest -UseBasicParsing -Uri $RepoZip -OutFile $zip
    Expand-Archive -Path $zip -DestinationPath $tmp -Force
    $extracted = Get-ChildItem -Path $tmp -Directory | Select-Object -First 1
    if (-not $extracted) { throw "Downloaded archive looked empty." }
    New-Item -ItemType Directory -Force -Path $TargetDir | Out-Null
    Copy-Item -Path (Join-Path $extracted.FullName '*') -Destination $TargetDir -Recurse -Force
  } finally {
    Remove-Item -Recurse -Force $tmp -ErrorAction SilentlyContinue
  }
}

if (-not (Test-Path (Join-Path $TargetDir 'SKILL.md'))) {
  throw "Install finished but $TargetDir\SKILL.md is missing; something went wrong."
}

Info "Done. The '$SkillName' skill is installed at $TargetDir"
Info "Restart Codex so it can discover the new skill."
