#!/usr/bin/env bash
set -euo pipefail

# Outputs environment metadata for design prompt workflows in JSON
# Usage: ./setup-design.sh --json

if [[ "${1:-}" != "--json" ]]; then
  echo "Usage: $0 --json" >&2
  exit 1
fi

REPO_ROOT=$(pwd)
DOCS_DIR="${REPO_ROOT}/.propel/context/docs"
TEMPLATES_DIR="${REPO_ROOT}/.github/templates"
TIMESTAMP_UTC=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
AGENT_VERSION="design-setup-v1"

mkdir -p "${DOCS_DIR}" || true

cat <<JSON
{
  "repo_root": "${REPO_ROOT}",
  "docs_dir": "${DOCS_DIR}",
  "templates_dir": "${TEMPLATES_DIR}",
  "timestamp_utc": "${TIMESTAMP_UTC}",
  "agent_version": "${AGENT_VERSION}",
  "status": "OK"
}
JSON
