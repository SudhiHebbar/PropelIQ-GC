#!/usr/bin/env pwsh
<#!
.SYNOPSIS
  Setup implementation planning environment or resolve per-task output path.
.DESCRIPTION
  Dual-mode script.
    Init mode (default): emits repo_root, template_path, plan_doc_path.
    Task mode: requires -Task (and optional -UsId) to compute output path for a new task file.
.PARAMETER Json
  Output JSON format.
.PARAMETER Task
  Task title to resolve (enables task mode).
.PARAMETER UsId
  Explicit user story id (US_### or US_####) optional; autodetected if omitted.
.PARAMETER Help
  Show usage.
#>
[CmdletBinding()] param(
  [switch]$Json,
  [string]$Task,
  [string]$UsId,
  [switch]$Help
)

if ($Help) {
  Write-Output "Usage: ./setup-plan.ps1 [-Json] [-Task 'Title'] [-UsId US_123] [-Help]"
  Write-Output "  -Json       Output results in JSON format"
  Write-Output "  -Task       Resolve output for task title (task mode)"
  Write-Output "  -UsId       Optional explicit user story id (US_123)"  
  Write-Output "  -Help       Show this help message"
  exit 0
}

$ErrorActionPreference = 'Stop'
. "$PSScriptRoot/common.ps1"

$repoRoot = Get-RepoRoot
$status = 'OK'
if (-not (Test-Path -Path $repoRoot -PathType Container)) { $status = 'FATAL_REPO_ACCESS' }

$contextBase = Join-Path $repoRoot '.propel/context'
New-Item -ItemType Directory -Path $contextBase -Force | Out-Null
$tasksRoot = Join-Path $contextBase 'tasks'
# Backward compatibility: move legacy 'Tasks' directory if it exists and new lowercase doesn't
$legacyTasks = Join-Path $contextBase 'Tasks'
if ((Test-Path $legacyTasks) -and -not (Test-Path $tasksRoot)) { Move-Item -Path $legacyTasks -Destination $tasksRoot }
New-Item -ItemType Directory -Path $tasksRoot -Force | Out-Null
$planDocPath = Join-Path $contextBase 'implementation_plan.md'
$templatePath = Join-Path $repoRoot '.github/templates/task_template.md'
$docsDir = Join-Path $contextBase 'docs'
New-Item -ItemType Directory -Path $docsDir -Force | Out-Null

function Normalize-USId {
  param([string]$Raw)
  if (-not $Raw) { return $null }
  $m = [regex]::Match($Raw, '(?i)^(US)[_-]?(\d{3,4})$')
  if ($m.Success) { return ("US_{0}" -f $m.Groups[2].Value) }
  return $null
}

function Derive-USIdFromText {
  param([string]$Text)
  if (-not $Text) { return $null }
  $m = [regex]::Match($Text, '(?i)US[_-]?(\d{3,4})')
  if ($m.Success) { return ("US_{0}" -f $m.Groups[1].Value) }
  return $null
}

function To-Slug {
  param([string]$Title)
  if (-not $Title) { return '' }
  $s = $Title.ToLowerInvariant()
  $s = -join ($s.ToCharArray() | ForEach-Object { if ($_ -match '[a-z0-9 _-]') { $_ } })
  $s = $s -replace ' +', '_' -replace '_+', '_' -replace '^_', '' -replace '_$', ''
  return $s
}

function Next-Sequence {
  param([string]$Dir)
  if (-not (Test-Path $Dir)) { return '001' }
  $max = 0
  Get-ChildItem -Path $Dir -Filter '*.md' -File -ErrorAction SilentlyContinue | ForEach-Object {
    if ($_.Name -match '^(\d{3})_') {
      $val = [int]$matches[1]
      if ($val -gt $max) { $max = $val }
    }
  }
  return ('{0:000}' -f ($max + 1))
}

$mode = 'init'
$usIdNorm = $null
$slug = ''
$sequence = ''
$outputPath = ''
$targetDir = ''

if ($Task) {
  $mode = 'task'
  if (-not $UsId) { $UsId = Derive-USIdFromText -Text $Task }
  if ($UsId) { $usIdNorm = Normalize-USId -Raw $UsId }
  if ($UsId -and -not $usIdNorm) { $status = 'INVALID_US_ID' }
  if (-not $Task.Trim()) { $status = 'INVALID_TASK' }
  if ($status -eq 'OK') {
  if ($usIdNorm) { $targetDir = Join-Path $tasksRoot ($usIdNorm.ToLower()) } else { $targetDir = Join-Path $tasksRoot 'general' }
  New-Item -ItemType Directory -Path $targetDir -Force | Out-Null
    $slug = To-Slug -Title $Task
    if (-not $slug) { $status = 'INVALID_TASK' }
  }
  if ($status -eq 'OK') {
    $sequence = Next-Sequence -Dir $targetDir
    $outputPath = Join-Path $targetDir ("{0}_{1}.md" -f $sequence, $slug)
  # Task ID no longer embeds user story id; kept minimal regardless of presence of usIdNorm
  }
}

if ($Json) {
  $obj = [ordered]@{
    mode = $mode
    repo_root = $repoRoot
    template_path = $templatePath
    plan_doc_path = $planDocPath
    docs_dir = $docsDir
    status = $status
  }
  if ($mode -eq 'task') {
    $obj.us_id = $usIdNorm
    $obj.task_title = $Task
    $obj.slug = $slug
    $obj.sequence = $sequence
    $obj.target_dir = $targetDir
    $obj.output_path = $outputPath
  }
  # Convert nulls properly
  ($obj | ConvertTo-Json -Compress).Replace('"us_id":""','"us_id":null')
} else {
  Write-Output "mode: $mode"
  Write-Output "repo_root: $repoRoot"
  Write-Output "template_path: $templatePath"
  Write-Output "plan_doc_path: $planDocPath"
  Write-Output "docs_dir: $docsDir"
  if ($mode -eq 'task') {
    Write-Output "us_id: $usIdNorm"
    Write-Output "task_title: $Task"
    Write-Output "slug: $slug"
    Write-Output "sequence: $sequence"
    Write-Output "target_dir: $targetDir"
    Write-Output "output_path: $outputPath"
  }
  Write-Output "status: $status"
}

switch ($status) {
  'OK' { exit 0 }
  'FATAL_REPO_ACCESS' { exit 2 }
  'INVALID_TASK' { exit 3 }
  'INVALID_US_ID' { exit 4 }
  default { exit 5 }
}
