# AI-Driven App Development Workflow

A step-by-step process for building production-quality apps with Claude Code doing most of the
implementation. Humans spend their effort on deciding what to build, setting up guardrails, and
reviewing at checkpoints. Write code by hand only when you want to.

It works for **any stack**: web apps, APIs and mobile apps (native or cross-platform). The process
is the same everywhere. What changes per stack is a small preset (`stack-presets/`) holding the
commands, tool versions and conventions. 📱 marks extra steps for mobile apps.

> **How to use this file**
> - **Follow it yourself:** go phase by phase. Each phase ends with a **Gate**. Don't move on
>   until the gate passes.
> - **Hand it to Claude Code:** copy this template into your repo and say:
>   *"Read WORKFLOW.md and CLAUDE.md. We are in Phase N. Do the AI steps for this phase, stop at
>   every 🧑 HUMAN GATE, and show me the output artifact."*
> - Markers: 🤖 = Claude does this · 🧑 = you do or decide this · 🚦 = gate · 📱 = mobile only.
>
> **Two tools, two jobs.** Visual work (prototype, wireframes, design system, key screens in
> Phases 2, 4 and 5) happens in **Claude Design** in the Claude app, using the *Design* and
> *Design System* artifact types. Everything in the repo (docs, code, tests) happens in
> **Claude Code**. The bridge between them is the `design/` folder: links to the design
> artifacts, exported screen images and a tokens file, which Claude Code reads.

---

## The core idea

| Effort goes into… | Instead of… |
|---|---|
| Writing testable criteria and acceptance criteria | Re-explaining what you meant after the fact |
| Automated guardrails (types, lint, tests, CI, scanners) | Reading every line the AI wrote |
| Short reviews at fixed checkpoints (plan, diff, release) | Watching the AI work |
| Boring, popular tech + managed services | Clever stacks the AI has seen less of |

**How the template stays stack-agnostic:**
```
Claude / hooks / CI / you  ──▶  ./scripts/task.sh <task>  ──▶  .project/commands.env  ──▶  npm / uv / go / dotnet / gradle / flutter / xcodebuild …
```
Everything calls the same task names (`check`, `lint`, `test`, `test-e2e`, `build`, `audit`, …).
Only `commands.env` knows the real tools. Changing stack means changing one file.

**Where AI typically fails, and the guardrail for each:**

| Failure mode | Guardrail in this template |
|---|---|
| Subtle auth/permission bugs | Central authorization function, deny-by-default, permission-matrix tests, `ask` rules on auth/security paths, security-reviewer subagent, human gate |
| Architectural drift | CLAUDE.md layer rules, ADRs, stack-specific boundary rules, architecture-reviewer subagent |
| Over-engineering | "Smallest change that meets the acceptance criteria" rule, plan review before any code |
| Hallucinated libraries/APIs | Package installs need approval, dependency checklist, compiler/typecheck + tests in the loop, docs lookup before use |
| "Works on my machine" claims | Stop hook runs checks before Claude can finish; CI blocks merge |
| Leaked secrets | `.env`/key/keystore reads denied, config module, gitleaks in CI, secrets only on the server and in secret stores |
| 📱 Secrets or trust in the app binary | Rule: the app is untrusted and holds no secrets; authorization happens on the backend |

---

## Phase overview

| # | Phase | Main output | Human role |
|---|---|---|---|
| 0 | Template setup | Repo with guardrail config | Do once |
| 1 | Idea & success criteria | `docs/01-idea-and-criteria.md` | **Owns** |
| 2 | Disposable prototype | Clickable prototype in Claude Design + learnings | Tests with users |
| 3 | Architecture, stack, data model & permissions | `docs/03-architecture.md`, ADRs, chosen preset | **Approves** |
| 4 | UX flow | `docs/04-ux-flow.md` (+ optional wireframes) | **Approves** |
| 5 | UI & design system | Design System + key screens in Claude Design; `design/` + `docs/05` in the repo | **Approves** |
| 6 | Backlog: epics → stories → tasks | `docs/06-backlog.md` | Prioritizes |
| 7 | Foundation (walking skeleton) | Running app with every guardrail live | Reviews |
| 8 | Build loop, one slice at a time | Merged features | Reviews plan + diff |
| 9 | Testing strategy (runs during 7–8) | Test suites | Spot-checks |
| 10 | Security & privacy review | `docs/07-security-checklist.md` signed off | **Owns** |
| 11 | Deploy & release | Production release / store release | **Approves** |
| 12 | Monitor & iterate | Dashboards, alerts, new stories | Triage |

