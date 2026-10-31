---
id: 01M68R88V6RZJ6WBPZR7ZB7D0D
created: 2026-10-31T10:31:58.566958Z
updated: 2026-10-31T10:32:03.278116Z
type: task
title: Risks joins the portal — a risk's owner sees "My risks", reviews them, and works the treatment plans they own, without an internal role
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1491
sprint: snvd637
blocked_by:
- 01M68M6NN5KXXHSJ70PFHCHD6Q
assignee: steve
label:
- feature
priority: medium
task_status: todo
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