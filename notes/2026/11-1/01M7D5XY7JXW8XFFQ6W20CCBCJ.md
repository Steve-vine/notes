---
id: 01M7D5XY7JXW8XFFQ6W20CCBCJ
created: 2026-11-14T14:03:39.634279Z
updated: 2026-11-14T14:03:48.092152Z
type: task
title: Building an audit pack no longer runs the worker out of memory, and a pack whose build died is shown as failed (with Try again) instead of "Being built" for good
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1824
sprint: spsp226
assignee: steve
label:
- bug
priority: high
task_status: active
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