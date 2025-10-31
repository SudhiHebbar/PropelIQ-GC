#!/usr/bin/env pwsh
<#!
.SYNOPSIS
  Setup specification generation environment and emit resolved parameters.
.DESCRIPTION
  Deterministic environment script for spec generation. Only supports -Json / -Help.
  Returns repository + docs + template directory resolution and a timestamp.
.PARAMETER Json
  Emit JSON (machine readable) output.
.PARAMETER Help
  Show usage information.
#>
[CmdletBinding()] param(
  [switch]$Json,
  [switch]$Help
)

if ($Help) {
  Write-Output "Usage: ./setup-spec.ps1 [-Json] [-Help]"
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

$contextBase   = Join-Path $repoRoot '.propel/context'
$docsDir       = Join-Path $contextBase 'docs'
$templatesDir  = Join-Path $repoRoot '.github/templates'
New-Item -ItemType Directory -Path $docsDir -Force | Out-Null

$timestamp = (Get-Date).ToUniversalTime().ToString('yyyy-MM-ddTHH:mm:ssZ')
$agentVersion = 'spec-agent-1.0'

if ($Json) {
  $obj = [ordered]@{
    repo_root     = $repoRoot
    docs_dir      = $docsDir
    templates_dir = $templatesDir
    timestamp_utc = $timestamp
    agent_version = $agentVersion
    status        = $status
  }
  ($obj | ConvertTo-Json -Compress)
} else {
  Write-Output "repo_root: $repoRoot"
  Write-Output "docs_dir: $docsDir"
  Write-Output "templates_dir: $templatesDir"
  Write-Output "timestamp_utc: $timestamp"
  Write-Output "agent_version: $agentVersion"
  Write-Output "status: $status"
}

if ($status -ne 'OK') { exit 2 }
