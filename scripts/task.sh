#!/usr/bin/env bash
# Stack-agnostic task runner. Claude, the hooks, CI and humans all call this one script.
# The actual commands live in .project/commands.env (copied from a stack preset).
#
#   ./scripts/task.sh check         format-check + lint + typecheck + test
#   ./scripts/task.sh <task>        any task defined as <TASK>_CMD in commands.env
#   ./scripts/task.sh list          show configured tasks
set -uo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
CONFIG="$ROOT/.project/commands.env"
cd "$ROOT" || exit 1

if [ ! -f "$CONFIG" ]; then
  echo "No .project/commands.env yet: nothing to run. Apply a stack preset (WORKFLOW.md Phase 7)." >&2
  [ "${GITHUB_ACTIONS:-}" = "true" ] && echo "::warning::No .project/commands.env yet; checks skipped."
  exit 0
fi
# Export everything so commands can use variables defined in the config (e.g. IOS_SCHEME).
set -a
# shellcheck source=/dev/null
source "$CONFIG"
set +a

CHECK_TASKS="${CHECK_TASKS:-format-check lint typecheck test}"

run_task() {
  local name="$1" var cmd
  if ! [[ "$name" =~ ^[a-z0-9-]+$ ]]; then echo "Invalid task name: $name" >&2; return 2; fi
  var="$(printf '%s' "$name" | tr 'a-z-' 'A-Z_')_CMD"
  cmd="${!var-}"
  if [ -z "$cmd" ]; then
    echo "[task] $name: not configured for this stack, skipped"
    return 0
  fi
  echo "[task] $name: $cmd"
  bash -c "$cmd"
}

case "${1:-list}" in
  check)
    rc=0
    for t in $CHECK_TASKS; do run_task "$t" || { echo "[task] $t FAILED" >&2; rc=1; }; done
    exit $rc
    ;;
  list|help|-h|--help)
    echo "Configured tasks (from .project/commands.env):"
    grep -E '^[A-Z0-9_]+_CMD=' "$CONFIG" | grep -Ev '_FILE_CMD=' | sed -E 's/^([A-Z0-9_]+)_CMD=.*$/\1/' |
      while read -r k; do
        var="${k}_CMD"
        printf '  %-16s %s\n' "$(printf '%s' "$k" | tr 'A-Z_' 'a-z-')" "${!var:-(not configured)}"
      done
    echo "  check            runs: $CHECK_TASKS"
    ;;
  *)
    run_task "$1"
    ;;
esac
