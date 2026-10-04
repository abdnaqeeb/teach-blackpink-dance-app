# Stack presets

A preset connects the stack-agnostic workflow to one concrete stack. Each preset folder has:

| File | Copy to | Purpose |
|---|---|---|
| `commands.env` | `.project/commands.env` | The commands behind `./scripts/task.sh <task>`, the edit hook and the Stop hook |
| `mise.toml` | `mise.toml` (repo root) | Tool versions, so local machines and CI use the same toolchain ([mise](https://mise.jdx.dev)) |
| `STACK.md` | paste into the **Stack specifics** section of `CLAUDE.md` | Default libraries, folder layout, and how the generic rules map to this stack |

## Available presets
| Preset | Kind | Default stack |
|---|---|---|
| `node-typescript` | Web full-stack | Next.js, React, TypeScript, Postgres |
| `python` | Backend / API | FastAPI, SQLAlchemy, Alembic, uv, ruff, mypy, pytest |
| `go` | Backend / API | Go stdlib + chi, sqlc, goose, golangci-lint |
| `dotnet` | Backend / web | ASP.NET Core, EF Core, xUnit |
| `java` | Backend / web | Spring Boot, Gradle, Flyway, JUnit 5 |
| `expo-react-native` | Mobile (iOS + Android) | Expo, React Native, TypeScript, Jest, Maestro, EAS |
| `flutter` | Mobile (iOS + Android) | Flutter, Dart, Riverpod, Maestro or integration_test |
| `ios-swift` | Mobile (iOS) | SwiftUI, Swift Testing / XCTest, SwiftLint |
| `android-kotlin` | Mobile (Android) | Jetpack Compose, Kotlin, Gradle, ktlint, detekt |

## Projects with several parts (e.g. a mobile app plus an API)
Use one `commands.env` and run each part's command in its own folder:
```bash
LINT_CMD='(cd apps/mobile && npm run lint) && (cd services/api && uv run ruff check .)'
TEST_CMD='(cd apps/mobile && npm test) && (cd services/api && uv run pytest -q)'
```
Merge the `mise.toml` tool lists, and paste both `STACK.md` files into CLAUDE.md under headings.

## Making a new preset
Copy the closest preset and fill in every `*_CMD`. Leave a command empty if it doesn't apply;
the task runner skips it. Keep `STOP_CHECKS` fast (under ~1 minute), because it runs every time
Claude finishes. Check it with `./scripts/task.sh list` and `./scripts/task.sh check`.