> **Important ordering change:** guardrails (CI, tests, secret scanning, monitoring) are built in
> **Phase 7, before any features**. If you add them at the end, you will have to retrofit them
> onto code that was never checked.

---

## Phase 0 — Set up the template (once per project)

🧑 Steps:
1. Create the repo and copy in this template. Run `chmod +x scripts/task.sh .claude/hooks/*.sh`.
   Don't pick a stack yet; that happens in Phase 3. Until then the hooks and CI do nothing.
2. On GitHub, protect `main`: require a PR, require the checks `quality`, `e2e`, `secrets`, `audit`
   to pass, require branches to be up to date, and block force-pushes.
3. In GitHub → Settings → Code security, turn on CodeQL **default setup**, secret scanning with
   push protection, and Dependabot alerts.
4. Install [mise](https://mise.jdx.dev) locally. It installs the tool versions the preset pins, the
   same ones CI uses.
5. Optional: add `ANTHROPIC_API_KEY` (or `CLAUDE_CODE_OAUTH_TOKEN`) as a repo secret for the
   automated Claude PR review workflow.
6. Optional MCP servers for Claude Code: Playwright MCP (lets Claude look at a running web UI), a
   docs server such as Context7 (current library docs), and 📱 a mobile simulator MCP if you use one.

🚦 **Gate:** `/hooks` in Claude Code shows the two hooks, and branch protection is on.

---

## Phase 1 — Idea & testable success criteria

**Goal:** a one-page description of the problem, who has it, and how you will know the app
succeeded. Every criterion must be something you can check.

🧑 Write a rough paragraph: the problem, the users, the core action, and why now.

🤖 Prompt:
```
Read docs/01-idea-and-criteria.md (template). Interview me with at most 8 questions,
one round at a time, to fill it in. Then rewrite every vague success criterion into a
measurable one (a number, a time, a count, or a pass/fail observation). Flag any criterion
that you can't measure and propose how to measure it.
```

Examples of rewrites:
| Vague | Testable |
|---|---|
| Easy to use | A new user completes the core action in < 2 min without help (5 of 5 test users) |
| Not boring | ≥ 40% of test users return within 7 days (once live) |
| Fast (web) | Core page LCP < 2.5 s on mid-range mobile on 4G; API p95 < 300 ms |
| 📱 Fast (mobile) | Cold start < 2 s on a mid-range Android device; no dropped frames on the core screen |
| 📱 Stable | Crash-free sessions ≥ 99.5% |
| Simple onboarding | ≤ 3 steps from install/sign-up to first value; no step needs documentation |
| Secure | No high/critical findings in the security checklist; all role × action pairs tested |

🚦 **Gate:** every criterion has a metric and a way to measure it. The **core action** is named.
Non-goals are listed. You've decided the platform(s): web, iOS, Android, or a mix.

---

## Phase 2 — Disposable prototype

**Goal:** check the flow and the value proposition quickly. The prototype is a **living spec**,
not the start of the codebase.

Rules:
- Build it in **Claude Design** (Claude app), outside the repo. Alternatives: Replit, v0, or
  📱 Expo Snack for something that runs on a phone.
- Fake data, no auth, no backend. A few prompts at most.
- Cover only the core action plus the first screen a new user sees.
- Keep it **unstyled-ish**: neutral colors and system fonts. You're testing the flow, not the
  look; a polished prototype makes testers comment on colors instead of the task.
- 📱 Use phone-sized artboards and test it **on a phone**, held in one hand. A desktop browser
  hides most mobile UX problems.

🤖 Prompt (in the Claude app):
```
Use Claude Design to make a clickable prototype of this app's core flow.
<paste the Problem, Users and Core action sections of docs/01>
Screens: first screen a new user sees → the core action → the success state.
Fake but realistic data. Neutral, low-fidelity styling. <Phone | desktop>-sized artboards.
```
🧑 Paste the prototype link into `design/README.md` under "Prototype".

🧑 Test it with 3–5 people. Give them the task, don't help them, and time them against your Phase 1
criteria. Write down where they hesitated.

🤖 Then:
```
Here are my user-test notes: <notes>. Update docs/02-prototype-notes.md with:
what worked, what confused people, flow changes, and features we can drop.
```

🚦 **Gate:** the core action works for most testers within the target time, or you have changed
the idea. Learnings are written down. **The prototype code is not reused.**

---

## Phase 3 — Architecture, stack, data model & permissions (🧑 HUMAN GATE)

**Goal:** choose a deliberate foundation. Most of the hard-to-reverse decisions happen here.

### 3.1 Choosing the stack
Principles, in order:
1. **Boring and popular.** AI writes the best code in mainstream stacks with lots of public code
   and stable APIs. Prefer the most common choice in the ecosystem over the newest.
2. **Typed.** Static types (or strict type checking) catch a large share of AI mistakes for free.
3. **Managed services for the risky parts:** auth, payments, file storage, email, push.
4. **One language where possible.** Fewer toolchains means more consistent AI output.
5. **What your team can review.** You have to read the 🔐 code line by line, so pick a language
   you read well.

| Concern | Principle | Typical choices |
|---|---|---|
| Web full-stack | One framework for UI + server | Next.js (TS), Django / FastAPI + HTMX, ASP.NET Core, Spring Boot |
| API / backend | Typed, well-known framework | FastAPI, Go + chi, ASP.NET Core, Spring Boot, NestJS |
| 📱 Mobile | Cross-platform unless you need deep native features | Expo/React Native, Flutter; native SwiftUI / Jetpack Compose |
| 📱 Mobile backend | Don't build one if a BaaS covers it | Supabase, Firebase, or your own API from the row above |
| Database | Relational by default | Postgres (pick an EU region for EU personal data) |
| Auth | Managed, never hand-written | Clerk, Auth0, Supabase Auth, Firebase Auth, Entra ID, Keycloak |
| Payments | Managed | Stripe; 📱 App Store / Play Billing for digital goods (store rules) |
| Files | Private buckets, signed URLs | S3, R2, Supabase Storage, Firebase Storage |
| Errors / logs | From day one | Sentry, Crashlytics (📱), structured JSON logs |
| Hosting | Preview environment per PR | Vercel, Render, Fly.io, Azure App Service, Cloud Run |

Every choice that differs from the preset defaults gets an ADR (`docs/adr/`).

### 3.2 Pick or create a preset
Look in `stack-presets/` (Node/TS, Python, Go, .NET, Java, Expo/React Native, Flutter, iOS Swift,
Android Kotlin). If your stack isn't there, copy the closest one and adapt it. For an app plus an
API, combine two presets (see `stack-presets/README.md`). You apply it in Phase 7.

🤖 Prompt (run in **plan mode**: Shift+Tab until it says plan mode):
```
Read docs/01, docs/02, WORKFLOW.md §3 and stack-presets/README.md.
Recommend a stack and preset(s) with reasons and one alternative. Then fill in
docs/03-architecture.md: stack choices (ADR for each deviation from the preset), system
diagram, folder structure, data model (entities, fields, relations, indexes, ownership),
roles and the permission matrix (role × resource × action), external services, secrets list
(and where each one lives), and the top 5 risks. Prefer fewer moving parts. No application code.
```

### 3.3 Data model — 🧑 review carefully
Check: every table has an owner (user/org) column where needed; there are no nullable fields
without a reason; uniqueness and foreign keys are defined; soft delete vs. hard delete is
decided; personal data columns are marked (GDPR: purpose, retention, deletion path).
📱 Also decide what is cached on the device, for how long, and what happens offline.

### 3.4 Permission matrix — 🧑 review carefully
One table, every role × every action, with a default of **deny**. This table becomes an
automated test in Phase 9. It is enforced on the **server/backend** (or database RLS), never only
in the UI or the mobile app.

### 3.5 Admin dashboard
Treat it as just another role in the matrix, not a separate app with its own rules. Decide early:
which admin actions are audited, and which need a second confirmation. 📱 Admin is usually a
web app, even when the product is mobile.

🚦 **Gate:** you have approved the stack + preset, data model, permission matrix and secrets list.
ADRs are written for non-default choices.

---

## Phase 4 — UX flow (🧑 HUMAN GATE)

**Goal:** decide what the user sees, in what order, and why, before any pixels.

🤖 Prompt:
```
Using docs/01, docs/02 and docs/03, fill in docs/04-ux-flow.md:
1. Entry points (first visit/install, returning user, invited user / deep link, admin).
2. A Mermaid flowchart of the core flow and onboarding.
3. For every screen: its purpose, the one primary action, the data shown,
   and the empty / loading / error / no-permission (and, for mobile, offline) states.
4. The reason for each step, tied to a success criterion. Remove any step without one.
5. Count the steps to first value and compare with the criterion.
```

📱 Mobile additions:
- **Permission prompts** (notifications, camera, location): ask only at the moment of need, with
  a short explanation screen first. Plan the "denied" path.
- **Navigation model:** tabs vs. stack, back behavior on Android, gestures on iOS.
- **Interruptions:** app backgrounded mid-flow, no network, low storage, app update required.
- **Deep links / universal links:** where each one lands, signed in and signed out.

**Optional: wireframes in Claude Design.** If the flow is hard to judge from a flowchart, sketch
it. Grey boxes only, no colors or fonts, so nobody mistakes it for the visual design.

🤖 Prompt (in the Claude app):
```
Use Claude Design to make grey-box wireframes from this UX flow.
<paste docs/04-ux-flow.md>
One artboard per screen, plus its empty, loading, error and no-permission states.
Label the primary action on each screen. No colors, no brand fonts.
```

🧑 Walk through the flow as each persona. Cut steps. If you made wireframes, add the link to
`design/README.md` and keep docs/04 as the source of truth for the flow.

🚦 **Gate:** steps to first value meet the criterion. Every screen has all its states defined.

---

## Phase 5 — UI & design system (🧑 HUMAN GATE on look and feel)

**Goal:** a constrained visual language so the AI composes from existing parts instead of
inventing new ones on every screen. Done in Claude Design, then brought into the repo.

Where things live:

| What | Source of truth | Copy in the repo (for Claude Code) |
|---|---|---|
| Tokens, components, usage rules | **Design System** artifact (Claude app) | `design/tokens.json` + `docs/05-design-system.md` |
| Key screens and their states | **Design** artifact (Claude app) | `design/screens/*.png` (exported images) |
| Links to both | `design/README.md` | |

If your organization already has a design system in Claude, start from it instead of making a
new one (in the Claude app: "list my design systems").

### 5.1 Design system (in the Claude app)
🤖 Prompt:
```
Create a design system in Claude Design for this app.
Audience and tone: <from docs/01>. UI framework: <from docs/03, e.g. React + shadcn/ui,
Flutter Material 3, SwiftUI>. Platforms: <web / iOS / Android>.
Include: color tokens for light and dark (text/background contrast ≥ WCAG AA), type scale,
spacing scale, radius, elevation, motion, and the component set of our UI framework plus
these app composites: ScreenHeader, EmptyState, ErrorState, LoadingState, ConfirmDialog.
Write short usage rules for each component (when to use, when not to).
```
📱 Ask for platform conventions where users expect them (iOS Human Interface Guidelines,
Material 3), dynamic type / font scaling, dark mode, and touch targets ≥ 44 pt / 48 dp.

### 5.2 Key screens (in the Claude app)
🤖 Prompt:
```
Using the <name> design system, design the key screens of this app in Claude Design.
<paste the screen list and states from docs/04-ux-flow.md>
Use only that design system's tokens and components. For each screen show the filled,
empty, loading, error and no-permission states<, and offline for mobile>.
<Phone | desktop>-sized artboards, light and dark.
```
🧑 Judge the feel. This is the part AI can't sign off for you. Iterate in Claude Design until
you'd be happy to ship it.

### 5.3 Bring it into the repo (Claude app → repo)
1. Ask Claude in the same conversation: *"Export this design system's tokens as a flat JSON file
   (color for light and dark, typography, spacing, radius, elevation, motion)."* Save it as
   `design/tokens.json`.
2. Export each approved screen as an image (or one PDF) into `design/screens/`, named after
   the screen in docs/04 (e.g. `project-list--empty.png`).
3. Put both artifact links in `design/README.md`.

🤖 Then in Claude Code:
```
Read design/tokens.json, design/screens/ and design/README.md. Fill in
docs/05-design-system.md: the allowed component list and usage rules, the patterns,
and where the tokens will live in code for our UI framework. Don't change token values.
```

Mapping the tokens into code (CSS variables + Tailwind, `ThemeData`, a SwiftUI `Theme`,
`MaterialTheme`, …) happens in Phase 7, from `design/tokens.json`.

**Changing the design later:** change it in Claude Design first, re-export the tokens or
screens, and let Claude Code apply the diff. Don't let the code and the design drift apart.

🚦 **Gate:** design system and key screens approved in Claude Design; `design/tokens.json`,
`design/screens/` and `docs/05` are committed. The CLAUDE.md rule "use only tokens and listed
components" is now in force.

---

## Phase 6 — Backlog: epics → stories → tasks

**Goal:** visible, adjustable progress in **thin vertical slices**. Each story delivers UI + logic +
data end to end and can be demoed on its own.

Structure (see `docs/06-backlog.md`):
- **Epic** — a user outcome ("Users can manage their projects").
- **Story** — one vertical slice, finished in one PR, ideally < ~400 lines of diff.
  - Written as: *As a <role>, I can <action>, so that <value>.*
  - **Acceptance criteria** in Given/When/Then form. These become tests.
  - **Flags:** 🔐 touches auth/permissions/payments/personal data → needs a human gate.
- **Tasks** — written by Claude in the plan for each slice. You don't need to pre-write them.

📱 For an app + backend, a vertical slice includes the API endpoint *and* the screen. Avoid
"build all endpoints, then all screens".

🤖 Prompt:
```
From docs/01–05 and design/, write docs/06-backlog.md. Story 0 is the walking skeleton (Phase 7).
Order stories so that the core action works end to end as early as possible.
Each story: thin vertical slice, Given/When/Then acceptance criteria, 🔐 flag if relevant,
dependencies, size S/M/L, and the design/screens/ images it implements. Split anything L.
Mark the MVP cut line.
```

🧑 Reorder and cut. Move anything not needed for the success criteria below the MVP line.

🚦 **Gate:** the MVP stories are ordered, all of them have acceptance criteria, and 🔐 stories are
flagged.

---

## Phase 7 — Foundation / walking skeleton (Story 0)

**Goal:** an app that does almost nothing, running where users will run it, with **every
guardrail live**. From here on, every feature goes through the same checks.

🤖 Checklist (Claude runs it in plan mode first, then implements):
- [ ] **Apply the preset:** copy `stack-presets/<name>/commands.env` → `.project/commands.env` and
      `mise.toml` → repo root; paste `STACK.md` into CLAUDE.md "Stack specifics"; uncomment the
      Dependabot ecosystem. Set repo variables `CI_RUNNER` / `E2E_RUNNER` if needed (📱 iOS needs
      `macos-latest`).
- [ ] Scaffold the project with the framework's official generator.
- [ ] Map `design/tokens.json` into the UI framework's theme (one generated or hand-written
      theme file; components never use raw color/size values) and build the app composites
      from docs/05. Compare against `design/screens/`.
