---
id: 01M5B0HEPQBSMDJV095QR013YJ
created: 2026-10-19T21:19:35.127308Z
updated: 2026-10-19T21:19:35.127308Z
type: task
title: A request closes against a checklist — identity, every part decided, every system and recipient recorded, the final letter sent — is marked on time or late, and is frozen from then on, with mistakes fixed by a correction
assignee: steve
priority: high
task_status: todo
label: feature
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1141
---
Sprint 79, Data Privacy (ADR in COM-1129).

## What people see

The side column of the request page holds **Request Status**: the status at the top, then the **closing checklist** (the same shape as Incident Status, COM-1117).

**Statuses**:

- **New** (logged);
- **Waiting for identity**;
- **Paused** (clarification);
- **In progress**;
- **Closed**, with a close outcome:
  - **Completed**: all parts granted;
  - **Partly completed**;
  - **Refused**;
  - **Withdrawn**;
  - **Identity not confirmed**;
  - **Passed to customer**;
  - **Logged in error**.

**Checklist** (each item a tick that links to its card):

1. Identity confirmed, or a reason it wasn't needed or couldn't be;
2. every part decided;
3. every Fulfil line has an outcome (granted parts);
4. every recipient told or not told (corrections, erasures, restrictions);
5. the final letter marked sent: response, refusal, partly granted, or forwarded.

**Close** is enabled when the checklist is complete. **Withdrawn**, **Identity not confirmed** and **Logged in error** close with a reason, needing only the items that apply.

**On time or late**: Compass compares the final letter's sent date with the deadline (after pauses and extension). The closed request shows "Answered in 23 days: on time" or "late by 4 days". A late close asks for a reason.

**Frozen**: once closed, every card is read-only. **Add a correction** records a dated note against a field ("the erasure on CRM was in fact done on 3 Nov"), shown beside it. It never changes the original (the SAP pattern). **Reopen** exists only for requests closed in the last 30 days, with a reason. The person may come back about the same request; anything later is a new request, linkable to the old one.

## Rules

- Nothing is ever deleted (the retention task clears details later; it doesn't delete the request).
- Timeline comments stay open after close.

## Notes (technical)

- Closing is a server-side check of the checklist, not just a disabled button.
- Correction rows, as in SAP (ADR 0115).
- An audit event on close and reopen.

**Done when:** a request can't close with an unrecorded system or recipient; a complete one closes, shows on time or late, and can only be corrected afterwards.