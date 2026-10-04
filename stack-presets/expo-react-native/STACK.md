### Stack: Mobile, Expo + React Native
- Expo (latest SDK), React Native, TypeScript strict, Expo Router (file-based navigation)
- UI: a token-based kit (Tamagui, NativeWind + react-native-reusables, or your own themed primitives); follow iOS HIG and Material 3 conventions where they differ
- Data: TanStack Query against your API or BaaS (Supabase / Firebase); Zod for API responses
- Auth: managed provider SDK (Clerk Expo, Supabase Auth, Auth0); tokens in `expo-secure-store` only
- Tests: Jest (`jest-expo`) + React Native Testing Library; Maestro for e2e flows in `.maestro/`
- Builds and releases: EAS Build, EAS Submit, EAS Update (OTA) with channels `preview` and `production`
- Errors: Sentry (`@sentry/react-native`) · Analytics: PostHog / Amplitude
- Dependency manifest: `package.json`, `app.json` / `app.config.ts` · Dependabot ecosystem: `npm`
- Add deps with `npx expo install <pkg>` so versions match the SDK

### Folder layout
```
app/                    Expo Router screens (thin)
src/features/<name>/    components, hooks, api.ts, schema.ts, *.test.tsx
src/components/ui/      themed primitives built on tokens
src/theme/              tokens (color, type, spacing, radius) for light/dark
src/lib/                api client, storage, helpers
src/config.ts           reads public config from expo-constants (the config module)
.maestro/               e2e flows (one per story)
```

### Generic rule → this stack
| Generic rule | Here |
|---|---|
| Config module | `src/config.ts`; only `EXPO_PUBLIC_*` values, which are **public**. No secrets in the app, ever |
| Server boundary | All secret-bearing logic lives in the backend / BaaS (RLS, edge functions). The app is untrusted |
| Input validation | Zod on forms *and* on API responses; the server validates again |
| Auth helpers | provider hooks + a route guard layout in `app/(app)/_layout.tsx` |
| Authorization | enforced on the server; the app only hides UI the user can't use |
| Escape hatches to justify | `any`, `@ts-ignore`, `eslint-disable`, AsyncStorage for anything sensitive |

### CI notes
- `check`, `build` and `audit` run on Ubuntu.
- E2E: set repo variable `E2E_RUNNER=macos-latest` and add a step that builds a simulator dev
  build, or run Maestro through EAS Workflows / Maestro Cloud on preview builds.
- Preview per PR: an EAS Update on a `pr-<number>` branch, opened with a dev client (QR code in the PR).