- [ ] Strictest reasonable compiler/type-checker settings and warnings as errors.
- [ ] Formatter + linter configured; the edit hook formats and lints files as Claude writes them.
- [ ] Layer boundaries enforced by tooling where the stack allows (import rules, module
      visibility, separate projects/packages).
- [ ] Unit test runner + one passing test; e2e runner + one smoke test (app starts, home screen
      renders, no errors).
- [ ] Config module validating all config at startup. `.env.example` lists every variable with no
      real values. 📱 Build-time config holds public values only.
- [ ] Managed auth wired in: sign up, sign in, sign out, one protected screen/endpoint.
- [ ] Authorization module with `can(user, action, resource)`, deny by default, plus the
      permission-matrix test generated from docs/03.
- [ ] DB + migrations + first migration + seed script for local/dev/preview (if there's a DB).
- [ ] Error monitoring (client + server), structured logging, health endpoint for services.
- [ ] Web: security headers (CSP, HSTS, X-Content-Type-Options, Referrer-Policy, frame-ancestors).
- [ ] 📱 Mobile: bundle ID / application ID, app icons and splash placeholders, build variants
      (dev / preview / production) pointing at separate backends, crash reporting, and a first
      build installed through internal distribution (TestFlight / Play internal testing /
      EAS / Firebase App Distribution). Signing keys live in the CI/build service, never in the repo.
- [ ] Pre-commit hook (format + lint staged files; gitleaks if available locally).
- [ ] `./scripts/task.sh check` passes locally; CI workflows are green; a preview environment per
      PR works (web: preview deploy; 📱 mobile: preview build or OTA preview channel).

🤖 Prompt:
```
We are in Phase 7. Read CLAUDE.md, docs/03, stack-presets/README.md and the Phase 7
checklist in WORKFLOW.md. In plan mode, propose the exact steps, the preset(s) to apply,
and every dependency you will add (name, purpose, and that it exists in the package
registry with recent releases). Wait for my approval before implementing.
```

🚦 **Gate:** the PR is green in CI, the preview works, sign-in works, error monitoring receives a
test error, and the permission-matrix test runs. **No feature work before this gate.**

---

## Phase 8 — The build loop (repeat per slice)

```
┌─────────────┐   ┌──────────────┐   ┌──────────────────────┐   ┌─────────────┐   ┌───────┐
│ /plan-slice │──▶│ 🧑 review    │──▶│ /build-slice         │──▶│ 🧑 review   │──▶│ merge │
│ (plan mode) │   │ plan (2 min) │   │ AI implements + runs │   │ diff + PR   │   │       │
└─────────────┘   └──────────────┘   │ checks + fixes itself│   │ preview     │   └───┬───┘
       ▲                             └──────────────────────┘   └─────────────┘       │
       └──────────────────────────────── /clear, next story ◀────────────────────────┘
```

**Step 1 — Plan.** Start a fresh session (`/clear`), switch to plan mode, run
`/plan-slice S-012`. Claude reads the story, CLAUDE.md and the relevant docs, then outputs:
files to touch, data/migration changes, new dependencies, tests per acceptance criterion,
risks, and any 🔐 gates.

**Step 2 — 🧑 Review the plan.** This is the cheapest place to catch over-engineering and drift.
Look for: new dependencies, new patterns not in CLAUDE.md, schema changes, anything 🔐, and scope
creep beyond the acceptance criteria.

**Step 3 — Build.** Exit plan mode, run `/build-slice S-012`. Claude:
1. creates a branch `feat/S-012-short-name`;
2. writes failing tests for the acceptance criteria first;
3. implements the smallest change that passes them;
4. runs `/verify` (`./scripts/task.sh check`, `build`, and `test-e2e` for affected flows) and fixes failures;
5. runs the `security-reviewer` subagent if 🔐, and the `architecture-reviewer` subagent;
6. updates `docs/06-backlog.md` status and opens a PR using the PR template.

The **Stop hook** re-runs the fast checks whenever Claude tries to finish, and sends it back to
work if anything fails. You only see work that passed.

**Step 4 — 🧑 Review the diff.** Use the PR template checklist. Compare the screens with the
approved design (`design/screens/`). Try the story on the preview
(📱 on a real device, at least once per platform per epic). For 🔐 stories, read the auth and
permission code line by line. This is non-negotiable.

**Step 5 — Merge** (CI must be green). Then `/clear` and pick the next story.

**Context hygiene:**
- One story per session. `/clear` between stories; long sessions drift.
- Keep CLAUDE.md under ~200 lines. Put details in `docs/` and link to them.
- When Claude makes the same mistake twice, add a rule to CLAUDE.md (or a lint rule, which is
  better because it is enforced).

**Going faster later:** once the loop is stable, run independent stories in parallel with git
worktrees (one Claude session per worktree). Only do this for stories that don't touch the same
files or the schema.

---

## Phase 9 — Testing strategy (built in Phase 7, extended in every slice)

| Layer | What it covers | Task | When it runs |
|---|---|---|---|
| Static | Types/compile, lint, formatting, layer boundaries | `typecheck`, `lint`, `format-check` | Edit hook, Stop hook, CI |
| Unit | Pure logic, validation schemas, `can()` | `test` | Stop hook, CI |
| Integration | Endpoints/actions + real DB, with auth context | `test` | CI (Postgres service) |
| Permission matrix | Every role × action from docs/03 → allowed/denied | `test` | CI (required) |
| E2E | Each story's acceptance criteria for core flows, signed in and out | `test-e2e` | `/verify`, CI |
| Accessibility | Web: axe; 📱 platform accessibility checks / labels on all controls | `test-e2e` | CI |
| Performance | Budgets from Phase 1 (Lighthouse CI; 📱 startup time, frame drops) | optional | CI on main / pre-release |
| Visual | Screenshot / golden tests for key screens | `test` | CI |

Tools by stack are listed in each preset's `STACK.md`. Typical e2e choices: Playwright (web, any
backend), 📱 Maestro (any mobile stack, easiest for AI to write), XCUITest, Espresso/Compose tests,
Flutter `integration_test`.

