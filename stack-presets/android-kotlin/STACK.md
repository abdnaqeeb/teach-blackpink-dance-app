### Stack: Mobile, native Android (Kotlin)
- Kotlin, Jetpack Compose, Material 3, Navigation Compose, Hilt, Coroutines + Flow, Room (local cache only)
- UI: tokens in a `Theme.kt` (color scheme, typography, shapes, spacing), dynamic color optional; follow Material 3
- Data: Retrofit/Ktor + kotlinx.serialization against your API or BaaS
- Auth: managed provider SDK or Credential Manager; tokens in EncryptedSharedPreferences / DataStore + Keystore
- Quality: ktlint, detekt, Android Lint with `warningsAsErrors`, `allWarningsAsErrors` for Kotlin
- Tests: JUnit + Turbine (unit), Compose UI tests / Espresso or Maestro (e2e), Roborazzi/Paparazzi screenshots
- Builds and releases: Gradle Play Publisher or fastlane → Play internal testing → staged production rollout
- Errors: Sentry or Crashlytics · Play Console data safety form kept current
- Dependency manifest: `gradle/libs.versions.toml`, `*.gradle.kts` · Dependabot ecosystem: `gradle`

### Folder layout
```
app/src/main/java/<pkg>/
  ui/<feature>/         Screen composables, ViewModel
  ui/theme/             tokens → MaterialTheme
  data/<feature>/       repository, API service, DTOs
  domain/               models, use cases (no Android imports)
  core/                 auth session, secure storage, BuildConfig wrapper (the config module)
app/src/test/           unit tests
app/src/androidTest/    UI / e2e tests
```

### Generic rule → this stack
| Generic rule | Here |
|---|---|
| Config module | `BuildConfig` fields per build type, wrapped in `core/Config.kt`; values are **public**. No secrets in the APK |
| Server boundary | secrets and authorization live on the backend. The app is untrusted |
| Input validation | validate in the ViewModel; strict deserialization; the server validates again |
| Auth helpers | auth state `StateFlow` drives the nav graph start destination |
| Authorization | enforced on the server; the app only hides UI |
| Escape hatches to justify | `!!`, `@Suppress`, `android:exported="true"` without need, cleartext traffic, plain SharedPreferences for anything sensitive |
