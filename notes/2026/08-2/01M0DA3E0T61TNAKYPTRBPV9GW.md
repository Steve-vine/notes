---
id: 01M0DA3E0T61TNAKYPTRBPV9GW
created: 2026-08-19T15:26:41.178836Z
updated: 2026-08-20T13:49:53.417755Z
type: task
title: 'Ask for the title: the four forms that collect an engagement'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 287
sprint: sbph5q5
blocked_by:
- 01M0DA29KCKMVPBKK5ZQW05JZR
comments:
- id: 01M0DWKERPF7YX461V32S1AE49
  author: Steve Vine
  at: 2026-08-19T20:50:00.598694Z
  text: |-
    Shipped in PR #285, merged to main as b8a0f00.

    Title goes above Scope in all four forms: `RequestVendorModal`, `RequestEngagementModal` (the engagement half of those two kept field-for-field identical, as the comment there asks), `AmendEngagementModal` (seeded from the current title, contributing `proposed.title` only when it differs, in the existing sparse-overlay shape), and the internal `EngagementModal` in `vendors/detail/cards.tsx`. Submit guards became `title && scope && criticality` with the same trim treatment.

    COM-286's `titleFromScope()` bridge is deleted — it only existed to keep the tree compiling between the column landing and the forms asking.

    Tests: each form submits the title; the amendment omits it while unchanged and proposes it alone once edited; submit stays disabled on an empty and on a whitespace-only title. `RequestEngagementModal` had no test file at all before this — it has one now. Frontend suite green (382 tests).
assignee: steve
label:
- feature
priority: medium
task_status: done
---
Follows COM-286, which gives the engagement a `title` column. Four forms collect an engagement and none of them asks for a name. **Title goes above Scope** in each — it is what the thing is called, and scope is the description underneath it.

- [ ] **Request a new vendor** (`RequestVendorModal.tsx`) — a Title input at the head of the Engagement section, above Scope.
- [ ] **Request an engagement** (`RequestEngagementModal.tsx`) — the same field in the same position. The engagement half of these two modals is deliberately kept field-for-field identical (there is a comment in `RequestVendorModal` saying so); keep it that way.
- [ ] **Request an amendment** (`AmendEngagementModal.tsx`) — seeded from the current title, contributing `proposed.title` only when it differs, following the existing `if (value.trim() && value.trim() !== engagement.field)` shape.
- [ ] **Add / Edit engagement** (`EngagementModal` in `vendors/detail/cards.tsx`) — the internal manager's form.
- [ ] **Required wherever scope is required**: the submit guards currently read `scope && criticality`; they become `title && scope && criticality`. Same trim treatment.
- [ ] Tests: each form submits the title; the amendment omits it when unchanged and sends it when edited; submit stays disabled with an empty title.