📱 **Device coverage:** run e2e on one current iOS and one older, mid-range Android in CI. Do a
manual check on real devices before each release (small screen, large font, dark mode, slow network).

Rules:
- Each acceptance criterion maps to at least one test, named after the story ID
  (`S-012: owner can archive project`).
- **Test the "no":** for every protected action, a test that the wrong role or another tenant gets
  refused and nothing changes. AI-written code is most often wrong in what it *allows*.
- Claude must not weaken, skip or delete a test to make it pass. Changing a test needs a reason
  in the PR description.

---

## Phase 10 — Security & privacy (🧑 owns the sign-off)

Run continuously, with a full pass before the first production release and every quarter after.

🤖 Automated: dependency audit (`./scripts/task.sh audit`), gitleaks, CodeQL default setup,
dependency review on PRs, Dependabot updates, the security-reviewer subagent on 🔐 PRs.

🧑 Manual, using `docs/07-security-checklist.md`, which covers:
- **Authentication:** managed provider, MFA available, session/token lifetime, sign-out everywhere.
- **Authorization:** every entry point authenticates and calls `can()`; tenant isolation; IDs
  never trusted from the client; admin actions audited.
- **Input/output:** validation at every boundary, parameterized queries only, output escaping,
  upload limits.
- **Secrets:** only in secret stores; separate keys per environment; rotation plan; nothing secret
  in front-end bundles or mobile binaries.
