#!/usr/bin/env bash
# Setup specification generation environment and emit resolved parameters.
# Only supports --json / --help to remain deterministic for the agent.
set -euo pipefail

JSON_MODE=false

usage() {
  cat <<'EOF'
Usage: setup-spec.sh [--json] [--help]
  --json    Output environment information as JSON
  --help    Show this help message

Emits fields (JSON when --json provided):
  repo_root        Absolute repository root
  docs_dir         Directory for generated documentation artifacts
  templates_dir    Directory containing requirement_base and related templates
  timestamp_utc    Current UTC timestamp (ISO8601)
  agent_version    Logical agent version string
  status           OK or error status (e.g., FATAL_REPO_ACCESS)
EOF
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --json) JSON_MODE=true; shift ;;
    --help|-h) usage; exit 0 ;;
    *) echo "Unknown argument (only --json / --help allowed): $1" >&2; usage; exit 1 ;;
  esac
done

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=/dev/null
if [[ -f "$SCRIPT_DIR/common.sh" ]]; then
  source "$SCRIPT_DIR/common.sh"
fi

if ! command -v get_repo_root >/dev/null 2>&1; then
  get_repo_root() {
    local dir="$SCRIPT_DIR"
    while [[ "$dir" != "/" ]]; do
      if [[ -d "$dir/.git" || -f "$dir/.propel-root" ]]; then
        printf '%s' "$dir"; return 0
      fi
      dir="$(dirname "$dir")"
    done
    printf '%s' "$SCRIPT_DIR"
  }
fi

REPO_ROOT="$(get_repo_root)"
STATUS="OK"
if [[ ! -d "$REPO_ROOT" ]]; then
  STATUS="FATAL_REPO_ACCESS"
fi

CONTEXT_BASE="$REPO_ROOT/.propel/context"
DOCS_DIR="$CONTEXT_BASE/docs"
TEMPLATES_DIR="$REPO_ROOT/.github/templates"
mkdir -p "$DOCS_DIR"

timestamp_utc() { date -u '+%Y-%m-%dT%H:%M:%SZ'; }
json_escape() { printf '%s' "$1" | sed 's/\\/\\\\/g; s/"/\\"/g'; }

if $JSON_MODE; then
  printf '{'
  printf '"repo_root":"%s",' "$(json_escape "$REPO_ROOT")"
  printf '"docs_dir":"%s",' "$(json_escape "$DOCS_DIR")"
  printf '"templates_dir":"%s",' "$(json_escape "$TEMPLATES_DIR")"
  printf '"timestamp_utc":"%s",' "$(timestamp_utc)"
  printf '"agent_version":"%s",' "spec-agent-1.0"
  printf '"status":"%s"' "$STATUS"
  printf '}'
  echo
else
  echo "repo_root: $REPO_ROOT"
  echo "docs_dir: $DOCS_DIR"
  echo "templates_dir: $TEMPLATES_DIR"
  echo "timestamp_utc: $(timestamp_utc)"
  echo "agent_version: spec-agent-1.0"
  echo "status: $STATUS"
fi

if [[ "$STATUS" != "OK" ]]; then
  exit 2
fi
