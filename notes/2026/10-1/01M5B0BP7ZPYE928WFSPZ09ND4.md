---
id: 01M5B0BP7ZPYE928WFSPZ09ND4
created: 2026-10-19T21:16:26.239259Z
updated: 2026-10-19T22:05:35.78899Z
type: task
title: 'ADR: Data Subject Requests — a company''s register of privacy requests, each verified, decided, fulfilled system by system and answered within the law''s deadline, beside a log of every disclosure of personal data, frozen once closed and cleared after its retention period'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1129
sprint: ss8348q
comments:
- id: 01M5B35MSA46YJYWMNNDVVRX1K
  author: Steve Vine
  at: 2026-10-19T22:05:33.865814Z
  text: |-
    Done — ADR 0118 merged (PR #1123), `decisions/0118-data-subject-requests.md`.

    - Records the module as planned: one register per company (DSR-/DIS-/RTD- numbers), the four permissions, the request types, the deadline rules table for UK GDPR, EU GDPR, HIPAA and CCPA, and the order a request is worked (verify, decide, fulfil, tell recipients, letters, close).
    - Records Steve's four decisions (staff log requests; four laws; handler sends letters, Compass records; handler does all fulfilment).
    - Lists the planning calls still awaiting Steve's confirmation in their own section, so they're easy to find and change.
    - Docs only; no screens change.
assignee: steve
label:
- brief
priority: high
task_status: review
---
Sprint 79, Data Privacy. Scoped with Steve on 2026-10-19. This record is the first task, and the rest wait for it.

## What Data Subject Requests is

A new module, **Data Subject Requests**, in the Modules section of the menu (after Attestations), per company. It is where a company handles people exercising their privacy rights, and records every disclosure of personal data. It proves both to an auditor.

- A handler **logs a request** that arrived by email, phone, letter, through a representative, or forwarded by a customer whose data we hold for them. It is numbered `DSR-12`.
- Compass sets the **deadline** from the law that applies, and counts down. It pauses where the law allows, and an extension needs a reason.
- The request is worked in order: **Verify** (identity), **Decide** (each part granted, partly granted or refused, with reasons), **Fulfil** (the systems that hold this kind of person, from Inventory, each recorded), **Tell recipients** (after a correction, erasure or restriction), and **Letters** (filled in from the request, sent by the handler, marked sent).
- It **closes** against a checklist, is marked on time or late, and is **frozen**. After the company's retention period the person's details are **cleared**, and the retention log records it.
- A **Disclosures** log records every one-off disclosure of personal data, authorised or not (unauthorised ones tied to a Privacy incident). Requests to disclose from the police, regulators and courts are decided there too.
- A **Compliance** tab shows how well requests are answered, and exports the logs for an auditor. The library's privacy controls show the module as **Evidence of operation**.

## How it meets the frameworks

The objective: SOC 2's "operationalize data subject request handling and disclosure tracking" (related controls PRV1, PRV2, PRV5, PRV6, PRV13 in the source tool's numbering). The library's PDH controls already map most of it.

| Requirement | Met by |
|---|---|
| SOC 2 P5.1 access · HITRUST 13.f · PDH.10 | Access requests, verified, fulfilled system by system, answered on time |
| SOC 2 P5.2 correction/deletion · PDH.15 | Correction and erasure per system, with "kept because the law requires it" recorded |
| GDPR Art. 18, 20, 21, 22 (restriction, portability, objection, automated decisions) · ISO 27701 7.3.4–7.3.10 | Request types of their own, plus a new library control (COM-1146) |
| GDPR Art. 19 · ISO 27701 7.3.7: tell recipients | The Tell recipients card |
| SOC 2 P6.1–P6.3 · HITRUST 13.c · PDH.16: disclosures authorised and unauthorised | The Disclosures log; unauthorised entries tied to Privacy incidents |
| ISO 27701 8.5.4/8.5.5: legally binding disclosure requests | Requests to disclose, decided by a named approver |
| SOC 2 P6.7 · HIPAA 164.528: an accounting of disclosures | The accounting built from the log |
| SOC 2 P8.1 · HITRUST 13.o · PDH.17 · DUAA 2025 complaints duty | Complaint as a request type; themes on Compliance |
| UK GDPR Art. 12 / DUAA 2025: one month, +2, clock from confirmed ID, pause for clarification | The deadline rules |
| Audit evidence: request logs, templates, fulfilled requests, disclosure records, denial records, retention logs | Compliance tab exports; letters as sent; the retention log |

**Out of scope:** a public request form, or reading the privacy mailbox (Steve: staff log requests); Compass emailing the person; sending tasks to system owners; holding copies of the person's data or ID; the HIPAA Privacy Rule as a framework (Compass's HIPAA covers Security and Breach only); consent management and a record of processing activities (RoPA) export (ADR 0072 §14, still open).

