---
id: 01M72VZ9NTWVHSTM9GYWYDJXKF
created: 2026-11-10T13:57:14.0423Z
updated: 2026-11-10T13:57:14.0423Z
type: task
title: NIST CSF 2.0 crosswalk completeness review — every library control that serves a subcategory is linked to it
priority: low
assignee: steve
label: improvement
task_status: backlog
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1676
---
Follows the SOC 2 finding (COM-1669, `audit/soc2-mapping.md`): COM-428 built every crosswalk requirement-first, choosing the smallest set of controls that satisfies each requirement, and the tests check coverage, not completeness. So relevant library controls can be missing from a requirement.

Review each subcategory against NIST's implementation examples and link every library control that serves it, graded the same way as today. Edit `data/mappings/nist-csf-2-0.csv` only; the deploy-time importer applies it. Data only. **Independent.**

**Done when:** every subcategory has been reviewed, the additions are graded with notes, and the crosswalk tests are green.