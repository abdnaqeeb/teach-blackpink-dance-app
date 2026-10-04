# {{PROJECT_NAME}}

{{One sentence: what the app does and for whom.}}
Type: {{web app | API | mobile app | mobile app + API}} · Core action: {{the one thing a user must be able to do easily}}
Process: follow `WORKFLOW.md`. Current phase: **{{N}}**.

## Commands (same for every stack)
All project commands go through `./scripts/task.sh`; the real commands are in `.project/commands.env`.
- `./scripts/task.sh check`: format-check + lint + typecheck + unit tests. Run before saying you're done.
- `./scripts/task.sh test-e2e`: end-to-end tests. Run for any change to a user flow.
- `./scripts/task.sh build` · `dev` · `format` · `audit` · `db-migrate` · `db-seed` (local/preview only)
- `./scripts/task.sh list`: show what each task runs in this project.
Don't call the underlying tools directly when a task exists.

## Architecture (layers, whatever the stack)
- **Entry layer** (routes, controllers, screens): thin. Validates input, checks auth and permissions,
  calls a feature. No business logic.
- **Features** (one folder per feature): logic, data access, schemas, tests together.
- **Trusted core** (server or backend only): auth helpers, authorization (`can(user, action, resource)`),
  DB access, secrets. Client and mobile code never import it and never hold secrets.
- **Config module**: the only place that reads environment or build config, validated at startup.
- **UI kit**: design tokens (from `design/tokens.json`) + the components listed in docs/05. Nothing else.
  Approved screens are in `design/screens/`; match them. The design source of truth is Claude Design
  (links in `design/README.md`): if a design looks wrong or is missing a state, ask; don't invent one.
Exact folders, libraries and names: see **Stack specifics** below. Decisions: docs/03 and docs/adr/.

## Rules: always
- Do the smallest change that meets the story's acceptance criteria. No speculative features.
- Write the tests for acceptance criteria first; name them with the story ID (`S-012: ...`).
- Every entry point that changes or reads protected data: validate input → authenticate →
  authorize with the loaded resource → then act. Deny by default.
- Scope every query by owner/tenant. Never trust IDs, roles, prices or flags sent by a client.
- Treat browser and mobile apps as untrusted: anything shipped to a device is public.
  Authorization and secrets live on the server/backend.
- Use only design tokens and components listed in docs/05-design-system.md.
- Every screen handles empty, loading, error, no-permission (and offline, for mobile) states.
- Read config only through the config module. Add new values there and to `.env.example`.
- Before using an unfamiliar library API, check its current docs. Don't guess signatures.
- Run `./scripts/task.sh check` (and `test-e2e` for flow changes) and fix failures before finishing.

## Rules: never
- Never write your own auth, password hashing, session, token or crypto code. Use the provider.
- Never read, print or commit `.env*` files, keys, keystores, signing certificates or secrets.
- Never put secrets in client or mobile code, including "hidden" build config. It gets extracted.
- Never skip, weaken or delete a test to make it pass. If a test is wrong, say why in the PR.
- Never silence the type checker or linter (see "escape hatches" in Stack specifics) without a comment explaining why.
- Never add a dependency without listing it in the plan (name, purpose, registry link,
  last release date, downloads/usage, license). Prefer what's already installed.
- Never run migrations or scripts against production, publish to app stores, or push OTA
  updates to production.
- Never push to `main` or force-push.

## Stop and ask a human (🔐 gates)
Pause and ask before:
- changing auth, sessions, roles, authorization code, or the permission matrix
- changing the DB schema or writing a migration
- anything involving payments, webhooks, personal data, or data deletion
- adding a dependency, SDK or external service
- changing CI, `.claude/`, `.project/`, security headers/CSP, or mobile permissions,
  entitlements, manifests, deep links or signing config
- any change that contradicts an ADR or this file

## Definition of done (per story)
- [ ] All acceptance criteria have passing tests (unit/integration + e2e for the flow)
- [ ] `./scripts/task.sh check` and `build` pass; e2e passes for affected flows
- [ ] Negative authorization tests exist for any new protected action
- [ ] UI uses tokens/listed components; all states done; accessible (labels, focus/screen reader, contrast, text scaling)
- [ ] No new warnings, TODOs without a story ID, or debug logging
- [ ] docs/06-backlog.md status updated; ADR written if a decision changed
- [ ] PR opened with the template filled in

## Stack specifics
<!-- Paste STACK.md from your chosen preset in stack-presets/ here (Phase 7).
     For several parts (e.g. mobile app + API), paste each under its own heading. -->
{{not chosen yet}}

## Lessons learned
<!-- Add a line each time Claude repeats a mistake. Promote to a lint rule when possible. -->
