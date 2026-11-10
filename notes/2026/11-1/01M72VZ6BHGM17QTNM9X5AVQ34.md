---
id: 01M72VZ6BHGM17QTNM9X5AVQ34
created: 2026-11-10T13:57:10.64172Z
updated: 2026-11-10T13:57:10.64172Z
type: task
title: UK GDPR crosswalk completeness review — every library control that serves a requirement is linked to it
assignee: steve
label: improvement
priority: medium
task_status: backlog
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1675
---
Follows the SOC 2 finding (COM-1669, `audit/soc2-mapping.md`): COM-428 built every crosswalk requirement-first, choosing the smallest set of controls that satisfies each requirement, and the tests check coverage, not completeness. So relevant library controls can be missing from a requirement.

The articles are broad (Art. 32 security of processing especially), so review each against what the ICO expects and link every library control that serves it, graded the same way as today. Edit `data/mappings/uk-gdpr.csv` only; the deploy-time importer applies it. Data only. **Independent.**

**Done when:** every requirement has been reviewed, the additions are graded with notes, and the crosswalk tests are green.