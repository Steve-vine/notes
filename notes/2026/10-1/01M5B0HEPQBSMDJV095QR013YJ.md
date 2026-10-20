---
id: 01M5B0HEPQBSMDJV095QR013YJ
created: 2026-10-19T21:19:35.127308Z
updated: 2026-10-20T18:05:46.128808Z
type: task
title: A request closes against a checklist — identity, every part decided, every system and recipient recorded, the final letter sent — is marked on time or late, and is frozen from then on, with mistakes fixed by a correction
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1141
sprint: ss8348q
blocked_by:
- 01M5B0H0TVZX8KPNYATV68HDZ8
comments:
- id: 01M5BNBQR50J05APPTDPXMYVET
  author: Steve Vine
  at: 2026-10-20T03:23:27.877214Z
  text: |-
    Done — merged (PR #1137).

    - The side column's **Request Status** card shows the status at the top and the closing checklist below: identity (and a representative's authority), every part decided, every system has an outcome, the accounting added to the response (when one was granted), every recipient told or not told, and the final letter marked sent. Each item is ticked or says what's missing, and links to its card.
    - Statuses: New, Waiting for identity, Paused, **In progress** (from the first decision) and Closed, with one of seven outcomes.
    - **Close request** is enabled only when the checklist is complete, and Compass checks again when you press it; a refusal names what's missing. The outcome comes from the decisions.
    - **Close another way**: Withdrawn, Identity not confirmed, or Logged in error, each with a reason.
    - **On time or late** shows as "Answered in 23 days: on time" or "… late by 4 days", comparing the final letter's sent date with the deadline after pauses and any extension. A late close asks why.
    - **A closed request is frozen**: nothing on it can be changed, though comments stay open.
    - **Add a correction**: a dated note against a chosen field, shown on that field's card; it never changes what was recorded.
    - **Reopen** within 30 days of closing, with a reason. Close and reopen are on the timeline and in the activity log.
    - **"Follows on from"**: a new request can be linked to an earlier one, which then lists its later requests.

    My calls: a request becomes In progress at its first decision (checks alone don't move it); the answer date is the last final letter marked sent (a corrected copy doesn't move it); days to answer count from the day received; Identity not confirmed doesn't need the final letter; closing a paused request ends the pause first.
assignee: steve
label:
- feature
priority: high
task_status: done
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