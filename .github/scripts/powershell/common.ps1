#!/usr/bin/env pwsh
# Minimal common utilities: only resolve repository root.

function Get-RepoRoot {
    try {
        $result = git rev-parse --show-toplevel 2>$null
        if ($LASTEXITCODE -eq 0 -and $result) { return $result }
    } catch { }
    return (Resolve-Path (Join-Path $PSScriptRoot "../../..")).Path
}

function Emit-RootEnv {
    $root = Get-RepoRoot
    [PSCustomObject]@{ REPO_ROOT = $root }
}

