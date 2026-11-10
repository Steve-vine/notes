---
id: 01M72VZM3QAFR76ZQWR9AQH8YH
created: 2026-11-10T13:57:24.727972Z
updated: 2026-11-10T13:57:24.727972Z
type: task
title: ISO 42001 crosswalk completeness review — every library control that serves a requirement is linked to it
label: improvement
assignee: steve
priority: low
task_status: backlog
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1679
---
Follows the SOC 2 finding (COM-1669, `audit/soc2-mapping.md`): COM-428 built every crosswalk requirement-first, choosing the smallest set of controls that satisfies each requirement, and the tests check coverage, not completeness. So relevant library controls can be missing from a requirement.

ISO 42001 is held as titles only. Review each clause and Annex A control against its intent and link every library control (AI governance and general) that serves it, graded the same way as today. Edit `data/mappings/iso-42001-2023.csv` only; the deploy-time importer applies it. Data only. **Independent.**

**Done when:** every requirement has been reviewed, the additions are graded with notes, and the crosswalk tests are green.