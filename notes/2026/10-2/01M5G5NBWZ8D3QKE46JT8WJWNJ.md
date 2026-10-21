---
id: 01M5G5NBWZ8D3QKE46JT8WJWNJ
created: 2026-10-21T21:25:18.367199Z
updated: 2026-10-21T21:29:24.770231Z
type: task
title: The risk register holds up to an audit — a risk is Accepted only through an accepted treatment within appetite, closed risks drop out of the figures, and linking a risk to a control, gap or vendor shows in Activity
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1221
sprint: s33gwqy
blocked_by:
- 01M5G5N3G9GF001WDFQ1CCTMWS
assignee: steve
label:
- improvement
priority: high
task_status: todo
---
Sprint 83, Risk Assessments (ADR in COM-1219). Fixes the holes in Posture ▸ Risks an auditor would find, before assessments start writing into it.

**Chain:** on the chain — migration + API

## Today

- A risk's status can be set to **Accepted** directly, with no accept plan and no appetite check — the check only guards treatment plans.
- **Closed** risks still count in the posture totals, the band counts, the heat-map and Over appetite.
- Linking or unlinking a risk to a control, a gap or a vendor leaves nothing in Activity (asset links already do).

## What people see

- **Accepted** is no longer in the status picker. A risk becomes Accepted when an **accept** treatment is recorded within appetite (and, once the acceptance task lands, approved). Closing the accept plan or the residual rising over appetite moves it back to Open, with a line in its History.
- Existing risks marked Accepted without an accept plan show a **Needs acceptance** flag on the register and the risk page, so someone records one. Nothing is changed for them automatically.
- **Closed** risks are left out of Overview's figures, heat-map and Over appetite, and the posture snapshot. They stay in the register behind the status filter.
- Activity shows "linked R-14 to control ACC.8", "unlinked gap G-12", "linked vendor Acme".

## Notes (technical)

- Status write path: reject `accepted` from PATCH; derive it from treatments. Migration flags (doesn't rewrite) legacy accepted-without-plan rows.
- `core/posture.py` and `risk_overview.py` filter `status != closed`.
- Add risk_control_link, risk_gap_link and vendor_risk_link to the `db/audit.py` allowlist.
- Remove the unused `NotificationKind.treatment_overdue`.

**Done when:** a risk can't be set to Accepted by hand; an accept plan over appetite is refused and within appetite makes it Accepted; closing a risk lowers the Overview counts; link changes appear in Activity.