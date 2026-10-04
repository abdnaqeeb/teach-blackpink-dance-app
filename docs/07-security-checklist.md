# 07 · Security & Privacy Checklist

Reviewed by: {{name}} · Date: {{date}} · Release: {{version}}
Mark each: ✅ ok · ⚠️ accepted risk (note why) · ❌ must fix
Stack-specific names (config module, validation library, escape hatches) are in CLAUDE.md → Stack specifics.

## Authentication
- [ ] Managed provider handles sign-up, sign-in, reset, sessions/tokens (no custom crypto)
- [ ] MFA available (required for admins)
- [ ] Session/token lifetime and refresh are set; sign-out invalidates server-side sessions/refresh tokens
- [ ] Email verification is required before sensitive actions

## Authorization
- [ ] Every non-public entry point authenticates and calls `can()` (check with a grep/search)
- [ ] All queries are scoped by owner/tenant; no client-supplied owner IDs, roles or prices are trusted
- [ ] Permission-matrix test covers every role × action; negative tests exist
- [ ] Object IDs are non-guessable (UUID) or access is checked anyway
- [ ] Admin actions are audit-logged (who, what, when, before/after)
- [ ] Database row-level security enabled if clients talk to the DB directly (e.g. Supabase, Firebase rules)

## Input, output, data
- [ ] Validation at all boundaries (forms, endpoints, webhooks, config, deep links)
- [ ] ORM / parameterized queries only; no string-built SQL
- [ ] User content is escaped on output; no raw HTML injection without sanitizing
- [ ] File uploads: type and size limits, private storage + signed URLs, served from a separate domain
- [ ] Errors shown to users contain no stack traces or internal details

## Secrets & config
- [ ] Secrets only in secret stores; `.env*`, keys and keystores gitignored; gitleaks clean
- [ ] Separate credentials per environment; least-privilege API keys
- [ ] No secrets in front-end bundles or mobile binaries (only intentionally public values)
- [ ] Rotation procedure documented

## Web & API hardening
- [ ] Security headers: CSP, HSTS, X-Content-Type-Options, Referrer-Policy, frame-ancestors
- [ ] CSRF protection for cookie-based sessions
- [ ] Rate limits on auth, writes and expensive endpoints
- [ ] Webhooks verify signatures and are idempotent
- [ ] Outbound calls have timeouts; failures degrade gracefully
- [ ] CORS restricted to known origins

## 📱 Mobile app (based on OWASP MASVS)
- [ ] Tokens only in Keychain / Android Keystore-backed storage; nothing sensitive in plain prefs/AsyncStorage/files
- [ ] TLS only; no cleartext exceptions (ATS / network security config); consider certificate pinning for high-risk apps
- [ ] Deep links / universal links validate all parameters and never perform actions without confirmation
- [ ] Only the OS permissions actually needed; each has a usage description
- [ ] No sensitive data in logs, crash reports, clipboard, or app-switcher screenshots
- [ ] Release builds: debugging off, code minified/obfuscated where supported, exported Android components reviewed
- [ ] Signing keys stored only in the build service; upload key / App Store Connect API key access limited
- [ ] App Store privacy manifest / nutrition labels and Play data safety form match reality
- [ ] In-app account deletion available

## Dependencies & supply chain
- [ ] `./scripts/task.sh audit` has no high/critical issues; Dependabot on
- [ ] Every dependency/SDK was approved (exists, maintained, license OK, data it collects is known)
- [ ] CodeQL has no open high alerts

## Privacy (GDPR)
- [ ] Data inventory matches docs/03 (what, why, lawful basis, retention)
- [ ] Users can export and delete their data; deletion cascades to processors
- [ ] DPAs signed with every processor (including analytics/crash SDKs); data residency meets requirements
- [ ] Privacy notice and consent for non-essential cookies/tracking (📱 ATT on iOS if tracking)
- [ ] Logs and error reports contain no personal data beyond what's needed

## Operations
- [ ] Backups automated and a restore tested
- [ ] Alerting reaches a human; incident steps written down
