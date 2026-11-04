---
id: 01M6G7H0NHTF8WWF4V31TYBHXG
created: 2026-11-03T08:13:34.769721Z
updated: 2026-11-04T07:46:09.185983Z
type: task
title: Two sources bringing the same new CVE at once break one source's read, and it then looks busy for three hours
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1533
sprint: s6xh9g1
comments:
- id: 01M6GYTNKW0PEJCSM7TNP8PM9V
  author: Steve Vine
  at: 2026-11-03T15:00:48.380748Z
  text: |-
    Done: PR #1548 merged (131f831e), deployed to staging at 08:44.

    - New items are created with "insert unless it's already there", in a fixed order, so two sources bringing the same new CVE at once share one item.
    - A read that breaks unexpectedly is now recorded as failed, with its error on the Sources row, instead of looking busy for three hours.

    Pre-UAT (staging): **Passed**
    - NVD's read that stalled before the fix carried on from its checkpoint at 11:13, once its old "reading" mark expired, and loaded the full year by 11:50 (101,677 items).
    - In the four hours since, 22 source reads ran alongside each other: no unique-key errors, no crashed reads, and the only "not ok" is the CISA alerts feed saying it's unavailable (COM-1537).
assignee: steve
label: null
priority: medium
task_status: done
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