---
id: 01M658KNT2BHKQKBRQ7MZWYHD7
created: 2026-10-30T02:00:51.778983Z
updated: 2026-10-30T17:09:07.674511Z
type: task
title: A reviewer without View contracts gets a refused request for the contract topics when they open a review — the topic picker shows disabled and the browser logs an error
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1462
sprint: s2v7d6y
assignee: steve
label:
- bug
priority: low
task_status: active
---
Defect in COM-1440, found by Claude's pre-UAT pass (COM-1452) on staging, 2026-10-30.

## What happens

E2E Viewer was added as a reviewer by an @mention on CR-1. When they open the review, a background request for the contract topics is refused (403). The topic picker shows disabled. Nothing visible breaks, but the request fails and an error is logged every time. The browser suite treats that as a broken screen.

## Expected

A named reviewer can read the topics the review's clauses are tagged with, as they read the review itself. Or the page doesn't ask for them when the reader can't change topics.

The same class of fault as COM-1455.

**Chain:** independent unless the fix opens the topics read to reviewers (then API).