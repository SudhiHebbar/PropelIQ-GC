Param(
    [Parameter(Mandatory=$false)][switch]$Json
)

if (-not $Json) {
    Write-Error "Usage: ./setup-design.ps1 -Json"
    exit 1
}

$repoRoot = (Get-Location).Path
$docsDir = Join-Path $repoRoot '.propel/context/docs'
$templatesDir = Join-Path $repoRoot '.github/templates'
$timestampUtc = (Get-Date).ToUniversalTime().ToString('yyyy-MM-ddTHH:mm:ssZ')
$agentVersion = 'design-setup-v1'

New-Item -ItemType Directory -Path $docsDir -Force | Out-Null

$payload = [ordered]@{
    repo_root     = $repoRoot
    docs_dir      = $docsDir
    templates_dir = $templatesDir
    timestamp_utc = $timestampUtc
    agent_version = $agentVersion
    status        = 'OK'
}

$payload | ConvertTo-Json -Depth 5
