---
id: 01M5PST2VNRNYVP9VB2X7KHN66
created: 2026-10-24T11:12:51.061233Z
updated: 2026-10-24T11:12:57.365565Z
type: task
title: pypdf is held at 6.21.2 or later, so the dependency scan passes again (CVE-2026-115572, -115580, -115585)
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1278
sprint: shig2cj
assignee: steve
label:
- chore
priority: high
task_status: active
---
Sprint 85, DDQ-2. Found while shipping COM-1275 (2026-10-24): every PR's dependency scan now fails on three advisories published against pypdf 6.21.1 (CVE-2026-115572, CVE-2026-115580, CVE-2026-115585), fixed in 6.21.2 (released 2026-10-21). pypdf reads PDFs Compass is given (evidence, DDQ files), so the fix matters beyond CI.

**Chain:** independent (dependency only; no migration, no API change)

## What changes

- Nothing anyone sees. The backend's pypdf floor rises from 6.21.1 to 6.21.2 and the lock file moves with it.

**Done when:** the dependency scan passes on a PR and the PDF tests still pass.