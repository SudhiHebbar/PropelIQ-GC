#!/usr/bin/env bash
# Setup repository analysis environment and emit resolved parameters
set -e

# Only flags: --json / --help. All analysis parameters handled internally by agent.
JSON_MODE=false

usage() {
  cat <<EOF
Usage: $0 [--json] [--help]
  --json    Output results in JSON format
  --help    Show this help message
EOF
}

# Parse args
while [[ $# -gt 0 ]]; do
  case "$1" in
    --json) JSON_MODE=true; shift ;;
    --help|-h) usage; exit 0 ;;
    *) echo "Unknown argument (only --json / --help allowed): $1" >&2; usage; exit 1 ;;
  esac
done

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=/dev/null
source "$SCRIPT_DIR/common.sh"

# Acquire repository root directly
REPO_ROOT="$(get_repo_root)"

# Validate repository root accessibility
if [[ ! -d "$REPO_ROOT" ]]; then
  STATUS="FATAL_REPO_ACCESS"
else
  STATUS="OK"
fi

CONTEXT_DIR="$REPO_ROOT/.propel/context"
mkdir -p "$CONTEXT_DIR"
OUTPUT_PATH="$CONTEXT_DIR/docs/codeanalysis.md"
TEMPLATE_PATH="$REPO_ROOT/.github/templates/analyze_template.md"

# Helper to JSON-escape simple strings
json_escape() { printf '%s' "$1" | sed 's/\\/\\\\/g; s/"/\\"/g'; }

if $JSON_MODE; then
  printf '{'
  printf '"repo_root":"%s",' "$(json_escape "$REPO_ROOT")"
  printf '"output_path":"%s",' "$(json_escape "$OUTPUT_PATH")"
  printf '"template_path":"%s",' "$(json_escape "$TEMPLATE_PATH")"
  printf '"status":"%s"' "$STATUS"
  printf '}\n'
else
  echo "repo_root: $REPO_ROOT"
  echo "output_path: $OUTPUT_PATH"
  echo "template_path: $TEMPLATE_PATH"
  echo "status: $STATUS"
fi

# Exit non-zero if fatal to allow caller to abort early
if [[ "$STATUS" != "OK" ]]; then
  exit 2
fi
