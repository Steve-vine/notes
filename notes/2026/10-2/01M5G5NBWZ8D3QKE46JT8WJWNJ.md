---
id: 01M5G5NBWZ8D3QKE46JT8WJWNJ
created: 2026-10-21T21:25:18.367199Z
updated: 2026-10-22T20:38:00.751127Z
type: task
title: The risk register holds up to an audit — a risk is Accepted only through an accepted treatment within appetite, closed risks drop out of the figures, and linking a risk to a control, gap or vendor shows in Activity
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1221
sprint: s33gwqy
blocked_by:
- 01M5G5N3G9GF001WDFQ1CCTMWS
comments:
- id: 01M5JNBDCN9Q82YQGKHVRHBEYP
  author: Steve Vine
  at: 2026-10-22T20:37:58.292923Z
  text: |-
    Done — merged in PR #1239 (migration 0500). Not yet on staging.

    - Accepted is gone from a risk's Status picker. A note under it says "Accepted comes from an accept treatment within appetite". On a risk that's already Accepted, the picker shows Accepted greyed out.
    - An accept treatment within appetite makes the risk Accepted straight away; over appetite it's refused. (The next task, COM-1222, adds the approver step in between.)
    - The risk goes back to Open, with a History line saying why, when the accept treatment is closed, deleted or changed to another type, or when the residual is raised over appetite.
    - Risks already marked Accepted with no accept treatment show an orange "Needs acceptance" badge, on the register and in the risk page header. Nothing else changes for them; recording an accept treatment clears it.
    - Closed risks drop out of Overview's totals, bands, heat-map and Over appetite, and out of the posture history. Overview says "Closed risks are not counted." Accepted risks still count.
    - Activity shows "linked R-14 to control ACC.8", "unlinked R-14 from gap G-12" and "linked R-14 to vendor Acme", and the Activity filter has the three new kinds.

    My calls:
    - "Needs acceptance" is worked out on the fly rather than stored: marked Accepted, but no live accept treatment stands, or the residual is now over appetite. So the migration changes no risks.
    - Only a change moves a risk's status. A risk someone Closed stays Closed, and an old Accepted risk is never moved to Open by an ordinary edit.
    - An out-of-date accept treatment can now be closed even when the risk is over appetite (before, the appetite check blocked closing it).
    - Activity lines always name both ends ("unlinked R-14 from gap G-12"), rather than the shorter wording in the task.
    - Lowering an appetite in Admin doesn't move any risks; affected Accepted risks show Needs acceptance instead.
    - The assistant can no longer set a risk to Accepted, and it sees the Needs acceptance flag.
    - The migration deletes old notification records of the retired "treatment overdue" kind, so they can't break loading.

    Noticed, not changed: unlinking a control or gap from a risk and then linking it again probably fails with an error, because the old unlinked row still counts. Worth a small task.
assignee: steve
label:
- improvement
priority: high
task_status: review
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