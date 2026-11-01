---
id: 01M6AHX2N86YXS25G1KRQQG4C5
created: 2026-11-01T03:19:29.192408Z
updated: 2026-11-01T08:40:51.257969Z
type: task
title: 'Bug: a gap in the portal shows its control''s guidance as raw text — "**What this means:**" and dashes instead of bold headings and a list'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1497
sprint: snvd637
comments:
- id: 01M6AJJG38WK690J2BANFXMV2M
  author: Steve Vine
  at: 2026-11-01T03:31:11.080344Z
  text: 'Done, merged to main in PR #1514. On a portal gap, The control card now lays the guidance out the same way as inside Compass: "What this means", "What good looks like" as ticked lines, and the evidence. There are no more raw `**` marks or dashes. A test covers it. It goes to staging with COM-1498, and I''ll check G-46 there.'
- id: 01M6AKMYT0DET1A5BRYQ6V6DAM
  author: Steve Vine
  at: 2026-11-01T03:50:00.255927Z
  text: |-
    Pre-UAT (Claude, 2026-11-01, staging 0eb09923, Browser smoke green): **Passed**.

    As E2E Asset Owner, G-46's control card now shows:
    - the INS.10 title;
    - "What this means" with its paragraph;
    - "What good looks like" with five lines;
    - "Evidence to collect".

    No `**` marks or dashes are left.

    Screenshot: ~/compass-uat/sprint-80/COM-1497/01-guidance-laid-out.png
assignee: steve
label:
- bug
priority: medium
task_status: done
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