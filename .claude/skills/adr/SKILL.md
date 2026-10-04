---
name: adr
description: Record an architecture decision as a new ADR in docs/adr/.
argument-hint: "<decision title>"
disable-model-invocation: true
---

Create a new ADR for: **$ARGUMENTS**

1. Find the next number in `docs/adr/` (4 digits) and copy `docs/adr/0000-template.md`.
2. Fill in context, at least two real options with trade-offs, the decision, and consequences,
   using what we discussed in this conversation. Set status to `proposed`.
3. List any rules that should be added to `CLAUDE.md`, and propose the exact lines (don't edit
   CLAUDE.md yourself).
