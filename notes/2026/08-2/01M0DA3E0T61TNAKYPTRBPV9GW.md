---
id: 01M0DA3E0T61TNAKYPTRBPV9GW
created: 2026-08-19T15:26:41.178836Z
updated: 2026-08-19T15:26:41.178836Z
type: task
title: 'Ask for the title: the four forms that collect an engagement'
assignee: steve
task_status: todo
label: feature
priority: medium
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 287
---
Follows COM-286, which gives the engagement a `title` column. Four forms collect an engagement and none of them asks for a name. **Title goes above Scope** in each — it is what the thing is called, and scope is the description underneath it.

- [ ] **Request a new vendor** (`RequestVendorModal.tsx`) — a Title input at the head of the Engagement section, above Scope.
- [ ] **Request an engagement** (`RequestEngagementModal.tsx`) — the same field in the same position. The engagement half of these two modals is deliberately kept field-for-field identical (there is a comment in `RequestVendorModal` saying so); keep it that way.
- [ ] **Request an amendment** (`AmendEngagementModal.tsx`) — seeded from the current title, contributing `proposed.title` only when it differs, following the existing `if (value.trim() && value.trim() !== engagement.field)` shape.
- [ ] **Add / Edit engagement** (`EngagementModal` in `vendors/detail/cards.tsx`) — the internal manager's form.
- [ ] **Required wherever scope is required**: the submit guards currently read `scope && criticality`; they become `title && scope && criticality`. Same trim treatment.
- [ ] Tests: each form submits the title; the amendment omits it when unchanged and sends it when edited; submit stays disabled with an empty title.