---
id: 01M68R4TEAP4KC31S47Y9QD8NN
created: 2026-10-31T10:30:05.514722Z
updated: 2026-10-31T10:30:05.514722Z
type: task
title: DDQ joins the portal — anyone with questions assigned to them sees "My DDQ questions", and answers, submits or hands back each one without leaving the portal
assignee: steve
label: feature
task_status: todo
priority: medium
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1490
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