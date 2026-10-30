---
id: 01M657JZ0BBH18E6H8PPWKXKRK
created: 2026-10-30T01:42:59.851998Z
updated: 2026-10-30T08:19:39.891105Z
type: task
title: A test person in the directory for E2E Test Company, so the browser journeys can raise an access request and have a second administrator reject it
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1458
sprint: s5pn06h
comments:
- id: 01M65Y94PG8WV5MHXMJ8AV4P1D
  author: Steve Vine
  at: 2026-10-30T08:19:35.248291Z
  text: |-
    2026-10-30 08:20 GMT. Steve: "Create a user named 'Compass Test' via the Compass joiner process." Moved into sprint 99.

    Done:
    - E2E Admin A created a business role in E2E Test Company, "E2E Starter". It grants nothing (no groups, lists or mailboxes). New starters go to the same OU as Test Company's "Test Role 1" (MyBusiness ▸ Users ▸ UK ▸ Non PA ▸ Security Users).
    - E2E Access Manager raised **ACR-72**: a standard joiner for "Compass Test" (Compass.Test@moneypenny.co.uk), primary role E2E Starter. It is pending approval.

    Waiting on Steve to approve ACR-72. Claude never approves (ADR 0135). The one-time password will show only to E2E Access Manager, on screen; it is not needed, because the account is only ever the subject of test requests.

    Next: once the account appears in the directory (AD, then the Entra sync), journey 5 raises a request for Compass Test (a mover adding E2E Starter as an additional role), Admin A is refused approving their own, and Admin B rejects it.
assignee: steve
label:
- follow_up
priority: low
task_status: active
---
Follow-up to COM-1451 (sprint 99, ADR 0135).

Journey 5 is waiting on this. Every access request names real directory people (a group's owner, a membership's member) or a business role that places a new account somewhere in the real directory. The directory is shared by every company, so E2E Test Company has no person of its own.

## What it needs

- One clearly named test account in the directory (e.g. "E2E Test Person"), and perhaps one test group, that nobody relies on.
- A business role in E2E Test Company that uses only them.

The journey then raises a request naming only those, shows Admin A can't approve their own, and has Admin B **reject** it. It never approves, validates or expedites, so the directory is never changed.

## For Steve

Whether to create the test person and group in Entra (cloud-only, so Compass reads it straight away), and what to call them.

**Chain:** independent.