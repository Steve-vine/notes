---
id: 01M5B0GF6H4CN109GC59RMKQB0
created: 2026-10-19T21:19:02.865304Z
updated: 2026-10-20T18:05:46.112792Z
type: task
title: An accounting of disclosures request builds the person's list from the Disclosures log — six years back, each with date, recipient, what and why — the handler leaves out what the law excludes with a reason, and it goes into the response
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1139
sprint: ss8348q
blocked_by:
- 01M5B0G32ZT11PJMF745NCDNGE
comments:
- id: 01M5BMZYXBPYA1ASEDBCQD5HWF
  author: Steve Vine
  at: 2026-10-20T03:17:01.995332Z
  text: |-
    Done — merged (PR #1136).

    - When an accounting of disclosures is granted, the Fulfil area shows an **Accounting of disclosures** card: every Disclosures log entry naming the person (any capitalisation, or linked to this request) in the six years before the request arrived, each with date, recipient (name and address), what, why and basis.
    - Group entries for their kind of person appear underneath under **"May include them"**, unticked; ticking one adds it.
    - **Leave out** takes a reason from the HIPAA list or a note. A law-enforcement suspension needs its end date: the line is held out until then and listed again afterwards, and the card says so. **Put back** undoes it.
    - **Change the period** shortens the six years (never lengthens).
    - **Add to response** keeps the accounting exactly as given, notes it on the timeline, and puts the table into the response letter. A new standard letter, "Response: accounting of disclosures", is suggested when that's the only granted part.
    - **Download** as PDF (house style) or CSV.
    - The card says whether this is the first accounting in 12 months (free) or names the earlier one, so a fee can be recorded in Decide.
    - A **UK or EU GDPR access request** gets the same list as its recipients information, with nothing left out.
    - Letters' "Systems we searched" and "Accounting of disclosures" fields now fill in.
    - Closing (COM-1141) requires the accounting to have been added to the response.

    My calls: if some disclosures about the person are restricted from the handler, Add to response and the downloads are refused (and the hidden ones are counted on the card), so an incomplete accounting can't go out; downloads show the list as it stands now, not the copy taken at Add to response; unauthorised disclosures are listed with the basis "Not authorised — a data breach".
assignee: steve
label:
- feature
priority: medium
task_status: done
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