### Stack: Go
- Go 1.25, net/http + chi router, Postgres via pgx + sqlc (typed queries), goose migrations
- Quality: gofmt, go vet, golangci-lint (enable gosec, errcheck, staticcheck)
- Tests: `go test` with table-driven tests; testcontainers or the CI Postgres service for integration; Playwright in `e2e/` for web UIs
- Auth: managed provider (verify JWTs with its JWKS) · Errors: Sentry · Logs: `log/slog` JSON
- Dependency manifest: `go.mod` · Dependabot ecosystem: `gomod`

### Folder layout
```
cmd/server/main.go        wiring only
internal/http/            handlers (thin): decode+validate → auth → authz → service
internal/<feature>/       service.go, repo (sqlc), types, *_test.go
internal/auth/            middleware, CurrentUser(ctx)
internal/authz/           Can(user, action, resource)
internal/config/          env parsing (the config module)
migrations/               goose SQL files
e2e/                      Playwright package (Node) for browser tests
```

### Generic rule → this stack
| Generic rule | Here |
|---|---|
| Config module | `internal/config`; nothing else calls `os.Getenv` |
| Server boundary | `internal/` packages can't be imported from outside the module |
| Input validation | decode into request structs + `validate` (go-playground/validator) or explicit checks |
| Auth helpers | auth middleware on every non-public route group; `auth.CurrentUser(ctx)` |
| Authorization | `authz.Can()` with the loaded resource, before any write |
| Escape hatches to justify | `//nolint`, ignored errors (`_ =`), `fmt.Sprintf` into SQL, `unsafe` |
