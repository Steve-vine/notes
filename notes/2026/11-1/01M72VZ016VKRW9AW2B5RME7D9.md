---
id: 01M72VZ016VKRW9AW2B5RME7D9
created: 2026-11-10T13:57:04.166853Z
updated: 2026-11-10T13:57:04.166853Z
type: task
title: PCI DSS 4.0.1 crosswalk completeness review — every library control that serves a requirement is linked to it
task_status: backlog
assignee: steve
label: improvement
priority: medium
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1673
---
Follows the SOC 2 finding (COM-1669, `audit/soc2-mapping.md`): COM-428 built every crosswalk requirement-first, choosing the smallest set of controls that satisfies each requirement, and the tests check coverage, not completeness. So relevant library controls can be missing from a requirement. Example: PCI 6.3.3 (security patches) links the vulnerability process and supported software but not the patch deployment controls VUM.1–VUM.4.

Review all 313 assessable requirements against their testing procedures and link every library control that serves each, graded the same way as today. Edit `data/mappings/pci-dss-4-0-1.csv` only; the deploy-time importer applies it. Data only. **Independent.**

**Done when:** every requirement has been reviewed, the additions are graded with notes, and the crosswalk tests are green.