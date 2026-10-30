---
id: 01M653K7KMCV3PW8GFMFN164HK
created: 2026-10-30T00:33:14.35637Z
updated: 2026-10-30T00:33:14.35637Z
type: task
title: Continuity is blank for a Viewer or an Assessor — the menu offers it, but its figures come from the Risk Assessments module they can't read
task_status: active
label: bug
priority: medium
assignee: steve
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1454
---
Defect found by the browser suite (COM-1449), sprint 99, on staging 2026-10-30.

## What happens

Signed in as E2E Viewer or E2E Assessor, **Posture ▸ Continuity** is in the menu. Opening it shows the heading and nothing else. The page's data request is refused, because Continuity is built from the approved business impact analysis, which lives in Risk Assessments, and neither role can see Risk Assessments.

## The fix

Continuity appears in the menu, and opens, only for people who can see Risk Assessments, as the data already requires. Viewers and Assessors no longer see an empty page. Nobody gains access to anything.

**Chain:** independent (screen only).

**Done when:** the browser suite's "every screen opens" is green for the Viewer and the Assessor, and Admin A still has Continuity.