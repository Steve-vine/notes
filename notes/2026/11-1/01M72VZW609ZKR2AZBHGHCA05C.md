---
id: 01M72VZW609ZKR2AZBHGHCA05C
created: 2026-11-10T13:57:32.992793Z
updated: 2026-11-10T13:57:32.992793Z
type: task
title: HITRUST CSF v11.8 crosswalk completeness review — every library control that serves a requirement is linked to it
task_status: backlog
priority: medium
assignee: steve
label: improvement
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1680
---
Follows the SOC 2 finding (COM-1669, `audit/soc2-mapping.md`): COM-428 built every crosswalk requirement-first, choosing the smallest set of controls that satisfies each requirement, and the tests check coverage, not completeness. So relevant library controls can be missing from a requirement.

HITRUST ships as a licensed skeleton (titles only, ADR 0100). Judge each requirement against its intent at the e1/i1/r2 levels and link every library control that serves it, graded the same way as today. Edit `data/mappings/hitrust-csf-v11-8.csv` only; the deploy-time importer applies it. Data only. **Independent.**

**Done when:** every requirement has been reviewed, the additions are graded with notes, and the crosswalk tests are green.