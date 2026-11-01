---
id: 01M68R968RPEDQC4RHDZJDMMY5
created: 2026-10-31T10:32:28.696123Z
updated: 2026-11-01T08:40:51.210547Z
type: task
title: Audits joins the portal — someone asked for evidence, or given a finding's corrective action, sees "My audit requests" and answers it there
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1493
sprint: snvd637
comments:
- id: 01M6AFCCWAVKGSDC891VNJT8FZ
  author: Steve Vine
  at: 2026-11-01T02:35:25.450471Z
  text: |-
    Done, merged to main in PR #1511 (5aacb113).

    What people see:
    - An **Audits** menu item for anyone given an audit request or a finding's corrective action. **My audit requests** has two lists: **Requests** and **Corrective actions**.
    - On a request, they can:
      - upload evidence or pick from evidence they already own, and take off what they added;
      - comment. On an external audit, a comment can also be ticked "Also for the auditors";
      - **Mark ready** when they've provided everything. This is the existing "Provided" status, so the audit team sees it the same way.
    - On a corrective action, they can add progress comments and evidence. **Mark done** asks for a note, which is required. Once the plan is accepted, this submits the action for closure.
    - Their My actions rows for these open the page.

    Things to know:
    - No email is sent when someone comments, the same as inside Compass.
    - The evidence and corrective-action rules were moved into shared code, so the audit workspace and the portal follow the same rules and write the same activity log.

    Setting up on staging for UAT: in an audit in E2E Test Company, give E2E Asset Owner a request and a corrective action.
- id: 01M6AJ5BRNBK8WYTS68E2NJA10
  author: Steve Vine
  at: 2026-11-01T03:24:00.661335Z
  text: |-
    Pre-UAT (Claude, 2026-11-01, staging build 20261101-0257): **Passed**.

    Setup, as E2E Admin A: I created an internal audit, AUD-1 "E2E pre-UAT sprint 80 audit" (Cyber Essentials). It has request PU-1, owned by E2E Asset Owner and due Nov 15, and an observation, AUD-1-F1, also owned by E2E Asset Owner.

    As E2E Asset Owner:
    - Audits → My audit requests shows Requests (AUD-1 PU-1, Open) and Corrective actions (AUD-1-F1).
    - On PU-1, Add evidence → Upload, with "What it is" filled in, uploaded a text file. I added a comment and pressed Mark ready. The status is now **Provided**, with "Marked ready Nov 1, 2026, 3:12 am".
    - As E2E Admin A, the audit's Requests tab shows PU-1 as Provided with 1 piece of evidence. The file kept "What it is" as its description.
    - On AUD-1-F1, Record progress added the note.

    Question for Steve: My actions tells the finding's owner to "Write the corrective action plan for AUD-1-F1 · Respond". The portal page says "No plan yet — E2E Admin A writes it with you", and offers no way to write the plan. The task didn't ask for plan-writing in the portal. Either the portal should let the owner write the plan, or the action should go to the audit lead while there's no plan.

    Screenshots: ~/compass-uat/sprint-80/COM-1493/01–08
assignee: steve
label:
- feature
priority: medium
task_status: done
---
Sprint 80, Update user portal. Steve chose this on 2026-10-31 in answer to "which other modules should the portal have?".

## Why

An auditor's request list ("send us last quarter's access review") is mostly answered by ordinary staff, and so are the corrective actions on findings. A portal-only owner gets these as actions with nothing to open.

## What people see

- An **Audits** menu item, shown to anyone who owns an audit request or a finding's corrective action. Nobody else sees it.
- The page is **My audit requests**. It has two lists:
  - **Requests**: the audit, the request wording, its due date and status;
  - **Corrective actions**: the finding, what's to be done, its due date and status.
- Opening a request shows what the auditor asked and any comments. The owner can:
  - **provide evidence**: upload a file, or pick evidence from the register that they're allowed to see;
  - **comment**, which goes to the audit lead and, if the request is shared with the auditor, to the auditor;
  - **mark it ready** for the audit lead to check.
- Opening a corrective action shows the finding. The owner can **record progress** and **mark it done**, with a note and evidence.
- The audit lead still accepts the evidence and closes the finding, internally.
- Their My actions rows for these open this page.

## Notes (technical)

- Add ownership-scoped `/api/v1/portal/audits/...` reads and the writes above. Add each write route to the allowlist test in `tests/test_portal.py`.
- Reuse the Audit service code (ADR 0133, sprint 97) for providing evidence and comments, so the auditor portal and the activity log behave the same.
- In `links.py`, rewrite `request_link` and `finding_link` to the portal pages.
- The evidence picker offers only what the reader can already see. The portal has no Evidence register to browse.

**Chain:** on the chain (new portal API).

**Done when:** on staging, a request on an E2E Test Company audit is given to E2E Asset Owner. Signed in as them, Audits lists it, they can upload a file to it and mark it ready, and the audit lead sees the evidence internally.