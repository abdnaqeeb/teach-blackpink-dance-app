### Stack: Node + TypeScript (Next.js)
- Next.js (App Router), React, TypeScript `strict` + `noUncheckedIndexedAccess`
- UI: Tailwind CSS + shadcn/ui; tokens as CSS variables in `src/app/globals.css`
- DB: Postgres via Drizzle (migrations in `drizzle/`) · Validation: Zod
- Auth: Clerk / Auth0 / Supabase Auth · Payments: Stripe · Errors: Sentry · Logs: pino
- Tests: Vitest + Testing Library + MSW (unit/integration), Playwright + axe (e2e)
- Dependency manifest: `package.json` · Dependabot ecosystem: `npm`

### Folder layout
```
src/app/              routes only (thin)
src/features/<name>/  components, actions.ts, queries.ts, schema.ts, *.test.ts
src/components/ui/    shadcn/ui (generated; change via tokens)
src/server/           server-only code (`import "server-only"`): db/, auth/, authz/
src/lib/              pure helpers
src/env.ts            Zod-validated env (the config module)
tests/e2e/            Playwright specs
```

### Generic rule → this stack
| Generic rule | Here |
|---|---|
| Config module | `src/env.ts` (Zod); public values only via `NEXT_PUBLIC_*` |
| Server boundary | `src/server/**` with `import "server-only"`; ESLint `no-restricted-imports` from client code |
| Input validation | Zod schema in each feature's `schema.ts`, parsed in every server action / route handler |
| Auth helpers | `requireUser()` in `src/server/auth/` |
| Authorization | `can(user, action, resource)` in `src/server/authz/` |
| Escape hatches to justify | `any`, `@ts-ignore`, `eslint-disable`, `dangerouslySetInnerHTML` |
| Required `package.json` scripts | `dev`, `build` (the rest run through `npx` in commands.env) |
