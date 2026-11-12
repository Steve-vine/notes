---
id: 01M77E89EEXY9N5K5HWXMWJDGT
created: 2026-11-12T08:33:40.81443Z
updated: 2026-11-12T12:34:43.73456Z
type: task
title: A record's history calls an archive "Archived", not "Deleted", and shows a file's classification by name, not as a number
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1748
sprint: spsp226
assignee: steve
label:
- bug
priority: low
task_status: active
---
Found in the COM-1738 pre-UAT pass on staging (2026-11-12), on plan entry SAP-70 in E2E Test Company.

**What happens:** two rows in the entry's history are labelled wrongly.
- **Archiving a file** shows the kind "Deleted", although the description underneath correctly says "archived attachment E2E-pentest-report.pdf … — Duplicate of …". Nothing was deleted; it was archived.
- **A file's classification change** shows "Classification: — → 3", the internal number, instead of the classification's name (e.g. Confidential).

**What it should do:**
- An archive row is labelled **Archived**. A permanent delete is labelled **Deleted**.
- Classification changes show the classification's name on both sides.
- Check the same on every record with a history or activity view that shows evidence: assessments, risks, incidents, data subject requests, vendors, the trust centre and Admin ▸ Activity. Archiving is now the same everywhere (COM-1738).

**Done when:** on a plan entry, archiving a file shows an "Archived" row, deleting one for good shows a "Deleted" row, and a classification change reads, for example, "Classification: — → Confidential". The other histories read the same way.