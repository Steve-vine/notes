---
id: 01M7D5XY7JXW8XFFQ6W20CCBCJ
created: 2026-11-14T14:03:39.634279Z
updated: 2026-11-14T14:55:02.739433Z
type: task
title: Building an audit pack no longer runs the worker out of memory, and a pack whose build died is shown as failed (with Try again) instead of "Being built" for good
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1824
sprint: spsp226
comments:
- id: 01M7D8VWP4GSBXJVEDEX649CAS
  author: Steve Vine
  at: 2026-11-14T14:54:58.243788Z
  text: |-
    Built — PR #1821 (3b23c148), auto-merge on. Migration 0853_pack_build_heartbeat; API gains Try again and a pack's failure reason; ADR 0122 §12 amended (2026-11-14).

    Cause (not COM-1814): COM-1804 made a capture's page show every kept field. CHK-2 keeps 103 fields, so its page lists each item's fields in turn — up to 20,000 values — all laid out as one PDF document, which the PDF engine keeps entirely in memory until it writes (~30–70 KB a cell). The staging log matches: four 25-page captures, then a fifth killed after 234+ pages. The worker's 1536Mi covers the main process and two children, so 1.4 GB in one child kills the container.

    Measured peak memory: a repro pack (one control, 5 captures × 300 items × 103 fields, built by the real task) 1,405 MiB on main → 521 MiB with this change, in half the time; one 100-item page 754 → 375 MiB; one 300-item page 1,240 → 386 MiB.

    What you now see:
    - A pack for a control with a few large captures builds. Each capture's page is laid out a part at a time and joined, so the page itself is unchanged (same items, COM-1814's column names, the CSV beside it); a page that fits in one part is byte-for-byte what it was. Pages filed in the register use the same path.
    - A pack whose build dies part-way, or never starts, shows "Couldn't be built" with the reason where known (e.g. "Its build stopped part-way: the worker building it was restarted.") and Try again — for anyone who can make packs; it's still built as its maker, only the maker downloads it, and Try again is in Activity. Nothing half-built is offered. Polaris's pack listing gives the reason (it can't retry; Try again is on screen only).
    - The stuck staging pack b46f0550 will be marked Couldn't be built by the sweep once deployed.

    Choices: worker memory limit unchanged; how much a page shows unchanged (a 100-field capture still makes ~500 PDF pages, now within memory); timings — heartbeat every 30 s, failed after 3 minutes quiet or 30 minutes never picked up (if it then builds anyway, it becomes ready).

    Tests: audit pack integration (9, incl. 3 new for recovery and Try again) + 40 in neighbouring files; new page-parts unit tests incl. a real render; unit suite 2384 passed; ruff/mypy/eslint/tsc/prettier/full vitest clean; drift OK.

    For Steve on staging: a pack for ACC.13, 1–14 Nov in E2E Test Company builds; b46f0550 shows Couldn't be built.
assignee: steve
label:
- bug
priority: high
task_status: review
---
## What happened

Found in Claude's pre-UAT pass of COM-1814 on staging 53965a3b (2026-11-14), E2E Test Company, as E2E Admin A.

An audit pack was started through the API at 13:45:21: core controls, ACC.13 only, 1–14 Nov, PDF and zip (pack b46f0550-3dbc-45b0-9c70-6544caf50b26). The worker started at once and logged 234+ PDF layout pages. At 13:46:08 the worker container was **OOMKilled** (exit 137, limit 1536Mi). The pack never restarted, and 20+ minutes later it was still "Being built" in Audit ▸ Packs and through Polaris. The worker restarted and is running again.

A pack by Admin B on 6 Nov for 1–6 Nov (3 files) built fine. COM-1814 changed packs: each capture's page is rebuilt with the check's column names, and each capture now also gets a CSV. ACC.13's CHK-2 has 5 filed captures (6 Nov) of ~100 fields. Suspect: rebuilding capture pages as PDF inside the pack (WeasyPrint) holds far more in memory than copying the filed pages did.

## What people see

- A pack for a control with a handful of large captures builds within the worker's memory and finishes. Its capture pages and CSV headers use the check's column names (COM-1814).
- If a pack's build dies part-way (the worker restarted, or an error), the pack doesn't stay "Being built". Within a few minutes it shows **Couldn't be built**, with the reason where known, and **Try again** for whoever can build packs. Nothing half-built is offered for download.
- The stuck staging pack b46f0550-… is cleared by this (shown as couldn't be built), not by hand.

## For the builder

- Reproduce first: seed a check with 5 captures of ~100 fields × a few hundred rows and build a pack for its control, measuring peak memory on main before and after COM-1814 (git log: COM-1814 #1814). Say what you find.
- Fix the cause (e.g. render one capture at a time and release it, stream into the zip, or don't re-render pages that only need new headers), not the limit. Don't raise the worker's memory limit as the fix.
- The stale-build recovery needs a way to tell a build that's still running from one whose worker died (a heartbeat/started-at with a timeout, or the task's own state). Celery tasks must stay idempotent and take IDs (CLAUDE.md). A new Celery task needs a label in core/task_labels.py.

## Done when

- The repro pack builds under the worker's limit, with the measured peak in the PR.
- A pack whose build is killed shows Couldn't be built with Try again, and Try again builds it.
- Tests for the stale-build recovery and the memory-safe path; Browser smoke still green.
- On staging, a pack for ACC.13 1–14 Nov in E2E Test Company builds, and the stuck pack shows Couldn't be built.

**On the chain** only if it needs a migration (e.g. a heartbeat column); otherwise independent. Fix-forward from COM-1814.