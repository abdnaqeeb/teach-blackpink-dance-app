# AI App Template (any stack: web, API, mobile)

A starting kit for building apps with Claude Code: you decide, set guardrails and review at
checkpoints; Claude implements, tests and fixes its own failures. The process and automation are
stack-agnostic. A small **preset** plugs in your language and tools.

## What's inside
| Path | Purpose |
|---|---|
| `WORKFLOW.md` | The full process, from idea to monitoring, with gates, prompts, and 📱 mobile steps |
| `CLAUDE.md` | Project memory Claude reads every session: layers, rules, human gates, definition of done, and a **Stack specifics** slot |
| `docs/01–08` | Fill-in templates: criteria, prototype notes, architecture, UX flow, design system, backlog, security, release |
| `docs/adr/` | Architecture decision records |
| `design/` | Bridge from Claude Design: artifact links, exported tokens (`tokens.json`) and screen images |
| `scripts/task.sh` | **One entry point for every command** (`check`, `lint`, `test`, `test-e2e`, `build`, `audit`, …) |
| `.project/commands.env` | The real commands for your stack (created from a preset in Phase 7) |
| `stack-presets/` | Node/TS (Next.js), Python, Go, .NET, Java, Expo/React Native, Flutter, iOS Swift, Android Kotlin |
| `.claude/settings.json` | Permissions (allow / ask / deny) + hooks |
| `.claude/hooks/` | Format + lint after every edit; run checks before Claude can finish (pure bash, any stack) |
| `.claude/skills/` | Slash commands: `/plan-slice`, `/build-slice`, `/verify`, `/security-review`, `/adr`, `/release` |
| `.claude/agents/` | `security-reviewer` and `architecture-reviewer` subagents |
| `.github/workflows/` | CI via `task.sh` + mise, security (gitleaks, audit, dependency review), optional Claude PR review |

## How it stays stack-agnostic
```
Claude / hooks / CI / you ─▶ ./scripts/task.sh <task> ─▶ .project/commands.env ─▶ your real tools
```
Tool versions come from `mise.toml`, so local machines and CI use the same toolchain.
A project with a mobile app and an API combines two presets in one `commands.env`.

## Quick start
1. Copy everything into a new repo on a `main` branch and make the scripts executable. The exact
   commands, including Windows (Git Bash), are in WORKFLOW.md → Phase 0, step 1.
2. Protect `main` on GitHub: require a PR and the checks `quality`, `e2e`, `secrets`, `audit`.
   Turn on CodeQL default setup, secret scanning and Dependabot alerts.
3. Open Claude Code in the repo and say:
   > Read WORKFLOW.md and CLAUDE.md. We're in Phase 1. Interview me to fill in docs/01.
4. Follow the phases. You choose the stack in Phase 3 and apply its preset in Phase 7. Until then,
   the hooks and CI do nothing, so they don't get in the way of planning.

## Applying a preset (Phase 7)
```bash
cp stack-presets/python/commands.env .project/commands.env
cp stack-presets/python/mise.toml mise.toml
# paste stack-presets/python/STACK.md into CLAUDE.md → "Stack specifics"
# uncomment your ecosystem in .github/dependabot.yml
mise install
./scripts/task.sh list     # see what each task runs
./scripts/task.sh check
```
For iOS (or any macOS-only build), set repo variables `CI_RUNNER=macos-latest` and/or
`E2E_RUNNER=macos-latest`. Set `E2E_ENABLED=false` until your e2e setup exists.

## Notes
- Hooks need only bash (jq is used if installed). They work on macOS, Linux and Windows with Git Bash/WSL.
- The Stop hook runs `STOP_CHECKS` (fast checks) and gives Claude up to 3 tries to fix failures,
  then stops and tells you. CI runs everything.
- Permission `ask` rules make Claude pause before touching auth/security/migration folders,
  dependency manifests, CI, mobile manifests/entitlements, and before installing packages,
  pushing, or building/updating via EAS/fastlane. Deny rules block reading `.env` files, keys,
  keystores and signing files, force-pushing, and store submission. These lower risk but aren't
  a sandbox; keep production secrets off your dev machine where you can.
- `.gitignore` covers all preset stacks; remove sections you don't need.
- `claude-review.yml` is optional; delete it if you don't want API-billed PR reviews.
