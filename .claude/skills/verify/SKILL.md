---
name: verify
description: Run the full local quality gate (format, lint, types, unit, build, e2e) through scripts/task.sh and fix failures.
---

Run these in order. On failure, fix the root cause and re-run from that step.
(`./scripts/task.sh list` shows what each task runs in this project's stack.)

1. `./scripts/task.sh format-check` (fix with `./scripts/task.sh format`)
2. `./scripts/task.sh lint`
3. `./scripts/task.sh typecheck`
4. `./scripts/task.sh test`
5. `./scripts/task.sh build`
6. `./scripts/task.sh test-e2e` if any route, screen, endpoint or user flow changed. If e2e needs
   a simulator/emulator or browser that isn't available here, say so and list the flows to check.

Rules:
- Never skip, focus, or delete tests, or loosen assertions, to get green.
- Never silence the compiler or linter (the escape hatches listed in CLAUDE.md → Stack specifics)
  without a written reason.
- If a failure is outside this change's scope, report it instead of fixing it silently.

Finish with a short table: step · result · notes.
