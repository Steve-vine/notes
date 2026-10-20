---
id: 01M5B0F9ASA7XXNWZMPA3R97NY
created: 2026-10-19T21:18:24.089032Z
updated: 2026-10-20T18:05:46.081336Z
type: task
title: A request to disclose someone's data — from the police, a regulator, a court or another organisation — is logged, decided on its legal grounds by a named approver, and what was handed over lands in the Disclosures log
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1136
sprint: ss8348q
blocked_by:
- 01M5B0EVJ7HNSH4M6D5J1BB4P3
comments:
- id: 01M5BDK472EJSM9A7J5DGXMN5M
  author: Steve Vine
  at: 2026-10-20T01:07:41.410493Z
  text: |-
    Done — merged (PR #1131).

    - The Disclosures tab switches between the **Disclosures log** and **Requests to disclose (n open)**. Requests to disclose are numbered RTD-12 and listed with From, About, Legal grounds, Received, Respond by and Status — open first, soonest Respond by at the top, red once it has passed. Filters for status, past Respond by and search; ones logged in error sit behind a switch.
    - **Log a request to disclose** records who is asking (organisation, person, how to reach them), when it arrived and the Respond by date, about whom and what they want, the legal grounds (court order, police request under DPA 2018 Schedule 2, regulator's notice, subpoena, the person's consent, other) with their reference and the request attached, whether a customer whose data it is was told (or why the law forbids it), and the owner.
    - **Someone other than the person who logged it** decides: Disclose, Disclose in part or Refuse, always with a reason. The logger sees "You logged it, so you can't decide it."
    - After Disclose, **Record the disclosure** opens the disclosure window filled in from the request and logs a linked DIS- entry ("In answer to RTD-12"). After Refuse, the reply sent is recorded.
    - Each request to disclose has its own page (Details, Decision, Attachments, Timeline, History, and a Status card). Nothing is deleted; mistakes are marked logged in error.
    - One about a restricted request's person is restricted to the same people everywhere.

    My calls: whoever is signed in when deciding is the approver (no picker, so the logger can't name someone else and click); what was decided on can't change afterwards — mark it logged in error and log it again; kinds of data are optional on the request (the disclosure still needs them); files are added on the disclosure's page, not in the Record window.
assignee: steve
label:
- feature
priority: medium
task_status: done
---
Sprint 79, Data Privacy (ADR in COM-1129). Covers the legally binding disclosure requests that ISO 27701 (8.5.4, 8.5.5) and HITRUST 13.c expect to be handled and recorded. It also makes the Disclosures log complete for law-enforcement requests.

## What people see

**Disclosures ▸ Requests to disclose** (a second list on the tab, `RTD-12`), and **Log a request to disclose**:

- **From**: the organisation (a police force, a regulator, a court, a solicitor, another company), the person asking, and their contact details.
- **Received** and **Respond by**: the date they asked for, if any.
- **About whom** and **what is asked for**: as on a disclosure.
- **Legal grounds given**: court order, police request (DPA 2018 Schedule 2 crime and taxation), regulator's notice, subpoena, consent of the person, other. Add a reference and attach the request.
- **Our customer's data?**: when the data is held for a customer, record whether the customer was told, and when. If the law forbids telling them, record that and why (ISO 27701 8.5.4).
- **Decision**, by a named **approver**: **Disclose**, **Disclose in part**, or **Refuse**, with the reason.
  - Disclose or Disclose in part: **Record the disclosure** creates the `DIS-` entry, prefilled (recipient, about whom, legal instrument, approver), and the two are linked.
  - Refuse: the reason, and the reply sent.
- Owner, Timeline and History, as on a request.

The list shows open ones first, with Respond by.

## Rules

- The approver can't be the person who logged it. The ADR records this as my call; it is a separation of duties that ISO 27701 implies but doesn't name.
- Nothing is deleted. Mistakes are closed as Logged in error, as elsewhere.
- Overdue Respond-by dates show in Actions (Reminders task).

## Notes (technical)

- A small table of its own, linked one-to-one to the resulting disclosure.
- It reuses the Disclosures task's about-whom and recipient shapes.

**Done when:** a police request can be logged, approved by someone else, and the disclosure it produces appears in the log linked back to it; a refusal records its reason.