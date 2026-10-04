---
name: plan-slice
description: Plan one backlog story as a thin vertical slice before any code is written. Use in plan mode.
argument-hint: "<story-id e.g. S-012>"
disable-model-invocation: true
---

Plan story **$ARGUMENTS**. Do not edit any files.

1. Read `CLAUDE.md` (including Stack specifics), the story in `docs/06-backlog.md`, and the parts of
   `docs/03-architecture.md`, `docs/04-ux-flow.md`, `docs/05-design-system.md` and `docs/adr/` that it touches.
2. Look at the existing code in the affected areas and reuse its patterns.
3. Output a plan with exactly these sections:
   - **Goal**: one sentence.
   - **Acceptance criteria → tests**: each criterion mapped to the test(s) that prove it
     (unit / integration / e2e), plus negative authorization tests for protected actions.
   - **Files**: create/modify list with a one-line reason each. For an app + backend, include both sides.
   - **Data**: schema or migration changes (or "none").
   - **Dependencies**: new packages/SDKs (name, purpose, registry link, last release,
     downloads/usage, license, what data it collects) or "none". Prefer what's already installed.
   - **UI**: screens/states touched, the `design/screens/` images they implement, and the components
     and tokens used (only from docs/05). If a needed screen or state has no approved design, say so.
   - **🔐 Human gates**: anything touching auth, permissions, payments, personal data, schema,
     CI, config, or mobile permissions/manifests/entitlements. Say exactly what the human must review.
   - **Risks / open questions**.
   - **Out of scope**: things you will deliberately not do.
4. Keep it to the smallest change that meets the criteria. If the story is too big for one PR
   (~400 lines), propose a split instead.
