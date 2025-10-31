done
#!/usr/bin/env bash
# Setup implementation planning environment and (optionally) resolve per-task output paths.
set -euo pipefail

JSON_MODE=false
TASK_TITLE=""
US_ID=""

usage() {
  cat <<EOF
Usage: $0 [--json] [--help] [--task "Task Title"] [--us-id US_123]
  --json          Output results in JSON format
  --task TITLE    Resolve output path for a specific task title (switches to task mode)
  --us-id ID      Explicit user story id (pattern: US_### or US_####); optional if derivable
  --help          Show this help message
EOF
}

# Arg parsing
while [[ $# -gt 0 ]]; do
  case "$1" in
    --json) JSON_MODE=true; shift ;;
    --task) TASK_TITLE="${2:-}"; shift 2 ;;
    --us-id) US_ID="${2:-}"; shift 2 ;;
    --help|-h) usage; exit 0 ;;
    *) echo "Unknown argument: $1" >&2; usage; exit 1 ;;
  esac
done

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=/dev/null
source "$SCRIPT_DIR/common.sh"

REPO_ROOT="$(get_repo_root)"
STATUS="OK"
if [[ ! -d "$REPO_ROOT" ]]; then
  STATUS="FATAL_REPO_ACCESS"
fi

CONTEXT_BASE="$REPO_ROOT/.propel/context"
mkdir -p "$CONTEXT_BASE"
TASKS_ROOT="$CONTEXT_BASE/tasks"
# Backward compatibility: migrate old 'Tasks' directory if present
if [[ -d "$CONTEXT_BASE/Tasks" && ! -d "$TASKS_ROOT" ]]; then
  mv "$CONTEXT_BASE/Tasks" "$TASKS_ROOT"
fi
mkdir -p "$TASKS_ROOT"

PLAN_DOC_PATH="$CONTEXT_BASE/implementation_plan.md" # Central plan document (may be written later)
TEMPLATE_PATH="$REPO_ROOT/.github/templates/task_template.md" # Task template (optional existence)
DOCS_DIR="$CONTEXT_BASE/docs"
mkdir -p "$DOCS_DIR" # Expected location for spec.md, design.md, codeanalysis.md, designsystem.md

# Functions
json_escape() { printf '%s' "$1" | sed 's/\\/\\\\/g; s/"/\\"/g'; }
to_slug() {
  local s="${1,,}" # lowercase
  s="${s//[^a-z0-9 _-]/}"         # remove disallowed chars
  s="${s// /_}"                   # spaces -> underscore
  s="${s//__/_}"                  # collapse doubles (once)
  printf '%s' "$s" | sed 's/_\+/_/g; s/^_//; s/_$//' # final trim
}

derive_us_id() {
  local input="$1"
  if [[ $input =~ ([Uu][Ss][_-]?[0-9]{3,4}) ]]; then
    local raw="${BASH_REMATCH[1]}"
    raw=${raw//-/ _}
    raw=${raw//us/US}
    raw=${raw//US_/US_}
    if [[ $raw =~ ^US_[0-9]{3,4}$ ]]; then
      printf '%s' "$raw"
    else
      # normalize pattern like US123 -> US_123
      if [[ $raw =~ ^US[0-9]{3,4}$ ]]; then
        printf 'US_%s' "${raw:2}"
      fi
    fi
  fi
}

next_sequence() {
  local dir="$1"
  local max=0
  shopt -s nullglob
  for f in "$dir"/[0-9][0-9][0-9]_*.md; do
    local base="$(basename "$f")"
    local seq="${base:0:3}"
    if [[ $seq =~ ^[0-9]{3}$ ]]; then
      (( 10#$seq > max )) && max=$((10#$seq))
    fi
  done
  printf '%03d' $((max+1))
}

MODE="init"
US_ID_NORMALIZED=""
TASK_SLUG=""
TASK_SEQ=""
TASK_OUTPUT_PATH=""
TARGET_DIR=""

if [[ -n "$TASK_TITLE" ]]; then
  MODE="task"
  if [[ -z "$TASK_TITLE" ]]; then
    STATUS="INVALID_TASK"
  fi
  # Derive US ID if not provided
  if [[ -z "$US_ID" ]]; then
    US_ID="$(derive_us_id "$TASK_TITLE")" || true
  fi
  if [[ -n "$US_ID" && ! $US_ID =~ ^US_[0-9]{3,4}$ ]]; then
    STATUS="INVALID_US_ID"
  fi
  # Normalize uppercase canonical id; lowercase folder naming
  if [[ -n "$US_ID" ]]; then
    US_ID_NORMALIZED="$US_ID"
    local_lower_folder="${US_ID_NORMALIZED,,}" # e.g. us_123
    TARGET_DIR="$TASKS_ROOT/$local_lower_folder"
  else
    TARGET_DIR="$TASKS_ROOT/general" # fallback for general tasks
  fi
  mkdir -p "$TARGET_DIR"
  TASK_SLUG="$(to_slug "$TASK_TITLE")"
  if [[ -z "$TASK_SLUG" ]]; then
    STATUS="INVALID_TASK"
  fi
  if [[ "$STATUS" == "OK" ]]; then
    TASK_SEQ="$(next_sequence "$TARGET_DIR")"
  TASK_OUTPUT_PATH="$TARGET_DIR/${TASK_SEQ}_${TASK_SLUG}.md"
  fi
fi

if $JSON_MODE; then
  printf '{'
  printf '"mode":"%s",' "$MODE"
  printf '"repo_root":"%s",' "$(json_escape "$REPO_ROOT")"
  printf '"template_path":"%s",' "$(json_escape "$TEMPLATE_PATH")"
  printf '"plan_doc_path":"%s",' "$(json_escape "$PLAN_DOC_PATH")"
  printf '"docs_dir":"%s",' "$(json_escape "$DOCS_DIR")"
  if [[ "$MODE" == "task" ]]; then
    printf '"us_id":%s,' $([[ -n "$US_ID_NORMALIZED" ]] && printf '"%s"' "$US_ID_NORMALIZED" || printf 'null')
    printf '"task_title":"%s",' "$(json_escape "$TASK_TITLE")"
    printf '"slug":"%s",' "$(json_escape "$TASK_SLUG")"
    printf '"sequence":"%s",' "$TASK_SEQ"
    printf '"target_dir":"%s",' "$(json_escape "$TARGET_DIR")"
    printf '"output_path":"%s",' "$(json_escape "$TASK_OUTPUT_PATH")"
  fi
  printf '"status":"%s"' "$STATUS"
  printf '}\n'
else
  echo "mode: $MODE"
  echo "repo_root: $REPO_ROOT"
  echo "template_path: $TEMPLATE_PATH"
  echo "plan_doc_path: $PLAN_DOC_PATH"
  echo "docs_dir: $DOCS_DIR"
  if [[ "$MODE" == "task" ]]; then
    echo "us_id: ${US_ID_NORMALIZED:-}"; echo "task_title: $TASK_TITLE"; echo "slug: $TASK_SLUG"
  echo "sequence: $TASK_SEQ"; echo "target_dir: $TARGET_DIR"; echo "output_path: $TASK_OUTPUT_PATH"
  fi
  echo "status: $STATUS"
fi

case "$STATUS" in
  OK) exit 0 ;;
  FATAL_REPO_ACCESS) exit 2 ;;
  INVALID_TASK) exit 3 ;;
  INVALID_US_ID) exit 4 ;;
  *) exit 5 ;;
esac
