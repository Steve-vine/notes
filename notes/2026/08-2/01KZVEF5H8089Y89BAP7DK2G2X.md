---
id: 01KZVEF5H8089Y89BAP7DK2G2X
created: 2026-08-12T16:56:40.232172Z
updated: 2026-08-12T16:56:40.232172Z
type: task
title: Step deadline ignores engine wall_clock_seconds — fixed 1800s Job activeDeadlineSeconds caps every scan
task_status: done
assignee: steve
imported_from: linear
priority: high
label: bug
project: 01KZV767QMFTN9CZ3TPGTSAASD
number: 236
---
## Summary

The dispatcher applies a **fixed** `activeDeadlineSeconds` to every scanner Job from `settings.k8s_scan_default_deadline_seconds` (**default 1800**), **ignoring the engine's** `wall_clock_seconds` **param**. So any engine run configured for more than ~1800s is silently killed by k8s at 1800s, and the kill is an external `activeDeadlineSeconds` termination → no engine error event → `error_code: null` (the silent-failure seen in DEV-…

---

*Excerpt — full description in Linear.*

Imported from Linear [DEV-444](https://linear.app/stevevine/issue/DEV-444/step-deadline-ignores-engine-wall-clock-seconds-fixed-1800s-job)