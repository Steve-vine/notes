---
id: 01M5B0GF6H4CN109GC59RMKQB0
created: 2026-10-19T21:19:02.865304Z
updated: 2026-10-19T21:22:10.455529Z
type: task
title: An accounting of disclosures request builds the person's list from the Disclosures log — six years back, each with date, recipient, what and why — the handler leaves out what the law excludes with a reason, and it goes into the response
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1139
sprint: ss8348q
blocked_by:
- 01M5B0G32ZT11PJMF745NCDNGE
assignee: steve
label:
- feature
priority: medium
task_status: todo
---
Sprint 79, Data Privacy (ADR in COM-1129). Meets HIPAA 164.528 (an accounting of disclosures of a person's health information in the six years before the request), SOC 2 P6.7 (an accounting of what is held and disclosed), and HITRUST 13.c.

## What people see

When a request includes **Accounting of disclosures**, its Fulfil card has an **Accounting** section:

- Compass lists every Disclosures log entry that **names this person** (by name, or linked to this request's person) in the **six years** before the request was received. The period can be shortened if the person asked for less. Group entries for their kind of person are listed below as "may include them", unticked.
- Each line shows date, recipient (name and address), what was disclosed and why, and the basis.
- The handler can **leave a line out**, with a reason from a short list (for HIPAA: treatment, payment or health care operations; to the person themselves; with their authorisation; national security; to law enforcement under a suspension the agency asked for, with its end date; incidental) or a note.
- **Add to response**: the accounting, as a table, goes into the fulfilment letter (Letters task). It is also downloadable as PDF and CSV.

## Rules

- A law-enforcement **suspension** (HIPAA 164.528(a)(2)) holds that line out until its end date. After that it appears. The section says so.
- The first accounting in any 12 months is free. A fee can be recorded for further ones (the Decide task's fee).
- For UK/EU GDPR access requests, the same list (with nothing left out) feeds the "recipients" part of the access response: the Art. 15(1)(c) supplementary information. The Fulfil card offers it.

## Notes (technical)

- A read over the disclosures' about-people rows, plus inclusion/exclusion rows on the request, so the accounting given is reproducible.
- PDF through the existing renderer (`core/render/document.py`).

**Done when:** a person named in three disclosures over the last six years gets an accounting of those three; one excluded line records why; the table goes into the response.