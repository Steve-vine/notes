---
id: 01M5B0EVJ7HNSH4M6D5J1BB4P3
created: 2026-10-19T21:18:09.991318Z
updated: 2026-10-20T18:05:46.071224Z
type: task
title: A Disclosures tab logs every time personal data left the company — who received it, what, about whom, why and on what legal basis, who approved — with unauthorised disclosures tied to a Privacy incident
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1135
sprint: ss8348q
blocked_by:
- 01M5B0EBPCTS9TVY9GDED4A69Q
comments:
- id: 01M5BAYJ5C5HPF9Y4NEV3PQ9HN
  author: Steve Vine
  at: 2026-10-20T00:21:30.412512Z
  text: |-
    Done — merged (PR #1128).

    - Data Subject Requests has a **Disclosures** tab beside Requests. Entries are numbered DIS-12; the table shows Number, Date, Recipient, About, What, Kind and Basis, with search and filters (kind, recipient, about a person, date range) kept in the address.
    - **Log a disclosure** records: authorised or not; the date; the recipient (a vendor, or typed with contact details); about whom (named people, each optionally linked to their request, or a group — a kind of person and a count, exact or an estimate); what was disclosed; why; the basis or legal instrument with its reference; who approved it; how it was sent; and files.
    - An **unauthorised** disclosure must name a Privacy incident: pick one, or **Create incident**, which opens the incident report prefilled with the Privacy category.
    - The incident's Impact lists its disclosures, and **Add to Disclosures log** opens the window prefilled from the incident (date, data assets and their data types, recipient, how it happened, how many people).
    - Each disclosure has its own page: details, linked requests and incident, attachments, timeline and history.
    - **Correct** changes an entry and always asks why. **Mark logged in error** keeps and freezes it, hidden from the list behind a switch. Nothing is deleted.
    - A disclosure about a restricted request's person is restricted to the same people; everyone else sees only its number, kind and date.

    My calls: legal instruments gain an "Other"; Approved by is optional; for an unauthorised disclosure "Why" reads "How it happened"; at least one kind of data is required. The "routine sharing is recorded in Inventory" help sits in the empty state and the Log window (screen conventions don't allow a paragraph atop a tab). The incident's PDF export doesn't list disclosures yet.
assignee: steve
label:
- feature
priority: high
task_status: done
---
Sprint 79, Data Privacy (ADR in COM-1129). Meets SOC 2 P6.1–P6.3, HITRUST 13.c and the library's PDH.16 (key `s42.PDH.5`): "Disclosures of personal data are recorded, whether authorised or not."

## What it's for

This is the log of **one-off and out-of-the-ordinary disclosures**. Routine sharing with a vendor that processes data for us is already recorded in Inventory, as the data asset's recipients and their DPA. The log's help text says so, and links there.

## What people see

**Disclosures** tab: one row per disclosure (`DIS-12`). Columns: Number, Date, Recipient, About, What, Kind, Basis. Filters in the URL (kind, recipient, date range, about a person), and a search.

**Log a disclosure**:

- **Kind**: **Authorised**, or **Unauthorised** (accidental or unlawful: the wrong recipient, a lost device, a breach).
- **Date disclosed**.
- **Recipient**: a vendor from the register, or typed (an organisation or person), with contact details.
- **About whom**: **named people** (one or more names, each optionally linked to a request) or **a group** (a kind of person from Inventory's data entities, with a count: exact or "about").
- **What**: the data types (the data rubric, as in Inventory), the data assets it came from (optional), and a description.
- **Why**: the purpose.
- **Basis** (authorised only): consent, contract, legal obligation, vital interests, public task, legitimate interests. Or a **legal instrument** (court order, police request under DPA 2018 Schedule 2, regulator's notice, subpoena), with its reference.
- **Approved by** (authorised only): a person, and when.
- **How it was sent**: email, secure transfer, post, verbal, portal, other.
- **Incident** (unauthorised only, required): link an existing Privacy incident, or **Create incident**, which opens the incident report prefilled. From the incident's Impact area, **Add to Disclosures log** creates the entry prefilled from the incident.
- Attachments.

A disclosure's page shows all of this, plus linked requests and the incident, its Timeline and History.

## Rules

- Nothing is ever deleted. A mistaken entry is marked **Logged in error** with a reason, and stays visible behind a switch.
- An entry can be corrected with a reason, and every change is logged.
- A disclosure about a restricted request's person is restricted to the same people.

## Notes (technical)

- New company-scoped table (`DIS-n` sequence), about-people rows (name, optional request id), data types, data asset links, recipient (vendor id or typed), basis enum (reuse the data asset `lawful_basis` enum) or legal instrument, approver. Audited.
- Add `disclosure` to `IncidentLinkKind` (`core/incident_links.py`), and the incident's "Add to Disclosures log" action.
- Screen conventions as usual.

**Done when:** a handler can log an authorised disclosure about a named person and an unauthorised one tied to a new or existing Privacy incident; the incident shows the disclosure, and the reverse.