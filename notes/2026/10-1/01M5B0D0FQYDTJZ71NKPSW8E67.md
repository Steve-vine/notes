---
id: 01M5B0D0FQYDTJZ71NKPSW8E67
created: 2026-10-19T21:17:09.495303Z
updated: 2026-10-19T23:16:48.648636Z
type: task
title: A handler logs a request — what is asked, when and how it arrived, who it is from or acting for, the kind of person they are, the law that applies — numbered DSR-12, owned, optionally restricted, and listed in the register
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1131
sprint: ss8348q
blocked_by:
- 01M5B0CEYKQ2R690TXW5WT4MVD
comments:
- id: 01M5B781CYVTBCECNWQAKYSCWN
  author: Steve Vine
  at: 2026-10-19T23:16:46.622002Z
  text: |-
    Done — merged (PR #1126).

    - **Requests ▸ Log a request** asks for: one or more of the ten types; when it was received (defaults to now, can be earlier, never later); how it arrived; the person (only the name is required); who is acting for them, or the customer who forwarded it (a vendor or typed, their reference and their deadline); the kind of person (Inventory's data entities); the law (starts on the company's default); what they said, with the email or letter as files; and the owner (whoever logs it, unless changed).
    - Saving gives it a **DSR-n** number and opens its page: Request Details, Attachments, the Verify / Decide / Fulfil / Tell recipients / Letters areas (dimmed until their tasks land), Timeline and History, with a Request Status panel at the side.
    - Details can be edited while the request is open. Changes to types, law or owner get their own timeline entry; everything is in History.
    - **Close as logged in error** needs a reason; the request stays in the register, closed and unchangeable.
    - **The register**: open first, by due date. Columns Number, Person, Asking for, Received, Due (shows "—" until deadlines land), Owner, Status, Law. Status, type, owner, law, overdue, Show closed and search are kept in the address.
    - **Restricted**: someone who can see restricted requests can restrict one when logging it or later. Everyone else sees "Restricted request" with only its number, status and dates, and can't open it, its timeline, history or files. The Activity log and Admin ▸ Files show it by number only.

    My calls (copying Incidents): restricting needs a reason, and the person restricting and the owner are always named; restrict/lift is also on the request page, and still works once closed; files attached by mistake (e.g. an ID copy) can be removed while open, and the removal is logged. Saved emails (.eml/.msg) can't be uploaded — Compass's allowed file types don't include them; I left that list alone. A data entity used by a request can no longer be deleted.
assignee: steve
label:
- feature
priority: high
task_status: review
---
Sprint 79, Data Privacy (ADR in COM-1129). Steve decided staff log every request; nothing public-facing this sprint.

## What people see

**Requests ▸ Log a request** opens a window:

- **What they are asking for**: one or more of **Access** (a copy of their data), **Correction**, **Erasure**, **Restriction**, **Objection** (including to direct marketing), **Portability**, **Review of an automated decision**, **Accounting of disclosures** (HIPAA), **Opt out of sale or sharing** (CCPA) and **Complaint**. A request can hold several, e.g. access and erasure together. Each is decided and fulfilled separately (later tasks).
- **Received**: the date (and time) it arrived. It defaults to now and can be earlier, because the clock starts when it arrived, not when it was logged.
- **How it arrived**: Email, Phone, Letter, In person, The company's own web form, Social media, **Through someone acting for them** (solicitor, relative, agent), **Forwarded by a customer** (we handle the data for that customer), Other.
- **The person**: name, email, phone, postal address, and any reference they gave (customer number, employee number). Only the name is required.
- **Acting for them** (when it came through someone else): the representative's name, organisation and contact details. Their authority is checked in Verify.
- **Forwarded by a customer**: pick the customer (a vendor, or typed), their reference, and **the customer's deadline** for our part. Where we only handle the data for a customer, the customer answers the person, and we help (ADR).
- **Kind of person**: from Inventory's data entities (customer, caller, employee, candidate…). It drives the systems list in Fulfil.
- **Law**: the company's default, changeable.
- **What they said**: the request in their words (pasted text), plus attachments (the email, the letter).
- **Owner**: who works it. Defaults to the person logging it.
- **Restricted**: only for people who can see restricted requests (e.g. an employee's request during a grievance). Pick the named people who may see it, as with incidents.

Saving gives it a number, **DSR-12** (one sequence across companies, like INC-12), and opens the request page: a details card (all of the above, editable until it's closed), with the later stages' areas dimmed until their task lands, and a **Timeline** (comments) and **History**.

**The register** (Requests tab): open requests first, sorted by due date. Columns: Number, Person, Asking for (chips), Received, Due, Owner, Status, Law. Filters in the URL: status, type, owner, law, overdue; a "Show closed" switch; search by number, name and email. Restricted requests show as a redacted row ("Restricted request DSR-14, due 12 Nov") to those who can't see them.

## Rules

- One company per request.
- Nothing is ever deleted. A request logged by mistake is closed as **Logged in error**, with a reason (closing comes in a later task; this task provides the Logged in error close).
- Every change goes in the activity log against the request.

## Notes (technical)

- New tables: request (company, number, received_at, channel, person fields, representative fields, customer fields, data entity, law, owner, restricted + allowed people, status) and request type rows. Audited.
- Restriction: reuse the ADR 0116 §10 pattern (`core/incident_restriction.py`): kept out of search, links, Actions, exports and the assistant.
- Attachments: add an owner type to `models/attachment.py`.
- URL-backed filters with `useQueryState` (COM-792). Screen conventions: `SortableTh`, `w="fit-content"`.

**Done when:** a handler can log a request with several types, see it in the register with its number, and a restricted request is redacted for everyone not named.