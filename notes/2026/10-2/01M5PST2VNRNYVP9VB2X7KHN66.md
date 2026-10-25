---
id: 01M5PST2VNRNYVP9VB2X7KHN66
created: 2026-10-24T11:12:51.061233Z
updated: 2026-10-25T16:24:23.621439Z
type: task
title: pypdf is held at 6.21.2 or later, so the dependency scan passes again (CVE-2026-115572, -115580, -115585)
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1278
sprint: shig2cj
comments:
- id: 01M5PVZ4ZYNP2B7NESVGBW583N
  author: Steve Vine
  at: 2026-10-24T11:50:34.238415Z
  text: |-
    Done — merged in #1286 (4e166586).

    What changed: nothing anyone sees. pypdf is now held at 6.21.2 or later, which fixes the three advisories that were failing every PR's dependency scan. pypdf is what reads and combines PDFs (evidence, DDQ packs, review records, trust centre watermarks), so this matters for the app as well as for CI.

    Found while shipping COM-1275 and added to this sprint, as COM-1272 was in sprint 84.

    To check on staging: nothing specific; any PDF download (a review record or a trust centre document) still works.

    Separately: one evidence search test failed on this PR for a reason unrelated to the change, and passed when re-run. I've logged it in the backlog as COM-1279.
assignee: steve
label:
- chore
priority: high
task_status: done
---
Sprint 85, DDQ-2. Found while shipping COM-1275 (2026-10-24): every PR's dependency scan now fails on three advisories published against pypdf 6.21.1 (CVE-2026-115572, CVE-2026-115580, CVE-2026-115585), fixed in 6.21.2 (released 2026-10-21). pypdf reads PDFs Compass is given (evidence, DDQ files), so the fix matters beyond CI.

**Chain:** independent (dependency only; no migration, no API change)

## What changes

- Nothing anyone sees. The backend's pypdf floor rises from 6.21.1 to 6.21.2 and the lock file moves with it.

**Done when:** the dependency scan passes on a PR and the PDF tests still pass.