---
id: 01KZV9PEXKE4KVAQEPKNNJBMD4
created: 2026-08-12T15:33:16.339753Z
updated: 2026-08-12T15:33:16.339753Z
type: task
title: 'Mobile UX: swipe actions, bottom-sheet triage, card layouts for remaining lists'
assignee: steve
label:
- follow_up
- feature
priority: low
task_status: backlog
imported_from: linear
project: 01KZV767QMFTN9CZ3TPGTSAASD
number: 1
---
## Context

[DEV-64](https://linear.app/stevevine/issue/DEV-64/mobile-layout-for-the-frontend) shipped a **focused responsive pass** (M12): sidebar→drawer on mobile, and card layouts for the two highest-traffic lists (findings, assets) via `useIsMobile`. The richer mobile-UX vision from the original DEV-64 was explicitly deferred — this issue tracks it.

## Scope (deferred from DEV-64)

* **Swipe actions** on finding/asset cards (e.g. swipe to triage/assign).
* **Bottom-sheet triage** UI for findings on mobile.
* **Card layouts for the remaining tables**: workflows, workflow runs, scope, custom settings (the lower-traffic lists still render their `table` inside a horizontal scroll on mobile).
* Pass over forms/modals (project/scope/workflow create) for small-screen ergonomics.

## Notes

Builds on the `useMediaQuery`/`useIsMobile` hook + the `MobileNav` drawer + `nav-items.ts` from DEV-64. Low priority — the focused pass already makes the app usable on a phone for the primary triage flows.

---

Imported from Linear [DEV-698](https://linear.app/stevevine/issue/DEV-698/mobile-ux-swipe-actions-bottom-sheet-triage-card-layouts-for-remaining)