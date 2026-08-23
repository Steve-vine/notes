---
id: 01M0N872DTNW5GKWM7HF8GNF25
created: 2026-08-22T17:27:38.68223Z
updated: 2026-08-23T06:44:22.049513Z
type: task
title: Vendor Portal content wider and centred
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 369
sprint: sbph5q5
comments:
- id: 01M0NE2VGSKEGJ1WG0QD8Z7PNZ
  author: Steve Vine
  at: 2026-08-22T19:10:11.992894Z
  text: |-
    Done — PR #368, merged to main.

    - New **`PortalContent`** wrapper: 1080 (up from 720), centred, used by both the landing list (`VendorPortalApp`) and the fill form (`VendorPortalAssessmentPage`). A component rather than a shared constant, as the task asked for one value — two `maw` props agreeing today is not the same as agreeing after one is edited, and the wrapper owns the centring too, which was the half that was actually missing.
    - Narrow states left narrow: the dead end and "nothing to complete" (`maw={420}`) untouched; the "not available" message (`maw={520}`) was left-aligned, so it is now centred like its neighbours — centred, not widened.
    - **On the controls caveat:** answer fields keep a 760 measure inside the wider column. A single-line text box run to 1080 is genuinely harder to read and to check over; the page furniture (title, progress, and COM-368's review step) uses the full width.
    - Test: both screens render the same `data-portal-content` wrapper with identical classes — the property that matters is that there is one column, not two magic numbers.
assignee: steve
label:
- improvement
priority: medium
task_status: done
---
The Vendor Portal's main content is capped at `maw={720}` and sits left-aligned. Make it ~50% wider and centre it in the viewport.

- [ ] `VendorPortalApp.tsx:110` (the open-assessments landing list) and `VendorPortalAssessmentPage.tsx:56` (the fill form): `maw={720}` → `maw={1080}`, centred (`mx="auto"` or a Mantine `Container`) — one shared value/wrapper rather than two magic numbers, since the two screens should agree.
- [ ] Leave the deliberate narrow bits narrow: the `maw={520}`/`maw={420}` dead-end and message states are reading widths, not layout — centre them if they aren't already, don't widen.
- [ ] Check the form controls still look right at the new width (inputs shouldn't stretch edge-to-edge illegibly; the review step from COM-368 inherits whatever this sets).