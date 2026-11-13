---
id: 01M79F35NDBMJ1BX4E99ZWNX6A
created: 2026-11-13T03:26:50.541696Z
updated: 2026-11-13T10:04:27.565029Z
type: task
title: Record a vulnerability's system list doesn't offer deleted technology assets
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1784
sprint: spsp226
assignee: steve
label:
- bug
priority: medium
task_status: active
---
Found in the sprint 116 round-4 pre-UAT re-check on staging (ee4bff02, 2026-11-13).

**What happens:** Record a vulnerability's System list offers technology assets that have been deleted — e.g. "E2E UAT4 1780 dup" straight after it was deleted as a duplicate (its page says "Technology asset not found"), and "E2E pre-UAT 1758 duplicate", "E2E pre-UAT 1766 duplicate". The pen-test finding page's system picker wasn't checked and may do the same.

**What it should do:** only live (not deleted) technology assets are offered, in Record a vulnerability, the pen-test finding picker and anywhere else a system is chosen for a vulnerability.

**Done when:** on staging in E2E Test Company, a just-deleted asset isn't offered in either picker; a test covers it. Independent.