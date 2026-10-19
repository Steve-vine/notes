---
id: 01M5B0D0FQYDTJZ71NKPSW8E67
created: 2026-10-19T21:17:09.495303Z
updated: 2026-10-19T21:22:00.09978Z
type: task
title: A handler logs a request — what is asked, when and how it arrived, who it is from or acting for, the kind of person they are, the law that applies — numbered DSR-12, owned, optionally restricted, and listed in the register
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1131
sprint: ss8348q
blocked_by:
- 01M5B0CEYKQ2R690TXW5WT4MVD
assignee: steve
label:
- feature
priority: high
task_status: todo
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