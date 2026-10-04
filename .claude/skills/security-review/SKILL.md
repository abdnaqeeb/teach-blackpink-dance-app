---
name: security-review
description: Security review of the current branch's diff against main using the security-reviewer subagent.
disable-model-invocation: true
---

1. Get the diff: `git diff main...HEAD` (plus uncommitted changes).
2. Use the `security-reviewer` subagent on it, along with `docs/03-architecture.md`
   (permission matrix) and `docs/07-security-checklist.md`.
3. Present findings grouped as **must fix / should fix / note**, each with file:line, the risk,
   and a concrete fix. Don't change code unless I ask.
