#!/usr/bin/env bash
# Minimal common utilities: only resolve repository root.

get_repo_root() {
    if git rev-parse --show-toplevel >/dev/null 2>&1; then
        git rev-parse --show-toplevel
    else
        local script_dir
        script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
        (cd "$script_dir/../../.." && pwd)
    fi
}

# Optional helper if a script wants to eval environment style
emit_root_env() {
    local root
    root="$(get_repo_root)"
    cat <<EOF
REPO_ROOT='$root'
EOF
}

