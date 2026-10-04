## Story
S-___: <title> · 🔐 yes / no

## What changed and why
<!-- 2–4 bullets. Link the plan if it was long. -->

## Acceptance criteria → evidence
| Criterion | Test(s) | Result |
|---|---|---|
| | | ✅ |

## Try it on the preview
1.

## Checklist (author / AI)
- [ ] `./scripts/task.sh check`, `build` and affected `test-e2e` pass locally
- [ ] Negative authz tests for new protected actions
- [ ] Only design tokens + listed components; all screen states done (incl. offline for mobile)
- [ ] No new dependency, or it was approved in the plan: <name>
- [ ] No schema change, or migration reviewed by a human
- [ ] 📱 No new OS permissions / entitlements / manifest changes, or listed here: …
- [ ] No tests skipped/weakened (if a test changed, why: …)
- [ ] Backlog status and ADRs updated

## Reviewer findings
- architecture-reviewer:
- security-reviewer (🔐 only):

## Human reviewer
- [ ] Read the plan's 🔐 items line by line
- [ ] Tried the story on the preview (📱 on a device)
- [ ] Matches the approved design (`design/screens/`) and feels right (UX judgment)
