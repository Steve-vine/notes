---
id: 01M738WJ7NHWBD8ZNVCSFVQHM2
created: 2026-11-10T17:42:55.989881Z
updated: 2026-11-10T19:43:23.645998Z
type: task
title: SOC 2 in Compass becomes the signed-off exact set — unneeded links removed on every environment at deploy, and a test keeps every criterion in the agreed shape
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1691
sprint: s6acz3m
blocked_by:
- 01M738VYSNS10XYX0RYRCGNERX
- 01M738W6271W48YKE8KNCNRH3G
assignee: steve
label:
- improvement
priority: high
task_status: active
---
**Why.** This is where Steve's three rules (COM-1682) become true in Compass. Once it lands, completing the controls linked to SOC 2 means SOC 2 is met, and nothing more.

**What people see.** Each SOC 2 criterion lists only the controls agreed in COM-1689. Every criterion reads fully covered. A company's SOC 2 figure asks for the agreed set of controls and no more. Other frameworks don't change.

**What changes:**
- **Rewrite** `data/mappings/soc-2-tsc-2017.csv` to the signed-off set:
  - each link with its relationship, strength and a note naming the points of focus it carries;
  - each criterion flagged complete where its set is partial controls.
- **Removed links go everywhere.** The deploy-time import retires links the file no longer claims, so links come off staging and production at the next deploy, and a clean install builds the same set.
- **Check first.** Before merging, look on staging and production for any SOC 2 link a person added or changed on screen. The import leaves those alone, so each needs a decision.
- **Same for the "complete" flag.** Confirm a criterion that moves from a set to a single control loses its "complete" flag on an existing install.
- **New test.** Every SOC 2 criterion has exactly one of the two shapes, and no criterion has a control that does the whole job beside other links.
- **Existing tests move.** The pinned SOC 2 count, `test_privacy_rights_control` if COM-1687 changed P2.1/P4.1/P5.1, and the tier test: most of COM-1669's `_LIFTED_BY_SOC2` names drop out. Proposed tiers are still left for a curator (ADR 0069).

**Where.** Data and tests only: no migration, no API change. **Independent.** Blocked by COM-1689 and, if it has work, COM-1690.

**Done when:**
- On staging, SOC 2 has the agreed number of links and controls.
- Spot checks show the agreed set and nothing else, e.g. CC6.2, CC7.1, A1.3 and P1.1.
- Every criterion reads fully covered.
- The new shape test is green.