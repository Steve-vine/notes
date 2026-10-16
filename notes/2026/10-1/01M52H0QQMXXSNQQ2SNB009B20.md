---
id: 01M52H0QQMXXSNQQ2SNB009B20
created: 2026-10-16T14:14:23.220556Z
updated: 2026-10-16T23:36:40.108298Z
type: task
title: The assistant can send a vendor its questionnaires — see what's required, send them to the compliance contacts, withdraw one, record answers given another way, and read what came back
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1039
sprint: shcfcmf
blocked_by:
- 01M52GYMF21TDX20N2Y43G2PN5
- 01M52H028Z5Y2P8RBCY5EVY7Q7
comments:
- id: 01M53H68ZDC3AVER38KGXQ1DWB
  author: Steve Vine
  at: 2026-10-16T23:36:39.149681Z
  text: |-
    Done — merged to main (PR #1019). Goes to staging with the rest of sprints 73 and 74.

    What the assistant can now do, for a named company:
    - Read a vendor's questionnaires: which its engagements require (outstanding or answered), and which are assigned, with status, how far the supplier has got, when sent and how long the link is valid. Or, across the company: every live vendor that's missing a required questionnaire.
    - Read the answers to a questionnaire, each with the question as it was worded when answered (rewording a question later doesn't change them).
    - Add a questionnaire to a vendor.
    - Send the pending ones to chosen compliance contacts, valid for N days (default 30) or until a date — the same as the Send button: each contact is emailed one personal Vendor Portal link, and the owners are told. Its description says in capitals that it emails the supplier, and the assistant asks first. Only compliance contacts can be chosen; anyone else is refused with "mark them first".
    - Withdraw one (the supplier's link stops working once nothing is open), delete one never sent, and record answers given another way — saved on an open questionnaire, or completed in one go.

    The link: never given to the assistant. The test catches the emailed link and checks that neither the link nor its token appears anywhere in what the assistant receives.

    "Via assistant": a send is recorded in Activity ("started assessment for Acme — sent to Sam Supplier…") with the via-assistant marker. That's Activity, not the vendor page itself — the vendor page has no "sent to" line of its own.

    My calls: the default validity is 30 days when none is given; "missing a required questionnaire" skips dormant and offboarded vendors.
assignee: steve
label:
- feature
priority: high
task_status: review
---
Sprint 73, MCP - Vendor Management (ADR in COM-1033). Built on COM-1035 (contacts) and COM-1038 (finding a form).

Steve, 2026-10-16: **the same as on screen.** Sending emails the vendor's compliance contacts a link into the Vendor Portal, from the company's own address. So the assistant flags sending and withdrawing as outside actions, and a client that asks before acting asks first.

## What people can ask of it

- **Read:**
  - a vendor's questionnaires: **which its engagements require, which are assigned**, and the status of each;
  - **the answers** to a completed or closed one, with each question as it was worded when answered.
- **Write (whatever the person's role allows on screen; that is *Run questionnaires*):**
  - **add** a questionnaire to a vendor;
  - **send** the outstanding ones to chosen compliance contacts, with a "valid until" date. Each contact gets one email with one link covering everything open.
  - **withdraw** (close) one. When nothing is left open, the vendor's link stops working.
  - delete one that was never sent;
  - **record answers given another way** (for example on a call or in a document), and complete it.
- **Never:** the link a supplier receives. It exists only in their email, and the assistant never sees it.
- **Example:** "Which active vendors are missing a required questionnaire? Send Acme's to their compliance contact, valid for 30 days." Or: "summarise what Acme said about encryption at rest."

## Notes (technical)

- Wraps `vendor_assessments.py`:
  - reads: `assessments`, `required-assessments` and get;
  - writes: POST (add), `start`, `{a}/close`, `{a}/complete`, `PUT answers/{q}` and DELETE.
- Leave `{a}/open` out: it's the bare state change without the email, which the screen doesn't offer on its own.
- `start` returns 409 when the Vendor Portal's address isn't configured. Pass that message on as it is.
- **Destructive:**
  - `start`, because it emails a third party and grants them access;
  - close;
  - delete.

  Recording answers is a write.
- Contacts resolve by name among the vendor's compliance contacts only. Refuse anyone else, with a pointer to COM-1035 to mark them first.
- New module `tools/vendors_questionnaires.py`.
- Tests:
  - start is hidden without run-questionnaires;
  - no tool result carries a token or link;
  - a non-compliance contact is refused;
  - completed answers come back with their frozen wording;
  - a send is recorded via assistant.

**Done when:** on staging, the assistant sends a questionnaire to a test vendor's compliance contact. The email arrives, the link opens the Vendor Portal, and the vendor page shows "sent to …" via assistant.