#!/usr/bin/env bash
# PostToolUse hook (any stack): after Claude edits a file, format it and lint it using the
# per-file commands in .project/commands.env. Lint errors go back to Claude (exit 2).
# Pure bash: uses jq if installed, otherwise a simple fallback parser.
set -uo pipefail

input="$(cat)"
cd "${CLAUDE_PROJECT_DIR:-.}" || exit 0
CONFIG=".project/commands.env"
[ -f "$CONFIG" ] || exit 0          # no stack chosen yet (Phases 1-6): do nothing
set -a
# shellcheck source=/dev/null
source "$CONFIG"
set +a

if command -v jq >/dev/null 2>&1; then
  file="$(printf '%s' "$input" | jq -r '.tool_input.file_path // .tool_input.path // empty' 2>/dev/null)"
else
  file="$(printf '%s' "$input" | grep -o '"file_path"[[:space:]]*:[[:space:]]*"[^"]*"' | head -n1 |
    sed -E 's/^"file_path"[[:space:]]*:[[:space:]]*"(.*)"$/\1/; s/\\\\/\\/g')"
fi
[ -n "${file:-}" ] && [ -f "$file" ] || exit 0

case "$file" in
  */node_modules/*|*/.next/*|*/dist/*|*/build/*|*/.dart_tool/*|*/Pods/*|*/.gradle/*|*/bin/*|*/obj/*|*/.venv/*) exit 0 ;;
esac

ext="${file##*.}"
has_ext() { case " $1 " in *" $ext "*) return 0 ;; *) return 1 ;; esac; }

# 1. Format (never blocks)
if [ -n "${FORMAT_FILE_CMD:-}" ] && has_ext "${FORMAT_EXTENSIONS:-}"; then
  bash -c "$FORMAT_FILE_CMD \"\$1\"" _ "$file" >/dev/null 2>&1 || true
fi

# 2. Lint (blocks on errors, so Claude fixes them right away)
if [ -n "${LINT_FILE_CMD:-}" ] && has_ext "${LINT_EXTENSIONS:-}"; then
  out="$(bash -c "$LINT_FILE_CMD \"\$1\"" _ "$file" 2>&1)"
  rc=$?
  if [ $rc -ne 0 ] && [ $rc -ne 127 ]; then   # 127 = tool not installed yet: skip quietly
    printf 'Lint found problems in %s. Fix them before continuing:\n%s\n' "$file" "$(printf '%s' "$out" | tail -n 40)" >&2
    exit 2
  fi
fi
exit 0
