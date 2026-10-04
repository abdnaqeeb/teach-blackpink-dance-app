# 06 · Backlog

Status legend: ⬜ todo · 🟦 in progress · 🟩 done · ⛔ blocked
🔐 = touches auth / permissions / payments / personal data → human reviews plan AND every line.
Size: S (< 0.5 day) · M (≤ 1 day) · L (split it)

## Epic E0: Foundation
### S-000 Walking skeleton ⬜ · M · 🔐
As the team, we have a deployed app with every guardrail live, so that every feature is checked
from the start.
**Acceptance criteria**
- Given a PR, when CI runs, then format, lint, typecheck, unit, e2e, secrets and audit jobs run and must pass.
- Given a visitor, when they open the preview (web URL or internal mobile build), then the first screen loads without errors.
- Given a signed-out user, when they open a protected screen, then they are sent to sign-in.
- Given a thrown test error, when it happens on server or client, then it appears in error monitoring.
- Given the permission matrix in docs/03, when tests run, then every role × action pair is asserted.

---

## Epic E1: {{User outcome}}
### S-001 {{Story title}} ⬜ · S
As a {{role}}, I can {{action}}, so that {{value}}.
**Acceptance criteria**
- Given … when … then …
- Given a user from another org, when they try …, then they get 404 and nothing changes.
**Depends on:** S-000
**Design:** `design/screens/{{screen}}--*.png` · docs/04 screen "{{name}}"

<!-- ===================== MVP CUT LINE ===================== -->

## Later
-
