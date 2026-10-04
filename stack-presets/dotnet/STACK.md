### Stack: .NET (ASP.NET Core)
- .NET 10 LTS, ASP.NET Core (minimal APIs or MVC), EF Core + Npgsql (Postgres), FluentValidation
- Quality: `<Nullable>enable</Nullable>`, `<TreatWarningsAsErrors>true</TreatWarningsAsErrors>`, .NET analyzers, `.editorconfig`, `dotnet format`
- Tests: xUnit + `WebApplicationFactory` (integration), Testcontainers, Playwright for .NET (e2e, tagged `Category=E2E`)
- Auth: managed provider via OpenID Connect / JWT bearer; ASP.NET Core authorization policies · Errors: Sentry or App Insights · Logs: Serilog
- Dependency manifest: `*.csproj`, `Directory.Packages.props` · Dependabot ecosystem: `nuget`

### Folder layout
```
src/Api/                  endpoints (thin), DI wiring, auth setup
src/Application/<Feature>/ commands/queries, validators, DTOs
src/Domain/               entities, rules (no framework references)
src/Infrastructure/       EF Core DbContext, migrations, external clients
tests/                    Unit, Integration, E2E projects
```

### Generic rule → this stack
| Generic rule | Here |
|---|---|
| Config module | strongly typed `IOptions<T>` with `ValidateOnStart()`; secrets from user-secrets locally, Key Vault / host secrets in prod |
| Server boundary | Domain and Application don't reference Api or Infrastructure |
| Input validation | FluentValidation (or DataAnnotations) on every request DTO |
| Auth helpers | `RequireAuthorization()` on route groups; fallback policy = authenticated user |
| Authorization | resource-based `IAuthorizationService.AuthorizeAsync(user, resource, policy)` |
| Escape hatches to justify | `#pragma warning disable`, `!` null-forgiving, `FromSqlRaw`, `[AllowAnonymous]` |
