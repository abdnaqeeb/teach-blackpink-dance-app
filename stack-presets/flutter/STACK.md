### Stack: Mobile, Flutter
- Flutter stable, Dart 3 with sound null safety, `go_router`, Riverpod for state, `freezed` + `json_serializable` for models
- UI: a `ThemeData` built from tokens (`lib/theme/`), Material 3 + adaptive widgets for iOS where they matter
- Data: your API or BaaS (Supabase / Firebase); validate and parse every response into typed models
- Auth: managed provider SDK; tokens in `flutter_secure_storage` only
- Lints: `very_good_analysis` or `flutter_lints` with `strict-casts`, `strict-inference`, `strict-raw-types`
- Tests: `flutter test` (unit + widget), golden tests for key screens, `integration_test` or Maestro for e2e
- Builds and releases: Codemagic or fastlane → TestFlight / Play internal testing; Shorebird for OTA patches if needed
- Errors: Sentry or Firebase Crashlytics
- Dependency manifest: `pubspec.yaml` + `pubspec.lock` · Dependabot ecosystem: `pub`

### Folder layout
```
lib/main.dart             bootstrapping only
lib/app/                  router, app widget
lib/features/<name>/      presentation/ (widgets), application/ (providers), data/ (repos, DTOs)
lib/theme/                tokens → ThemeData (light/dark)
lib/core/config.dart      --dart-define values (the config module; all public)
test/                     unit + widget + golden tests
integration_test/         e2e flows (or .maestro/)
```

### Generic rule → this stack
| Generic rule | Here |
|---|---|
| Config module | `lib/core/config.dart` with `String.fromEnvironment`; values are **public**. No secrets in the app |
| Server boundary | secrets and authorization live on the backend / BaaS (RLS, functions). The app is untrusted |
| Input validation | form validators in the UI; typed parsing of all API responses; the server validates again |
| Auth helpers | router `redirect` guard driven by the auth state provider |
| Authorization | enforced on the server; the app only hides UI |
| Escape hatches to justify | `// ignore:`, `dynamic`, `!` on nullable values, `SharedPreferences` for anything sensitive |

### CI notes
- `check`, `audit` and the Android debug `build` run on Ubuntu (GitHub's Ubuntu runners include the Android SDK).
- iOS builds and iOS e2e need a macOS runner (`CI_RUNNER` / `E2E_RUNNER` repo variables).
