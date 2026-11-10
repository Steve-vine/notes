---
id: 01M72VZ3QCQK9BVWDZMWJ93V8B
created: 2026-11-10T13:57:07.948778Z
updated: 2026-11-10T13:57:07.948778Z
type: task
title: HIPAA crosswalk completeness review — every library control that serves a requirement is linked to it
task_status: backlog
assignee: steve
label: improvement
priority: medium
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1674
---
Follows the SOC 2 finding (COM-1669, `audit/soc2-mapping.md`): COM-428 built every crosswalk requirement-first, choosing the smallest set of controls that satisfies each requirement, and the tests check coverage, not completeness. So relevant library controls can be missing from a requirement.

HIPAA's standards are broad (it averages two controls per requirement), so it's one of the most exposed. Review each Security Rule and Breach Notification standard and implementation specification, and link every library control that serves it, graded the same way as today. Edit `data/mappings/hipaa-2013.csv` only; the deploy-time importer applies it. Data only. **Independent.**

**Done when:** every requirement has been reviewed, the additions are graded with notes, and the crosswalk tests are green.