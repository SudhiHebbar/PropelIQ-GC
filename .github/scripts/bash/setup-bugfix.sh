#!/usr/bin/env bash
# Setup bugfix planning environment and emit resolved parameters.
set -euo pipefail

JSON_MODE=false

usage() {
  cat <<'EOF'
Usage: setup-bugfix.sh [--json] [--help]
  --json    Output environment information as JSON
  --help    Show this help message

Emitted JSON fields:
  repo_root       Absolute repository root
  tasks_root      Base tasks directory (./.propel/context/tasks)
  docs_dir        Documentation context directory (./.propel/context/docs)
  timestamp_utc   Current UTC timestamp (ISO8601)
  agent_version   Logical agent version string
  status          OK or error status
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
TASKS_ROOT="$CONTEXT_BASE/tasks"
DOCS_DIR="$CONTEXT_BASE/docs"
mkdir -p "$TASKS_ROOT" "$DOCS_DIR"
TIMESTAMP_UTC="$(date -u '+%Y-%m-%dT%H:%M:%SZ')"
AGENT_VERSION="bugfix-plan-agent-1.0"

json_escape() { printf '%s' "$1" | sed 's/\\/\\\\/g; s/"/\\"/g'; }

if $JSON_MODE; then
  printf '{'
  printf '"repo_root":"%s",' "$(json_escape "$REPO_ROOT")"
  printf '"tasks_root":"%s",' "$(json_escape "$TASKS_ROOT")"
  printf '"docs_dir":"%s",' "$(json_escape "$DOCS_DIR")"
  printf '"timestamp_utc":"%s",' "$TIMESTAMP_UTC"
  printf '"agent_version":"%s",' "$AGENT_VERSION"
  printf '"status":"%s"' "$STATUS"
  printf '}'
  echo
else
  echo "repo_root: $REPO_ROOT"
  echo "tasks_root: $TASKS_ROOT"
  echo "docs_dir: $DOCS_DIR"
  echo "timestamp_utc: $TIMESTAMP_UTC"
  echo "agent_version: $AGENT_VERSION"
  echo "status: $STATUS"
fi

if [[ "$STATUS" != "OK" ]]; then
  exit 2
fi
