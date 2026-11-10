---
id: 01M72VZGNEG0KMG5BY5DGVG4BP
created: 2026-11-10T13:57:21.198516Z
updated: 2026-11-10T13:57:21.198516Z
type: task
title: Cyber Essentials 3.3 crosswalk completeness review — every library control that serves a requirement is linked to it
task_status: backlog
label: improvement
priority: low
assignee: steve
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1678
---
Follows the SOC 2 finding (COM-1669, `audit/soc2-mapping.md`): COM-428 built every crosswalk requirement-first, choosing the smallest set of controls that satisfies each requirement, and the tests check coverage, not completeness. So relevant library controls can be missing from a requirement.

Review each Danzell requirement against the question set and link every library control that serves it, graded the same way as today. Edit `data/mappings/cyber-essentials-3-3.csv` only; the deploy-time importer applies it. Data only. **Independent.**

**Done when:** every requirement has been reviewed, the additions are graded with notes, and the crosswalk tests are green.