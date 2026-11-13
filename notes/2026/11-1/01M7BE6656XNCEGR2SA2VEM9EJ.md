---
id: 01M7BE6656XNCEGR2SA2VEM9EJ
created: 2026-11-13T21:49:29.638018Z
updated: 2026-11-13T22:48:00.705306Z
type: task
title: 'Dependency scan: move dnspython to 2.9.2 (CVE-2026-128089) so PR checks go green again'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1807
sprint: spsp226
comments:
- id: 01M7BF31N2JY0XSK2ED8W9QJMW
  author: Steve Vine
  at: 2026-11-13T22:05:15.298798Z
  text: 'Done — PR #1798 merged (447d3d17). The lockfile moves dnspython 2.9.0 → 2.9.2, the release that fixes CVE-2026-128089; nothing else changed. Its dependency scan passed. COM-1800 (#1795) has taken main and is re-running its checks.'
- id: 01M7BHHAY1AFWCW7FWW2TPFS03
  author: Steve Vine
  at: 2026-11-13T22:48:00.705117Z
  text: 'Pre-UAT: Passed. The dependency scan passed on COM-1800 (#1795) and COM-1801 (#1797) after they took this fix, and on the main build (2f72416b). Staging is on that build, and the Browser smoke passed 32/32. Nothing on screen to check.'
assignee: steve
label:
- chore
priority: high
task_status: review
---
Found 2026-11-13 ~21:50 GMT while landing sprint 116 round 6. A new advisory against dnspython 2.9.0 (CVE-2026-128089, fixed in 2.9.2) turned deps-scan red on COM-1800's PR (#1795), and the backend jobs are skipped behind it, so it can't merge.

Fix: `uv lock --upgrade-package dnspython` (2.9.0 → 2.9.2), lockfile only.

**Independent.** Done when deps-scan passes on its PR and on #1795/#1797 after they pick it up.