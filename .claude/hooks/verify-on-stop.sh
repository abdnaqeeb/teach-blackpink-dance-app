#!/usr/bin/env bash
# Stop hook (any stack): when Claude tries to finish, run the fast checks (STOP_CHECKS in
# .project/commands.env, default "typecheck lint test"). On failure, block the stop (exit 2) and
# send the errors back so Claude keeps fixing. Gives up after MAX_ATTEMPTS to avoid loops.
set -uo pipefail

MAX_ATTEMPTS=3
input="$(cat)"
cd "${CLAUDE_PROJECT_DIR:-.}" || exit 0
CONFIG=".project/commands.env"
state_file=".claude/.stop-attempts"

[ -f "$CONFIG" ] || exit 0          # no stack chosen yet: nothing to check
# shellcheck source=/dev/null
source "$CONFIG"

if ! printf '%s' "$input" | grep -Eq '"stop_hook_active"[[:space:]]*:[[:space:]]*true'; then
  rm -f "$state_file"               # fresh stop (not one we forced): reset the attempt counter
fi

# Nothing changed since the last commit → let Claude stop.
if git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  if [ -z "$(git status --porcelain -- . ':!.claude/.stop-attempts' 2>/dev/null)" ]; then
    rm -f "$state_file"; exit 0
  fi
fi

failures=""
for t in ${STOP_CHECKS:-typecheck lint test}; do
  if ! out="$(CI=true ./scripts/task.sh "$t" 2>&1)"; then
    failures+=$'\n'"=== task $t failed ==="$'\n'"$(printf '%s' "$out" | tail -n 40)"$'\n'
  fi
done

if [ -z "$failures" ]; then
  rm -f "$state_file"; exit 0
fi

attempts=$(( $(cat "$state_file" 2>/dev/null || echo 0) + 1 ))
echo "$attempts" > "$state_file"

if [ "$attempts" -gt "$MAX_ATTEMPTS" ]; then
  rm -f "$state_file"
  printf '{"systemMessage":"Checks still failing after %s automatic fix attempts. Stopping so a human can look."}\n' "$MAX_ATTEMPTS"
  exit 0
fi

printf 'Checks are failing (attempt %s of %s). Fix the root cause; do not skip or weaken tests.%s\n' \
  "$attempts" "$MAX_ATTEMPTS" "$failures" >&2
exit 2