- **APIs:** rate limits, webhook signature verification, CORS locked down, timeouts and retries.
- 📱 **Mobile (OWASP MASVS):** tokens in Keychain/Keystore, TLS only, deep-link input validated,
  minimal OS permissions, no sensitive data in logs or screenshots, privacy manifest / data-safety
  form accurate.
- **Privacy (GDPR):** data inventory, lawful basis, retention, export/delete paths (📱 in-app
  account deletion is required by both stores), DPA with each processor, EU data residency if required.

🚦 **Gate:** no open high/critical items, and you have signed the checklist.

---

## Phase 11 — Deploy & release (🧑 approves)

**All apps:**
- **Environments:** local → preview (per PR, seeded data) → production. Separate databases and
  separate secrets per environment.
- **Migrations:** run as a deploy step, backward-compatible (expand → migrate → contract). Never an
  AI-run migration against production without a human present.
- **Feature flags** for risky changes, so you can turn them off without a rollback.
- **Backups:** automatic DB backups plus one tested restore.

**Web and services:** know the one-click rollback on your host and test it once.

📱 **Mobile:**
- **You can't roll back a store release.** Old versions stay on phones for months. So: keep the
  API backward-compatible with every supported app version, add a **minimum-supported-version
  check** (force-update screen) from the first release, and use feature flags/remote config.
