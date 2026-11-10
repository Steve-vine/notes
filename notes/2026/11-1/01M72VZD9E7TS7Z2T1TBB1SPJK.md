---
id: 01M72VZD9E7TS7Z2T1TBB1SPJK
created: 2026-11-10T13:57:17.742256Z
updated: 2026-11-10T13:57:17.742256Z
type: task
title: CIS Controls v8.1 crosswalk completeness review — every library control that serves a safeguard is linked to it
task_status: backlog
label: improvement
assignee: steve
priority: low
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1677
---
Follows the SOC 2 finding (COM-1669, `audit/soc2-mapping.md`): COM-428 built every crosswalk requirement-first, choosing the smallest set of controls that satisfies each requirement, and the tests check coverage, not completeness. So relevant library controls can be missing from a requirement. Example: safeguards 7.3/7.4 (automated OS and application patch management) don't link the automated patching controls VUM.1/VUM.2.

Review each safeguard and link every library control that serves it, graded the same way as today. Edit `data/mappings/cis-controls-v8-1.csv` only; the deploy-time importer applies it. Data only. **Independent.**

**Done when:** every safeguard has been reviewed, the additions are graded with notes, and the crosswalk tests are green.