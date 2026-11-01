---
id: 01M68R88V6RZJ6WBPZR7ZB7D0D
created: 2026-10-31T10:31:58.566958Z
updated: 2026-11-01T08:40:51.183401Z
type: task
title: Risks joins the portal — a risk's owner sees "My risks", reviews them, and works the treatment plans they own, without an internal role
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1491
sprint: snvd637
blocked_by:
- 01M68M6NN5KXXHSJ70PFHCHD6Q
comments:
- id: 01M6AF426AM64QGGYN64PXGR9G
  author: Steve Vine
  at: 2026-11-01T02:30:52.362173Z
  text: |-
    Done, merged to main in PR #1509 (1cec4b61).

    What people see:
    - A **Risks** menu item, shown only to someone who owns a risk, owns a treatment plan, or has an acceptance waiting on them.
    - **My risks** lists them with Ref, Title, Company, Score vs appetite, Treat by, Next review and Treatment, with what's due first.
    - On a risk, the person can:
      - **record a review**: confirm it or re-score it, with an optional note. The next review date moves on.
      - **create a treatment plan** (Mitigate, Transfer or Avoid) on a risk they own that has none.
      - **update a plan they own**: status, due date, note.
      - **approve or decline an acceptance** waiting on them, with a reason, which is required. Nobody decides their own.
    - Their My actions rows for these risks open this page.
    - Raising, deleting, re-owning or linking a risk stays in the internal register. So does creating an acceptance.

    Things to know:
    - Approving an acceptance still needs the "approve risk acceptances" permission, and no portal role has it today. A portal-only approver sees the acceptance but can't decide it. This is an open question for Steve.
    - The review, treatment and approve/decline rules were moved into shared register code. The register and the portal now follow the same rules and write the same activity log.

    Setting up on staging for UAT: make E2E Asset Owner the owner of a risk in E2E Test Company that has no treatment plan.
- id: 01M6AJ56H6TD1764SR7GCW45V3
  author: Steve Vine
  at: 2026-11-01T03:23:55.302435Z
  text: |-
    Pre-UAT (Claude, 2026-11-01, staging build 20261101-0257): **Passed**.

    Setup, as E2E Admin A: I raised R-26 "E2E pre-UAT sprint 80 risk", owned by E2E Asset Owner, with no treatment plan.

    As E2E Asset Owner:
    - Risks → My risks lists R-26: score 9, within appetite (9); Treat by Nov 15, 2026; next review Nov 1, 2027; "No plan yet".
    - My actions showed "Risk · R-26 · Create a treatment plan", which opens /portal/risks/<R-26>.
    - I created a treatment plan from the risk page ("How it will be treated: Mitigate — reduce it", plus what will be done). It shows as "Mitigate · Open · Owner: E2E Asset Owner", and Treatment now reads Planned.
    - I recorded a review with the scores unchanged and a note. Last reviewed is now Nov 1, 2026.
    - My actions now shows "Treatment · Mitigate risk: R-26 · Complete", which also opens the risk page.

    Not checked: approving or declining an acceptance. No portal role holds the approve permission (the open question already noted).

    Screenshots: ~/compass-uat/sprint-80/COM-1491/01–07
assignee: steve
label:
- feature
priority: medium
task_status: done
---
Sprint 80, Update user portal. Steve chose this on 2026-10-31 in answer to "which other modules should the portal have?".

## Why

Any user can own a risk, a treatment plan, or approve a risk acceptance. A portal-only employee gets those actions (review due, treatment plan due, acceptance to approve, and from sprint 100 "Create a treatment plan"). In the portal they show as plain text, with nothing to open.

## What people see

- A **Risks** menu item, shown to anyone who owns a risk, owns a treatment plan, or has an acceptance waiting for them. Nobody else sees it.
- The page is **My risks**. It lists those risks with their reference, title, company, current score against appetite, Treat by date, next review date and treatment status, sorted by what's due first.
- Opening a risk shows it in plain words: what it is, its scores, its linked controls and gaps (as text), and its treatment plans. The person can:
  - **record a review**: confirm it's still accurate or update the scores, with a note. The next review date moves on;
  - **create a treatment plan** on a risk they own with none, as sprint 100's action asks (COM-1476);
  - **update a treatment plan they own**: progress, status, note, done;
  - **approve or decline an acceptance** waiting on them, with a reason. Nobody approves their own.
- Anything else stays in the internal register: raising a risk, deleting one, changing its owner, linking controls.
- Their My actions rows for these risks open this page.

## Notes (technical)

- Add ownership-scoped `/api/v1/portal/risks` reads and the writes above under `require_portal_read` and ownership, the same pattern as portal Inventory and Vulnerabilities (ADR 0072 §10, ADR 0129 §5). Add each write route to the portal allowlist test in `tests/test_portal.py`.
- Reuse the register's service code for reviews, treatments and acceptance decisions, so the activity log and the rules match.
- In `links.py`, rewrite `/risks/{id}` to `/portal/risks/{id}`, then take `/risks/` off the internal-only list.

**Chain:** on the chain (new portal API). Blocked by COM-1476 (Treat by date, untreated-risk action).

**Done when:** on staging, E2E Asset Owner is made owner of a risk with no treatment plan in E2E Test Company. Signed in as them, Risks lists it, they can create a treatment plan and record a review there, and their My actions row opens it.