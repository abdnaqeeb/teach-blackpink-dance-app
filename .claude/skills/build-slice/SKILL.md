---
name: build-slice
description: Implement an approved slice plan test-first, verify it, run reviewers and open a PR.
argument-hint: "<story-id e.g. S-012>"
disable-model-invocation: true
---

Implement story **$ARGUMENTS** following the plan approved in this conversation.

1. `git switch -c feat/$ARGUMENTS-<short-name>` from an up-to-date main.
2. Mark the story 🟦 in `docs/06-backlog.md`.
3. Write the tests for each acceptance criterion first and confirm they fail for the right reason.
4. Implement the smallest change that makes them pass. Follow every rule in `CLAUDE.md`.
   If you need to deviate from the plan (new dependency, schema change, new pattern), stop and ask.
5. Run the `/verify` steps and fix all failures. Never skip or weaken tests.
6. Use the `architecture-reviewer` subagent on the diff. If the story is 🔐 or touches
   `src/server/`, also use the `security-reviewer` subagent. Fix every "must fix" finding.
7. Commit in logical steps with messages like `feat(S-012): owner can archive project`.
8. Mark the story 🟩 in the backlog (pending merge), then push and open a PR using
   `.github/pull_request_template.md`. Fill in the test evidence and reviewer findings.
9. Report back: PR link, what to try on the preview, and anything the human must review line by line.
