---
id: 01M6AHX2N86YXS25G1KRQQG4C5
created: 2026-11-01T03:19:29.192408Z
updated: 2026-11-01T03:19:39.881455Z
type: task
title: 'Bug: a gap in the portal shows its control''s guidance as raw text — "**What this means:**" and dashes instead of bold headings and a list'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1497
sprint: snvd637
assignee: steve
label:
- bug
priority: medium
task_status: active
---
Sprint 80, Update user portal. Found in Claude's pre-UAT pass on 2026-11-01 (COM-1492).

## What people see

- On the portal's gap page (My gaps ▸ a gap), **The control** card shows the guidance as written, with `**` marks and `-` dashes, e.g. "**What this means:** Technical controls…".
- Inside Compass the same guidance is laid out properly: "What this means" as a paragraph, "What good looks like" as ticked lines, and the evidence in a card.
- After the fix, the portal shows it the same way as inside Compass.

Screenshot: `~/compass-uat/sprint-80/COM-1492/02-gap-page.png`.

## Notes (technical)

- `PortalGapPage.tsx` renders `gap.control_description` as plain text. Use the shared `Guidance` component (`components/kit/Guidance.tsx`), as the internal control pages do.

**Chain:** independent (frontend only).

**Done when:** on staging, signed in as E2E Asset Owner, G-46's control card shows the guidance laid out with headings and ticked lines, with no `**` marks.