- **Release path:** internal testing → beta (TestFlight / Play closed testing) → staged rollout
  (e.g. 1% → 10% → 50% → 100%) while watching crash-free rate.
- **Store review:** plan for review time; keep store listing, screenshots, privacy labels / data
  safety and age rating up to date. Payments for digital goods must follow store rules.
- **OTA updates** (EAS Update, Shorebird) are for JS/Dart-level fixes only, go through the same CI,
  and are pushed to production by a human.
- **Versioning:** semantic version for users, build number incremented automatically by CI.

🤖 `/release` runs `docs/08-release-checklist.md` and drafts release notes (📱 and store "What's new" text).

🚦 **Gate:** the release checklist is complete, and you click deploy / submit for review / start
the rollout.

---

## Phase 12 — Monitor & iterate

- Error alerts for new error types and error-rate spikes; uptime check on health endpoints.
- 📱 Crash-free sessions/users per version, ANRs (Android), app start time, store ratings and reviews.
- Product analytics on the core action funnel. Compare it with the Phase 1 criteria every week.
- Weekly triage: 🤖 summarizes new errors, failed jobs, dependency PRs (📱 and store reviews) into
  proposed stories → 🧑 prioritizes them → back into Phase 8.

🤖 Prompt (good as a weekly scheduled task):
```
Summarize this week's new errors/crashes, failing checks, open Dependabot PRs, store reviews
(if mobile) and funnel metrics against docs/01 success criteria. Propose up to 5 stories for
docs/06-backlog.md with acceptance criteria. Don't change code.
```

