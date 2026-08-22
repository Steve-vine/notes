---
id: 01M0N872DTNW5GKWM7HF8GNF25
created: 2026-08-22T17:27:38.68223Z
updated: 2026-08-22T18:44:17.559241Z
type: task
title: Vendor Portal content wider and centred
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 369
sprint: sbph5q5
assignee: steve
label:
- improvement
priority: medium
task_status: active
---
The Vendor Portal's main content is capped at `maw={720}` and sits left-aligned. Make it ~50% wider and centre it in the viewport.

- [ ] `VendorPortalApp.tsx:110` (the open-assessments landing list) and `VendorPortalAssessmentPage.tsx:56` (the fill form): `maw={720}` → `maw={1080}`, centred (`mx="auto"` or a Mantine `Container`) — one shared value/wrapper rather than two magic numbers, since the two screens should agree.
- [ ] Leave the deliberate narrow bits narrow: the `maw={520}`/`maw={420}` dead-end and message states are reading widths, not layout — centre them if they aren't already, don't widen.
- [ ] Check the form controls still look right at the new width (inputs shouldn't stretch edge-to-edge illegibly; the review step from COM-368 inherits whatever this sets).