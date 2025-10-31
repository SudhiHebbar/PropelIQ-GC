#!/usr/bin/env bash
set -euo pipefail

# Outputs environment metadata for user story prompt workflows in JSON
# Usage: ./setup-userstory.sh --json

if [[ "${1:-}" != "--json" ]]; then
  echo "Usage: $0 --json" >&2
  exit 1
fi

REPO_ROOT=$(pwd)
CONTEXT_DIR="${REPO_ROOT}/.propel/context"
DOCS_DIR="${CONTEXT_DIR}/docs"
STORIES_ROOT="${CONTEXT_DIR}/tasks"
TEMPLATE_PATH="${REPO_ROOT}/.github/templates/userstory-template.md"
SPEC_PATH="${DOCS_DIR}/spec.md"
TIMESTAMP_UTC=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
AGENT_VERSION="userstory-setup-v1"

mkdir -p "${DOCS_DIR}" "${STORIES_ROOT}" || true

STATUS="OK"
if [[ ! -f "${SPEC_PATH}" ]]; then
  STATUS="SPEC_MISSING"
fi
if [[ ! -f "${TEMPLATE_PATH}" ]]; then
  STATUS="TEMPLATE_MISSING"
fi

cat <<JSON
{
  "repo_root": "${REPO_ROOT}",
  "docs_dir": "${DOCS_DIR}",
  "spec_path": "${SPEC_PATH}",
  "stories_root": "${STORIES_ROOT}",
  "template_path": "${TEMPLATE_PATH}",
  "timestamp_utc": "${TIMESTAMP_UTC}",
  "agent_version": "${AGENT_VERSION}",
  "status": "${STATUS}"
}
JSON
