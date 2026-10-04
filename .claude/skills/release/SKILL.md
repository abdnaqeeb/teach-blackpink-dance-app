---
name: release
description: Prepare a production release using docs/08-release-checklist.md and draft release notes.
argument-hint: "<version>"
disable-model-invocation: true
---

Prepare release **$ARGUMENTS**. Do not deploy, submit to app stores, push OTA updates, or run migrations.

1. List merged PRs and stories since the last release tag (`git log`, `gh pr list --state merged`).
2. Check `docs/06-backlog.md` statuses, CI status on main (`gh run list`), and open ❌ items in
   `docs/07-security-checklist.md`.
3. List pending migrations and new config values (diff the config module and `.env.example`).
4. For mobile: check version/build numbers, API compatibility with the minimum supported app
   version, and changed permissions/entitlements/privacy declarations.
5. Fill in a copy of `docs/08-release-checklist.md` as `docs/releases/$ARGUMENTS.md`, marking
   what you verified and what needs a human.
6. Draft user-facing release notes (plain language, grouped by New / Improved / Fixed), and
   for mobile a short store "What's new" text.
