---
id: 01M6G7H0NHTF8WWF4V31TYBHXG
created: 2026-11-03T08:13:34.769721Z
updated: 2026-11-03T08:13:43.43473Z
type: task
title: Two sources bringing the same new CVE at once break one source's read, and it then looks busy for three hours
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1533
sprint: s6xh9g1
assignee: steve
priority: medium
task_status: active
---
Found in the sprint 102 pre-UAT (2026-11-03).

## What people see

On staging's first read, CISA's known-exploited list and NVD both brought CVE-2025-66376 at the same moment. NVD's read failed and its Sources row stuck on "Loading history: 8,000 of ~57,517" with no error. Read now refuses ("Compass is reading that source now") for three hours, until the stale-read timeout lets it carry on.

## Fix

- A new item is created with "insert unless it's already there", then loaded, so two sources naming the same new CVE both land on the one item.
- If a read does fail unexpectedly, it's recorded as failed, with its error on the Sources row and its place kept, instead of being left looking busy.

**Cause (technical):** `_Batch.load` added `FeedItem` rows through the session; a concurrent read committing the same key first raised `uq_feed_items_key` at flush. `_run`'s catch-all then read `ctx.source.key` on the failed session, raising `PendingRollbackError` out of the task before `_failed` cleared `reading_since`.

**Chain:** independent (no migration, no API change).

**Done when:** a test with two sources racing on a new key passes; a reader that raises leaves the source not reading, with its error shown; on staging NVD's history load completes.