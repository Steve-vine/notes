---
id: 01M72VYQHXGS7YHHJMZDE4QWRR
created: 2026-11-10T13:56:55.485711Z
updated: 2026-11-10T13:56:55.485711Z
type: task
title: ISO 27001:2022 crosswalk completeness review — every library control that serves a requirement is linked to it
label: improvement
task_status: backlog
priority: high
assignee: steve
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1671
---
Follows the SOC 2 finding (COM-1669, `audit/soc2-mapping.md`): COM-428 built every crosswalk requirement-first, choosing the smallest set of controls that satisfies each requirement, and the tests check coverage, not completeness. So relevant library controls can be missing from a requirement. Example: the automated patching controls (VUM.1–VUM.3) are linked only to Cyber Essentials.

ISO 27001 is held as titles only (licensed wording), so judge each Annex A control and clause against its full intent and against what a certification auditor asks for. Link every library control that serves it, graded the same way as today. Edit `data/mappings/iso-27001-2022.csv` only; the deploy-time importer applies it. Data only. **Independent.**

**Done when:** every requirement has been reviewed, the additions are graded with notes, and the crosswalk tests are green.