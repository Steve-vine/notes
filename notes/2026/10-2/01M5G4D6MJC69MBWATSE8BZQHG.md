---
id: 01M5G4D6MJC69MBWATSE8BZQHG
created: 2026-10-21T21:03:22.258819Z
updated: 2026-10-21T21:17:29.914566Z
type: task
title: The PDF library is updated past a security advisory published today
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1218
sprint: sno3i7m
comments:
- id: 01M5G571QTHQYZWA7VQM8P8RCS
  author: Steve Vine
  at: 2026-10-21T21:17:29.21052Z
  text: |-
    Done — merged in PR #1215.

    - The PDF library (pypdf) is updated from 6.20.1 to 6.21.1, past the advisory published today (CVE-2026-113786). The version Compass accepts is raised to match.
    - No change anyone will see. It unblocks the dependency scan, which was failing every PR, this sprint's included.

    My calls: 6.21.1 is the oldest release with the fix, following the same rule as COM-1196.
assignee: steve
label:
- chore
priority: high
task_status: review
---
Sprint 82, Evidence. Found building COM-1199: every PR's dependency scan fails on a pypdf advisory published today, so nothing can merge until it's fixed.

**Chain:** independent

## What changes

pypdf 6.20.1 → 6.21.1, the oldest release with the fix for CVE-2026-113786. The floor in `pyproject.toml` goes to `>=6.21.1`. No behaviour change.

**Done when:** the dependency scan is green on main and on the sprint's PRs.