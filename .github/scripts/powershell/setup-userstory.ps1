Param(
  [Parameter(Mandatory=$false)][switch]$Json
)

if (-not $Json) {
  Write-Error "Usage: ./setup-userstory.ps1 -Json"
  exit 1
}

$repoRoot = (Get-Location).Path
$contextDir = Join-Path $repoRoot '.propel/context'
$docsDir = Join-Path $contextDir 'docs'
$storiesRoot = Join-Path $contextDir 'tasks'
$templatePath = Join-Path $repoRoot '.github/templates/userstory-template.md'
$specPath = Join-Path $docsDir 'spec.md'
$timestampUtc = (Get-Date).ToUniversalTime().ToString('yyyy-MM-ddTHH:mm:ssZ')
$agentVersion = 'userstory-setup-v1'

New-Item -ItemType Directory -Path $docsDir -Force | Out-Null
New-Item -ItemType Directory -Path $storiesRoot -Force | Out-Null

$status = 'OK'
if (-not (Test-Path $specPath)) { $status = 'SPEC_MISSING' }
if (-not (Test-Path $templatePath)) { $status = 'TEMPLATE_MISSING' }

$payload = [ordered]@{
  repo_root     = $repoRoot
  docs_dir      = $docsDir
  spec_path     = $specPath
  stories_root  = $storiesRoot
  template_path = $templatePath
  timestamp_utc = $timestampUtc
  agent_version = $agentVersion
  status        = $status
}

$payload | ConvertTo-Json -Depth 5
