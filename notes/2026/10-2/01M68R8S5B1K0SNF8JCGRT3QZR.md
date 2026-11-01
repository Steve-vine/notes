---
id: 01M68R8S5B1K0SNF8JCGRT3QZR
created: 2026-10-31T10:32:15.275544Z
updated: 2026-11-01T03:31:19.222654Z
type: task
title: Gaps joins the portal — a gap's owner sees "My gaps" and moves each one on, comments, and sends it for review, without an internal role
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1492
sprint: snvd637
comments:
- id: 01M6AF73PTZ7DGB3FV242PWFQF
  author: Steve Vine
  at: 2026-11-01T02:32:32.218567Z
  text: |-
    Done, merged to main in PR #1510 (56c69fc9).

    What people see:
    - A **Gaps** menu item for anyone who owns a gap. **My gaps** lists their open gaps.
    - On a gap, the owner can:
      - move it between the open states: New, In progress, On hold and Under review. Closing or reopening stays in the internal register.
      - add comments, and edit or delete their own.
      - **propose a target date**. It's recorded as a comment for the register's owners to act on, so it doesn't change the gap's date.
    - A closed gap is read-only in the portal.
    - A gap raised by a Compass check shows a note that it closes itself when the check passes.
    - Their My actions rows for gaps open this page.

    Things to know:
    - Open question for Steve: the gap owner picker in the internal register doesn't offer portal-only staff. Until it does, give a portal-only person a gap by setting its owner through the API or Polaris.

    Setting up on staging for UAT: give E2E Asset Owner a gap in E2E Test Company, set through the API or Polaris.
- id: 01M6AJJR1PQPFEHW1BKB1EGN5X
  author: Steve Vine
  at: 2026-11-01T03:31:19.22238Z
  text: |-
    Pre-UAT (Claude, 2026-11-01, staging build 20261101-0257): **Passed**, with one defect found and fixed forward as COM-1497.

    Setup, as E2E Admin A: I raised G-46 "E2E pre-UAT sprint 80 gap" against INS.10, owned by E2E Asset Owner. Setting the owner through the API worked.

    As E2E Asset Owner:
    - Gaps → My gaps lists G-46 (INS.10, New).
    - On the gap page, the Status choices are exactly New / In progress / On hold / Under review. I moved it to In progress, then to Under review.
    - I added a comment, which shows with Edit and Delete.
    - I proposed a target date (15 Dec 2026, with a reason). It shows as a comment, "Proposed a target date of December 15, 2026. Reason: …". The target date itself is unchanged ("No date set").
    - My actions row "Gap · G-46 · Remediate" opens /portal/gaps/<G-46>.

    Defect (COM-1497): The control card showed the guidance as raw text, with `**What this means:**` and dashes. It's fixed on main (PR #1514) and goes to staging next.

    Observation for Steve: once the owner moves the gap to Under review, their My actions row still reads "Remediate". That comes from sprint 100's action rules, not from this task.

    Screenshots: ~/compass-uat/sprint-80/COM-1492/01–05
assignee: steve
label:
- feature
priority: medium
task_status: review
---
Sprint 80, Update user portal. Steve chose this on 2026-10-31 in answer to "which other modules should the portal have?".

## Why

A gap's owner is often the person who has to fix it: someone in IT or facilities, not a governance user. A portal-only owner's gap shows on their portal Actions as plain text, with nothing to open.

## What people see

- A **Gaps** menu item, shown to anyone who owns an open gap or has owned one. Nobody else sees it.
- The page is **My gaps**. It lists their gaps with the reference, control, title, company, status and target date. Open gaps come first, ordered by target date; finished ones sit below.
- Opening a gap shows the control it's against, what's wrong, the target date and the comment thread. The owner can:
  - **move it on**: New → In progress → On hold → Under review. They can't mark it Complete or Cancelled, which stays with the register's own reviewers;
  - **comment**, and edit or delete their own comments;
  - **propose a new target date** with a reason (shown as a comment; the date itself changes internally).
- A gap marked "Raised by Compass check" says that it closes itself once the check passes, as it does internally.
- Their My actions rows for these gaps open this page.

## Notes (technical)

- Add ownership-scoped `/api/v1/portal/gaps` reads, plus a status change (limited to the four open states) and comment writes. Add each write route to the allowlist test in `tests/test_portal.py`.
- Reuse the gap service so the activity log and the check-raised rules match.
- In `links.py`, rewrite `/gaps/{id}` to `/portal/gaps/{id}`.
- **Assumption (Steve can overrule):** an owner can't close their own gap. Under review hands it to the register for sign-off.

**Chain:** on the chain (new portal API).

**Done when:** on staging, E2E Asset Owner is made owner of a gap in E2E Test Company. Signed in as them, Gaps lists it, they can move it to In progress and then Under review and add a comment, and their My actions row opens it.