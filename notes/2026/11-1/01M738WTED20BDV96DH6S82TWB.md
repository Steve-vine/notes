---
id: 01M738WTED20BDV96DH6S82TWB
created: 2026-11-10T17:43:04.397986Z
updated: 2026-11-10T20:02:10.026584Z
type: task
title: Audit notes re-pointed at the exact set — Carbide and A-SCEND requests mapped to the agreed SOC 2 controls, and the gap report brought up to date
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1692
sprint: s6acz3m
blocked_by:
- 01M738WJ7NHWBD8ZNVCSFVQHM2
assignee: steve
label:
- chore
priority: medium
task_status: active
---
**Why.** Evidence collection works from `audit/`: collect in Compass, then copy to Carbide, then to A-SCEND. Its mapping files still point at controls from before the exact set. Once COM-1691 lands, each Carbide control and each A-SCEND request should point at the agreed SOC 2 controls. That way, evidence gathered for the set answers what both platforms ask.

**What changes:**
- Re-point `audit/mapping/carbide-controls.json` and `audit/mapping/ascend-requests.json` at the agreed set.
- Flag any request that now points at a control outside the set. That's either evidence the auditor wants that SOC 2 doesn't need, or a sign the set is missing something; it goes back to Steve.
- Rewrite the "overstated links" part of `audit/soc2-mapping.md` as closed.
- Add an entry to the log in `audit/README.md`.

**Where.** `audit/` only. **Independent.** Blocked by COM-1691.

**Done when:**
- Every Carbide control and A-SCEND request maps only to controls in the agreed set, or is listed for Steve with the reason.
- The README log records the change.