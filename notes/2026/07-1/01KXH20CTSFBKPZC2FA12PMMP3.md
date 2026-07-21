---
id: 01KXH20CTSFBKPZC2FA12PMMP3
created: 2026-07-14T19:35:05.305362859Z
updated: 2026-07-21T09:53:41.738156Z
type: task
title: Global search UI — ⌘K palette
project: 01KX671DATY39VW6GWK3M2T3DN
number: 72
sprint: syz8rn1
blocked_by:
- 01KXH1ZZF1QCFAHNM2AN7GBC1Y
assignee: steve
label: null
priority: medium
task_status: done
---
The search box **already exists** in `app/frontend/src/components/AppLayout.tsx` — a Mantine `TextInput` in the header wrapped in a `<form onSubmit={submitSearch}>` whose handler currently just fires a notification: *"Search across systems, issues and changes arrives in Phase 5."*

This task makes it real.

## Scope

- Wire the existing box to `GET /api/v1/search` (ISE-71).
- **`@mantine/spotlight`** for the keyboard palette (⌘K / Ctrl-K) — it is part of Mantine and therefore consistent with ADR 0019 (Compass design system), rather than a hand-rolled modal or a new UI dependency. This is a new package in `package.json`.
- Results **grouped by entity type** (systems / issues / changes / findings), each showing enough to disambiguate (severity, status, system).
- Navigate on select, using the hrefs the API returns (ISE-71 reuses ISE-64's resolver, so links stay consistent with assist's citation chips).
- Keep the header box working for mouse users; the palette is the keyboard path. `ui-brief:46` asks for "reachable via keyboard", not "keyboard only".

## Housekeeping

Delete the "arrives in Phase 5" notification — it is the last of the phase-placeholder promises in the UI, and leaving it would be a lie about shipped functionality.

Blocked by: ISE-71.