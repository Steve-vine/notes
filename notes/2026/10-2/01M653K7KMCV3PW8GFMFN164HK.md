---
id: 01M653K7KMCV3PW8GFMFN164HK
created: 2026-10-30T00:33:14.35637Z
updated: 2026-10-30T00:37:44.186526Z
type: task
title: Continuity is blank for a Viewer or an Assessor — the menu offers it, but its figures come from the Risk Assessments module they can't read
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1454
sprint: s5pn06h
comments:
- id: 01M653VEC98GAWD3G2TH825B88
  author: Steve Vine
  at: 2026-10-30T00:37:43.433483Z
  text: |-
    Fixed: PR #1468 (auto-merge on).

    - Continuity now shows in the menu only for people who can see Risk Assessments.
    - Typing its address without that permission gives the usual "you need permission" message, not an empty page.
    - Nobody's access changes: the data was already refused.
    - Tests: a new menu test, and all 61 test files that touch the menu or Continuity pass.
assignee: steve
label:
- bug
priority: medium
task_status: review
---
Defect found by the browser suite (COM-1449), sprint 99, on staging 2026-10-30.

## What happens

Signed in as E2E Viewer or E2E Assessor, **Posture ▸ Continuity** is in the menu. Opening it shows the heading and nothing else. The page's data request is refused, because Continuity is built from the approved business impact analysis, which lives in Risk Assessments, and neither role can see Risk Assessments.

## The fix

Continuity appears in the menu, and opens, only for people who can see Risk Assessments, as the data already requires. Viewers and Assessors no longer see an empty page. Nobody gains access to anything.

**Chain:** independent (screen only).

**Done when:** the browser suite's "every screen opens" is green for the Viewer and the Assessor, and Admin A still has Continuity.