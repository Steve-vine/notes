---
id: 01M4N549A3TWVPC9HRNB9SXX2N
created: 2026-10-11T09:36:28.9952Z
updated: 2026-10-11T09:36:43.62541Z
type: task
title: A framework with levels can be looked at level by level on Compliance — e1, i1, r2 for HITRUST and IG1 to IG3 for CIS — without changing the target
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 910
sprint: s4gilxe
blocked_by:
- 01M4N53YWTNMCR2THXNZ5TDA8F
- 01M4N52WKP1BX5VY5NKZMCYQCE
- 01M4N538FJ0E21QXVV0VQGB7CK
assignee: steve
label:
- feature
priority: medium
task_status: backlog
---
Part of sprint 68, Compliance (ADR in COM-904). The last piece: the second filter for frameworks. Needs frameworks in the filter, CIS's groups as levels, and the per-level history.

## What people see

- **When a chosen framework has levels, a level filter appears for it,** named for the framework: "HITRUST level" with e1, i1, r2; "CIS group" with IG1, IG2, IG3. Two such frameworks chosen means two filters.
- **It opens on the level the company is working towards,** and marks that one in the list.
- **Choosing another level changes that framework's gauge and its trend line** to that level. The gauge says which, for example "at e1".
- **It is a look, not a change.** The company's target, the Dashboard, the framework's page and every report stay as they were. The page says so when the level shown is not the target, with a link to the framework's page where the target is set.
- **The trend's past at that level is shown,** shaded where it was rebuilt from the change history rather than measured on the day.
- **A chip opens the framework's page narrowed to that status and that level.**
- **A framework with no levels has no such filter.**

## Notes (technical)

- **Current figures.** The read behind the gauges takes an optional level per framework and measures at it (`derive_framework` already takes a level). Reject a level the framework does not define. It must not write `target_level`.
- **Trend.** Read the per-level figures the nightly record now keeps. A point with no figure for the level is a gap in the line, not a zero.
- **Shading.** Today only the headline shades the reconstructed stretch; a level line shades where its own figures are rebuilt.
- **Chip links.** The framework page's requirements view takes the level in the address as a view, alongside the status filter from the frameworks task. Its "Working towards" picker stays the only way to change the target.
- **State.** One address key per framework's level, absent meaning the target.
- **Expect thin data:** HITRUST's i1 measures 11 controls on staging (COM-876's level tagging). That is the data, not this page.
- Tests: the level filter appears only for levelled frameworks; choosing a level does not call the target-level write; gauge and last trend point agree at a non-target level.

**Done when:** on staging, with HITRUST chosen and the company working towards r2, picking e1 shows e1's gauge and a line with a past, the HITRUST page still says r2, and with CIS chosen the filter offers IG1 to IG3.