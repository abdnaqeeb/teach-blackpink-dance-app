### Stack: Python (FastAPI)
- Python 3.13, uv for dependencies, FastAPI, Pydantic v2, SQLAlchemy 2 + Alembic, Postgres
- Quality: ruff (format + lint), mypy `strict = true`
- Tests: pytest + httpx `AsyncClient` (integration), pytest-playwright (e2e, if there's a web UI)
- Auth: managed provider (verify its JWTs; never store passwords yourself) · Errors: Sentry · Logs: structlog
- Dependency manifest: `pyproject.toml` + `uv.lock` · Dependabot ecosystem: `uv` (or `pip`)

### Folder layout
```
app/main.py               app factory, middleware, routers
app/api/<feature>.py      routes only (thin): validate → auth → authz → call service
app/features/<feature>/   service.py, schemas.py (Pydantic), repo.py
app/core/config.py        pydantic-settings (the config module)
app/core/auth.py          current_user dependency
app/core/authz.py         can(user, action, resource)
app/db/                   models, session; migrations in alembic/
tests/                    unit + integration; tests/e2e/ for browser tests
```

### Generic rule → this stack
| Generic rule | Here |
|---|---|
| Config module | `app/core/config.py` (`BaseSettings`); nothing else reads `os.environ` |
| Server boundary | everything is server-side; keep secrets out of responses and logs |
| Input validation | Pydantic models on every route; `extra="forbid"` on input models |
| Auth helpers | `Depends(current_user)` on every non-public route |
| Authorization | `can()` called in the route or service with the loaded object |
| Escape hatches to justify | `# type: ignore`, `# noqa`, `Any`, raw SQL via `text()` |
