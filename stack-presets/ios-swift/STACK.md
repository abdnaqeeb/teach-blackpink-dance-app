### Stack: Mobile, native iOS (Swift)
- Swift 6 with strict concurrency, SwiftUI, Observation (`@Observable`), Swift Package Manager
- UI: tokens in an asset catalog (colors) + a `Theme` type (type scale, spacing); follow the Human Interface Guidelines; support Dynamic Type and Dark Mode
- Data: `URLSession` + `Codable` against your API or BaaS; SwiftData only for local cache
- Auth: managed provider SDK or Sign in with Apple; tokens in Keychain only
- Quality: `swift format`, SwiftLint `--strict`, warnings as errors
- Tests: Swift Testing / XCTest (`AppTests`), XCUITest (`AppUITests`) or Maestro for e2e; snapshot tests for key screens
- Builds and releases: Xcode Cloud or fastlane → TestFlight → App Store with phased release
- Errors: Sentry or Crashlytics · Privacy: `PrivacyInfo.xcprivacy` manifest kept current
- Dependency manifest: `Package.swift` / `Package.resolved` · Dependabot ecosystem: `swift`

### Folder layout
```
App/                    app entry, root navigation
Features/<Name>/        Views, ViewModel (@Observable), Service, Models
DesignSystem/           Theme, tokens, reusable components
Core/                   APIClient, AuthSession, Keychain, Config (the config module)
AppTests/               unit tests
AppUITests/             UI / e2e tests
```

### Generic rule → this stack
| Generic rule | Here |
|---|---|
| Config module | `Core/Config.swift` reading `Info.plist` values set per build configuration (`.xcconfig`); values are **public**. No secrets in the app |
| Server boundary | secrets and authorization live on the backend. The app is untrusted |
| Input validation | validate in the ViewModel; decode API responses strictly with `Codable`; the server validates again |
| Auth helpers | `AuthSession` observable drives root navigation |
| Authorization | enforced on the server; the app only hides UI |
| Escape hatches to justify | force unwrap `!`, `try!`, `@unchecked Sendable`, `UserDefaults` for anything sensitive, ATS exceptions |
