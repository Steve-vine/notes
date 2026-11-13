---
id: 01M7BE6656XNCEGR2SA2VEM9EJ
created: 2026-11-13T21:49:29.638018Z
updated: 2026-11-13T21:49:32.549294Z
type: task
title: 'Dependency scan: move dnspython to 2.9.2 (CVE-2026-128089) so PR checks go green again'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1807
sprint: spsp226
assignee: steve
label:
- chore
priority: high
task_status: active
---
Found 2026-11-13 ~21:50 GMT while landing sprint 116 round 6. A new advisory against dnspython 2.9.0 (CVE-2026-128089, fixed in 2.9.2) turned deps-scan red on COM-1800's PR (#1795), and the backend jobs are skipped behind it, so it can't merge.

Fix: `uv lock --upgrade-package dnspython` (2.9.0 → 2.9.2), lockfile only.

**Independent.** Done when deps-scan passes on its PR and on #1795/#1797 after they pick it up.