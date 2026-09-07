---
id: 01M1YVSWATYVMHWZV07XX5WYXT
created: 2026-09-07T21:18:49.690109Z
updated: 2026-09-07T21:30:11.503294Z
type: task
title: 'One headline box: compliance, tier, maturity and coverage rings, open gaps as a number'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 617
sprint: sqc2gdq
comments:
- id: 01M1YWEP5FX8S5QJA6AR15M8NE
  author: Steve Vine
  at: 2026-09-07T21:30:11.503136Z
  text: |-
    Done — merged to main in PR #617 and deployed to staging.

    The Dashboard's top row is one box: the Compliance ring, then Essential / Expected / Specialised, then Average maturity as a ring (the mean out of 5, on the maturity colour scale), Coverage as a ring, and Open gaps as a number that still links to the gap list. Every ring is the same size with its label and supporting line underneath. The four tiles and the separate "Compliance by tier" card are gone.
assignee: steve
label:
- improvement
priority: medium
task_status: active
---
Smoke-test feedback on COM-607. The Dashboard's top row becomes a single box holding, in order: the Compliance ring; the Essential, Expected and Specialised rings; Average maturity, now a ring too; Coverage, also a ring; and Open gaps, kept as a number.

The four separate tiles and the separate "Compliance by tier" card go. Each ring keeps its label and its supporting line underneath, and the rings share the size and colour language the compliance ring already uses — maturity on the maturity colour scale, out of 5.

Fixed forward from main (ADR 0041).