# 05 · Design System

Rule for AI: **use only the tokens and components on this page.** To add one, propose it in a
plan and get approval.

Source of truth: the **Design System** artifact in Claude Design (link in `design/README.md`).
Token values live in `design/tokens.json`, exported from it. Don't edit token values here or in
code; change them in Claude Design and re-export. The tables below are a readable summary.

UI framework / component library: {{e.g. shadcn/ui, Angular Material, Vuetify, React Native kit,
Flutter Material 3, SwiftUI, Jetpack Compose Material 3}}
Where tokens live in code: {{e.g. globals.css, theme.ts, lib/theme/, DesignSystem/, ui/theme/Theme.kt}}

## Tone
Personality: {{e.g. calm, precise, friendly}} · Voice: {{e.g. short sentences, verbs first, no jargon}}

## Color tokens (light + dark; text/background contrast ≥ WCAG AA 4.5:1)
| Token | Light | Dark | Use |
|---|---|---|---|
| background | | | page / screen background |
| foreground | | | body text |
| primary / on-primary | | | primary actions |
| secondary / on-secondary | | | secondary actions |
| muted / muted-foreground | | | subtle surfaces, helper text |
| accent | | | hover/pressed, highlights |
| destructive | | | delete, errors |
| border / input / focus-ring | | | lines, inputs, focus indicator |
| success / warning | | | status |

## Typography
| Token | Size / line-height | Weight | Use |
|---|---|---|---|
| caption | 12/16 | 400 | labels, metadata |
| body-sm | 14/20 | 400 | helper text, tables |
| body | 16/24 | 400 | body (📱 also the minimum for input fields) |
| title | 18–20/28 | 600 | card / section titles |
| headline | 24–28/32 | 600 | screen titles |
Font: {{family}} · Must scale with OS font size settings (Dynamic Type / font scale / browser zoom).

## Spacing, radius, elevation, motion
- Spacing scale (4-based): 4, 8, 12, 16, 24, 32, 48
- Radius: sm {{4}}, md {{8}}, lg {{12}}
- Elevation: none / low (cards) / high (menus, sheets)
- Motion: 150–250 ms ease-out; respect reduced-motion settings
- 📱 Touch targets ≥ 44 pt (iOS) / 48 dp (Android); respect safe areas

## Allowed components
Library components: {{list, e.g. Button, TextField, Select, Checkbox, Switch, Dialog, Sheet / BottomSheet,
Menu, Tabs, Card, List / Table, Badge, Toast / Snackbar, Skeleton, Alert, Avatar, Tooltip}}
App composites: ScreenHeader, EmptyState, ErrorState, LoadingState, DataList, ConfirmDialog{{, OfflineBanner}}

## Patterns
- One primary action per screen.
- Destructive actions → ConfirmDialog naming the object being deleted.
- Forms: visible labels, inline errors on blur/submit, submit shows a pending state, 📱 correct keyboard type and autofill hints.
- Loading: skeletons matching the final layout for content; spinners only for short actions.
- Empty states: explain what goes here + the primary action to create it.
- 📱 Follow platform conventions for navigation, back behavior, sheets and alerts.

## Key screens
Approved in Claude Design (link in `design/README.md`), exported to `design/screens/`:
| Screen (from docs/04) | States exported |
|---|---|
| | filled · empty · loading · error · no-permission |
