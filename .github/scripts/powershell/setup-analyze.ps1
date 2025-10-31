#!/usr/bin/env pwsh
<#!
.SYNOPSIS
  Setup repository analysis environment (fixed defaults) and emit resolved parameters.
.DESCRIPTION
  Only supports -Json and -Help. All analysis parameters use internal defaults.
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
  Write-Output "Usage: ./setup-analyze.ps1 [-Json] [-Help]"
  Write-Output "  -Json     Output results in JSON format"
  Write-Output "  -Help     Show this help message"
  exit 0
}

$ErrorActionPreference = 'Stop'
. "$PSScriptRoot/common.ps1"

# Resolve repository root directly (no branch/git logic)
$repoRoot = Get-RepoRoot

# Minimal set only; analysis parameters handled by agent internally
$resolvedRoot = $repoRoot

$status = 'OK'
if (-not (Test-Path -Path $resolvedRoot -PathType Container)) { $status = 'FATAL_REPO_ACCESS' }

$contextDir = Join-Path $repoRoot '.propel/context'
New-Item -ItemType Directory -Path $contextDir -Force | Out-Null
$outputPath = Join-Path $contextDir 'docs/codeanalysis.md'
$templatePath = Join-Path $repoRoot '.github/templates/analyze_template.md'

if ($Json) {
  $obj = [PSCustomObject]@{
    repo_root = $repoRoot
    output_path = $outputPath
    template_path = $templatePath
    status = $status
  }
  $obj | ConvertTo-Json -Compress
} else {
  Write-Output "repo_root: $repoRoot"
  Write-Output "output_path: $outputPath"
  Write-Output "template_path: $templatePath"
  Write-Output "status: $status"
}

if ($status -ne 'OK') { exit 2 }
