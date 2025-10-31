#!/usr/bin/env bash
# Setup implementation execution environment for task processing.
set -euo pipefail

JSON_MODE=false

usage() {
  cat <<EOF
Usage: $0 [--json] [--help]
  --json    Output environment information as JSON
  --help    Show this help message
EOF
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --json) JSON_MODE=true; shift ;;
    --help|-h) usage; exit 0 ;;
    *) echo "Unknown argument: $1" >&2; usage; exit 1 ;;
  esac
done

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=/dev/null
if [[ -f "$SCRIPT_DIR/common.sh" ]]; then
  source "$SCRIPT_DIR/common.sh"
fi

# Minimal get_repo_root fallback if common.sh absent
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
TASKS_ROOT="$CONTEXT_BASE/tasks"
mkdir -p "$DOCS_DIR" "$TASKS_ROOT"

json_escape() { printf '%s' "$1" | sed 's/\\/\\\\/g; s/"/\\"/g'; }

if $JSON_MODE; then
  printf '{'
  printf '"repo_root":"%s",' "$(json_escape "$REPO_ROOT")"
  printf '"docs_dir":"%s",' "$(json_escape "$DOCS_DIR")"
  printf '"tasks_root":"%s",' "$(json_escape "$TASKS_ROOT")"
  printf '"status":"%s"' "$STATUS"
  printf '}'
  echo
else
  echo "repo_root: $REPO_ROOT"
  echo "docs_dir: $DOCS_DIR"
  echo "tasks_root: $TASKS_ROOT"
  echo "status: $STATUS"
fi

if [[ "$STATUS" != "OK" ]]; then
  exit 2
fi
