#!/usr/bin/env pwsh
<#!
.SYNOPSIS
  Setup implementation execution environment for task processing.
.DESCRIPTION
  Emits repository-root-derived environment paths for docs & tasks.
.PARAMETER Json
  Output JSON format.
.PARAMETER Help
  Show usage.
#>
[CmdletBinding()] param(
  [switch]$Json,
  [switch]$Help
)

if ($Help) {
  Write-Output "Usage: ./setup-implement.ps1 [-Json] [-Help]"
  Write-Output "  -Json   Output JSON"
  Write-Output "  -Help   Show this help message"
  exit 0
}

$ErrorActionPreference = 'Stop'
if (Test-Path "$PSScriptRoot/common.ps1") { . "$PSScriptRoot/common.ps1" }

function Get-RepoRoot-Fallback {
  param([string]$Start)
  $dir = (Resolve-Path $Start).Path
  while ($true) {
    if (Test-Path (Join-Path $dir '.git') -PathType Container -or (Test-Path (Join-Path $dir '.propel-root'))) { return $dir }
    $parent = Split-Path $dir -Parent
    if ($parent -eq $dir) { return $Start }
    $dir = $parent
  }
}

if (Get-Command Get-RepoRoot -ErrorAction SilentlyContinue) {
  $repoRoot = Get-RepoRoot
} else {
  $repoRoot = Get-RepoRoot-Fallback -Start $PSScriptRoot
}

$status = 'OK'
if (-not (Test-Path $repoRoot -PathType Container)) { $status = 'FATAL_REPO_ACCESS' }

$contextBase = Join-Path $repoRoot '.propel/context'
$docsDir     = Join-Path $contextBase 'docs'
$tasksRoot   = Join-Path $contextBase 'tasks'
New-Item -ItemType Directory -Path $docsDir -Force | Out-Null
New-Item -ItemType Directory -Path $tasksRoot -Force | Out-Null

if ($Json) {
  $obj = [ordered]@{
    repo_root = $repoRoot
    docs_dir  = $docsDir
    tasks_root = $tasksRoot
    status = $status
  }
  ($obj | ConvertTo-Json -Compress)
} else {
  Write-Output "repo_root: $repoRoot"
  Write-Output "docs_dir: $docsDir"
  Write-Output "tasks_root: $tasksRoot"
  Write-Output "status: $status"
}

if ($status -ne 'OK') { exit 2 }