## What Steve decided (2026-10-19)

- **Intake:** staff log every request. Nothing new is exposed to the internet this sprint.
- **Laws:** UK GDPR, EU GDPR, HIPAA and US state privacy (CCPA) all ship as standard deadline rules.
- **Letters:** the handler sends them from the privacy mailbox. Compass fills them in and records them as sent.
- **Fulfilment:** the handler does it all. Nothing goes to system owners.

## What the record has to settle (Claude's calls, not confirmed by Steve)

- **Request types:** Access, Correction, Erasure, Restriction, Objection, Portability, Review of an automated decision, Accounting of disclosures, Opt out of sale or sharing, Complaint. A request can hold several, and **each is decided separately**. It counts down to its earliest deadline.
- **One company per request. `DSR-12`** is one sequence across companies (like INC-12); `DIS-12` for disclosures, `RTD-12` for requests to disclose.
- **Forwarded by a customer:** where we hold the data for a customer, the customer answers. We record our part against the customer's deadline, and the outcome is "Passed to customer".
- **Standard rules are shared.** Each company can switch one off, adjust it or add its own (the Incidents ▸ Settings pattern, COM-1122). A request copies its rule when logged.
- **No ID documents and no response packs in Compass:** only how identity was checked, and what was sent. Data minimisation, and the register shouldn't become the most sensitive store in the company.
- **Restricted requests** follow the incident pattern (ADR 0116 §10): named people only, a redacted row for everyone else, and kept out of search, Actions text, exports and the assistant.
- **Objection to direct marketing can't be refused.**
- **A request to disclose** is approved by someone other than the person who logged it.
- **Disclosures log = one-off disclosures.** Routine sharing with processors stays in Inventory's data asset recipients.
- **Closed requests are frozen.** Corrections are dated notes; reopen is allowed within 30 days, with a reason.
- **Retention:** personal details are cleared 6 years after closing by default (minimum 2, for CCPA). Disclosures are kept 6 years. The counts and outcomes stay. A legal hold, or an open linked incident, skips clearing. Every clearance is logged.
- **Reminders:** owner to-dos for acknowledgement due, waiting on the person 14 days, due in 7 days and 1 day, and overdue. Unowned requests go to every handler. An immediate email inside 24 hours.
- **Permissions:**
  - `dsr.view`
  - `dsr.handle`
  - `dsr.manage_restricted`
  - `dsr.manage_settings`

  Built-in Admin only; starter roles stay frozen.
- **The assistant** can do what the person can, except see restricted requests or mark a letter sent.
- **The library** gains a control for restriction, objection, portability, automated decisions and telling recipients, and the request controls map to ISO 27001 A.5.34.

## Notes (technical)

- Write `decisions/0118-data-subject-requests.md` unless another number has landed (0117 is Attestations). Check every branch, not just main.
- Reuse:
  - Inventory's data asset fields (`data_entities`, `DataAssetContainer`, `DataAssetRecipient`, `processing_role`, `lawful_basis`);
  - the incident restriction pattern and `IncidentLinkKind`;
  - the attachment owner types;
  - Actions sources and `tell_now` (ADR 0055);
  - Evidence of operation `_sources()` (ADR 0115);
  - the ADR 0110 renderer for letters. Per-record merge fields are new.
- Audit every new table. Retention clearing must also clear values from history and activity.
- Most tasks add a migration, so the stack is serial. COM-1146 (library data) is independent once this is in.
- Another session is still on incidents round 2 (COM-1120..1122). Start after it has merged, or re-point `down_revision` at build time.

## Tasks (build order)

1. COM-1130 the module in the menu, Settings ▸ Company, permissions
2. COM-1131 log a request; the register; restricted
3. COM-1132 deadline rules: four laws, pause, extension, company overrides
4. COM-1133 Verify: how identity was checked, no ID copies
5. COM-1134 Decide: per part, reasons, fee; marketing objection always granted
6. COM-1135 the Disclosures log; incident links
7. COM-1136 requests to disclose (police, regulator, court)
8. COM-1137 Fulfil: systems from Inventory, outcome per system, what was provided
9. COM-1138 Tell recipients (Art. 19)
10. COM-1139 accounting of disclosures (HIPAA)
11. COM-1140 Letters: templates, fields, copy/download, mark sent
12. COM-1141 close against a checklist; on time or late; frozen; corrections
13. COM-1142 reminders: Actions and email
14. COM-1143 retention: clear details, retention log, legal hold
15. COM-1144 the Compliance tab and exports
16. COM-1146 library: the new control and A.5.34 mappings (parallel, after this record)
17. COM-1145 Evidence of operation on the privacy controls
18. COM-1147 assistant tools (last)

**Done when:** the ADR is merged and the tasks above match it.