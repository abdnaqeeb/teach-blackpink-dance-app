# 08 · Release Checklist

Release: {{version}} · Date: {{date}} · Approver: {{name}}

## Before
- [ ] All stories in this release are 🟩 in docs/06-backlog.md and merged with green CI
- [ ] Security checklist (docs/07) has no ❌ items
- [ ] Migrations are backward-compatible and have run successfully on preview/staging
- [ ] New config values/secrets are set in production
- [ ] Feature flags are configured for risky changes
- [ ] Success criteria spot-check on preview (time the core action)
- [ ] Release notes drafted

## 📱 Mobile only
- [ ] API stays compatible with every app version still supported (check minimum supported version)
- [ ] Version and build number bumped (build number by CI)
- [ ] Tested on real devices: one current iOS, one older mid-range Android, small screen, large font, dark mode, slow network
- [ ] Beta tested via TestFlight / Play closed testing with no new crashes
- [ ] Store listing, screenshots, "What's new", privacy labels / data safety and age rating updated
- [ ] Staged rollout plan: {{1% → 10% → 50% → 100%}}, with the crash-free threshold to halt at: {{99.5%}}

## Deploy
- [ ] Web/API: merge / promote to production · 📱 submit for review, then start staged rollout
- [ ] Migrations applied (human present)
- [ ] Smoke test: sign in, core action, sign out
- [ ] Health checks OK; no new error types for 30 min (📱 crash-free rate holding)

## Rollback plan
- Web/API: {{host one-click rollback / revert PR}}
- 📱 Mobile: halt the staged rollout, turn off the feature flag, ship an OTA fix (JS/Dart only) or an expedited patch release
- Data: {{migration down path or forward fix}}
- Who decides:

## After
- [ ] Monitor error/crash rates and the core funnel for 24 h (📱 and store reviews for a week)
- [ ] Note learnings in CLAUDE.md "Lessons learned" if relevant
