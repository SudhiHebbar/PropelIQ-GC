#!/usr/bin/env pwsh
<#!
.SYNOPSIS
  Setup prototype generation environment and emit resolved parameters.
.DESCRIPTION
  Deterministic environment script for prototype workflow. Only supports -Json / -Help.
  Does NOT create directories (deferred until scope confirmation).
.PARAMETER Json
  Emit JSON output.
.PARAMETER Help
  Show usage help.
#>
[CmdletBinding()] param(
  [switch]$Json,
  [switch]$Help
)

if ($Help) {
  Write-Output "Usage: ./setup-prototype.ps1 [-Json] [-Help]"
  Write-Output "  -Json   Output environment JSON"
  Write-Output "  -Help   Show this help message"
  exit 0
}

$ErrorActionPreference = 'Stop'
$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$common = Join-Path $scriptDir 'common.ps1'
if (Test-Path $common) { . $common }

function Resolve-RepoRoot {
  if (Get-Command git -ErrorAction SilentlyContinue) {
    try {
      $gitRoot = git rev-parse --show-toplevel 2>$null
      if ($LASTEXITCODE -eq 0 -and $gitRoot) { return $gitRoot }
    } catch {}
  }
  return (Resolve-Path (Join-Path $scriptDir '../../..')).Path
}

$repoRoot = Resolve-RepoRoot
$status = 'OK'
if (-not (Test-Path -Path $repoRoot -PathType Container)) { $status = 'FATAL_REPO_ACCESS' }

$prototypeDir = Join-Path $repoRoot 'prototype'
$srcDir = Join-Path $prototypeDir 'src'
$timestamp = (Get-Date).ToUniversalTime().ToString('yyyy-MM-ddTHH:mm:ssZ')
$agentVersion = 'prototype-agent-1.0'

if ($Json) {
  $obj = [ordered]@{
    repo_root     = $repoRoot
    prototype_dir = $prototypeDir
    src_dir       = $srcDir
    timestamp_utc = $timestamp
    agent_version = $agentVersion
    status        = $status
  }
  ($obj | ConvertTo-Json -Compress)
} else {
  Write-Output "repo_root: $repoRoot"
  Write-Output "prototype_dir: $prototypeDir"
  Write-Output "src_dir: $srcDir"
  Write-Output "timestamp_utc: $timestamp"
  Write-Output "agent_version: $agentVersion"
  Write-Output "status: $status"
}

if ($status -ne 'OK') { exit 2 }
