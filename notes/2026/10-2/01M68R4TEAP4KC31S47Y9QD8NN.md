---
id: 01M68R4TEAP4KC31S47Y9QD8NN
created: 2026-10-31T10:30:05.514722Z
updated: 2026-11-01T03:23:50.75347Z
type: task
title: DDQ joins the portal — anyone with questions assigned to them sees "My DDQ questions", and answers, submits or hands back each one without leaving the portal
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1490
sprint: snvd637
blocked_by:
- 01M68M7NKF55VWKY9J5ZN9Q146
comments:
- id: 01M6ABBYX7RZWWRCRJ4M9222XX
  author: Steve Vine
  at: 2026-11-01T01:25:16.839758Z
  text: |-
    Done — merged to main in PR #1508 (2026-11-01).

    What people see:
    - A "DDQ" item in the portal menu for anyone with a DDQ question assigned to them (open or already submitted). Nobody else sees it.
    - "My DDQ questions": questions grouped by DDQ — reference, "For {client}", due date (red when overdue), how many are left to answer. Each question shows its wording, the note left for you, and To answer / Sent back / In review / Approved. DDQs with something to do come first.
    - Opening a question shows the same answer screen as the internal app, inside the portal: answer, cite or attach, use library suggestions (if you may read the library), Submit for review, Hand back. A library answer it was drafted from is named but not linked (the library is internal).
    - The DDQ row on My actions opens My DDQ questions filtered to that DDQ.
    - A portal-only person following an emailed link to their question lands on it in the portal. Internal users keep their internal pages.

    Changed along the way: portal-only staff couldn't be assigned a DDQ question at all ("only uses the portal, so can't be assigned a question"). Now anyone who can sign in to the portal can be; only an account with no way into Compass is refused.

    To check on staging: a DDQ manager assigns a question on an E2E Test Company DDQ to E2E Asset Owner, then sign in as them. Not yet on staging — the sprint deploys once all 12 are in Review.
- id: 01M6AJ5231H1T2G83K6EYGYE42
  author: Steve Vine
  at: 2026-11-01T03:23:50.753239Z
  text: |-
    Pre-UAT (Claude, 2026-11-01, staging build 20261101-0257): **Passed**.

    Setup, as E2E Admin A: I logged DDQ-9, an online DDQ for "E2E pre-UAT sprint 80 client". I added question 1.1 by hand and assigned it to E2E Asset Owner, due Nov 8.

    As E2E Asset Owner:
    - **DDQ** is in the menu. My DDQ questions shows DDQ-9 "For E2E pre-UAT sprint 80 client · Due Nov 8 · 1 to answer", with question 1.1 as To answer.
    - The question opens on the portal answer screen. I gave Response "Yes", a detail, and Sensitivity Public, saved it, and submitted it for review.
    - It then shows "In review", is locked, and the list says "Nothing left to answer".
    - My actions row "DDQ-9 (E2E pre-UAT sprint 80 client) · 1 question · Answer questions" links to /portal/ddq?ddq=…, this page filtered to DDQ-9.

    On purpose, not a fault: the group's due date shows the soonest due among your open questions (Nov 8). Once you've answered all of them, it shows the DDQ's own date (Nov 22).

    Screenshots: ~/compass-uat/sprint-80/COM-1490/01–05
assignee: steve
label:
- feature
priority: medium
task_status: review
---
Sprint 80, Update user portal. Requested by Steve on 2026-10-31.

## Why

Someone a DDQ question is assigned to needs no DDQ permission (ADR 0124 §9). The page where they answer it exists only in the internal app, though, so a portal-only employee is sent back to the portal. Their action has no link today, and they cannot answer the question at all.

## What people see

- A **DDQ** menu item, shown to anyone with a DDQ question assigned to them, whether open or already submitted. It works the way Attestations does: nobody else is offered an empty page.
- The page is **My DDQ questions**. It lists the questions assigned to you, **grouped by DDQ**. Each group shows the DDQ reference, who it is for, its due date, and how many of your questions are still to answer.
  - Each question shows its wording, the note left for you, and where it stands: To answer, In review, Sent back or Approved.
  - The list opens on what is still yours to do, with the finished ones below.
- Opening a question shows the **same answer screen as the internal app**, inside the portal:
  - write or edit the answer;
  - cite or attach what you are allowed to see;
  - use a library answer, if you may read the library;
  - **Submit** it for review, or **Hand back** with a reason.
  - It never shows the rest of the DDQ.
- The DDQ action on **My actions** opens this page, filtered to that DDQ. In sprint 100 (COM-1479) that action becomes one per person per DDQ.
- A link to an assigned question in an email, opened by a portal-only account, lands on the same question in the portal.
- Internal users keep their internal page. Nothing changes for them.

## Notes (technical)

- New `GET /api/v1/portal/ddq/assigned`: the caller's own assignments with each DDQ's ref, client, due date and status, under `require_portal_read`.
- The question itself reuses the existing assignee API (`/ddq/assigned/{id}`, and its link options, suggestions, answer, submit and hand-back routes). It already answers only the assignee and needs no DDQ permission, so it needs no second copy.
  - Check whether those write routes need adding to the portal write-routes allowlist test (`tests/test_portal.py`), or whether they stay outside `/portal`.
- `core/actions/links.py`: point `/ddq/assigned/…` and COM-1479's per-DDQ link at `/portal/ddq…`. A test pins every rewrite.
- Mount `DdqAssignedQuestionPage` under the portal shell (`/portal/ddq/:assignmentId`). Send a portal-only account that opens `/ddq/assigned/:id` there.
- Add a `portalNav.ts` gate, as with `useHasAttestations`: someone with any assignment.

**Chain:** on the chain (new portal API, so schema.d.ts changes). Blocked by COM-1479, so its action link is the per-DDQ one.

**Done when:** on staging, a question on an E2E Test Company DDQ is assigned to E2E Asset Owner. Signed in as them, DDQ is in the menu and the question is listed under its DDQ. It can be answered and submitted in the portal, and shows In review afterwards. Their My actions row opens the same page.