---

## Appendix A — Autonomy levels

Increase autonomy only as your guardrails earn trust.

| Level | You review | Use when |
|---|---|---|
| 1 | Every plan + every diff line | Phase 7, the first ~5 slices, all 🔐 slices (always) |
| 2 | Every plan + diff skim + preview test | Normal feature slices once CI is solid |
| 3 | Plan skim + preview test; CI + AI review cover the diff | Low-risk UI/copy slices, tests, refactors with no behaviour change |

🔐 work never goes above level 1.

## Appendix B — When things go wrong

| Symptom | Fix |
|---|---|
| Claude keeps adding abstractions | Add to CLAUDE.md: "No new abstraction until the 3rd duplicate"; reject in plan review |
| Same bug type recurs | Turn it into a lint rule or a test, not just a CLAUDE.md line |
| Claude invents an API | Require docs lookup before using an unfamiliar API; the compiler and tests catch the rest |
| Huge diffs | Story was too big. Split it, and use `git restore` freely; AI code is cheap to redo |
| Session gets confused | `/clear`, then restart from the story plus a fresh `/plan-slice` |
| Stop hook loops on a failure it can't fix | It gives up after 3 tries and tells you. Read the error and give a hint |
| Stop hook too slow | Trim `STOP_CHECKS` in `.project/commands.env` to the fastest checks; CI still runs everything |
| 📱 Works in simulator, fails on device | Add a real-device check to the release checklist; test on a low-end Android early |

## Appendix C — Adding a stack that has no preset

1. Copy the closest folder in `stack-presets/`.
2. Fill in every `*_CMD` in `commands.env` (leave a command empty if it doesn't apply), the
   per-file format/lint commands and extensions, and a fast `STOP_CHECKS`.
3. Pin tool versions in `mise.toml`.
4. Write `STACK.md`: default libraries, folder layout, and the "generic rule → this stack" table
   (config module, server boundary, validation, auth helper, authorization, escape hatches).
5. Test it: `./scripts/task.sh list`, then `./scripts/task.sh check` on a fresh scaffold.
