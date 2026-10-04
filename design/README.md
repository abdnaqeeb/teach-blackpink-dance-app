# Design

The visual source of truth lives in **Claude Design** (Claude app). This folder is the copy
Claude Code works from. Change designs in Claude Design first, then re-export here.

| What | Link | Last exported |
|---|---|---|
| Prototype (Phase 2, disposable) | {{link}} | — |
| Wireframes (Phase 4, optional) | {{link}} | — |
| Design System (Phase 5) | {{link}} | {{date}} |
| Key screens (Phase 5) | {{link}} | {{date}} |

## Files
- `tokens.json`: tokens exported from the Design System (colors light/dark, typography, spacing,
  radius, elevation, motion). Mapped into code in Phase 7. Don't edit by hand.
- `screens/`: approved screens exported as images, named `<screen>--<state>.png`
  (states: filled, empty, loading, error, no-permission, offline).
