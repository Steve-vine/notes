---
id: 01M7X85FCF2REWD1JJSYCYX9BY
created: 2026-11-20T19:50:34.639301Z
updated: 2026-11-22T08:13:22.107769Z
type: task
title: Every piece of evidence has an ID (EVD-n), shown wherever the evidence is
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 2039
sprint: s9hexqn
blocked_by:
- 01M7X8522V25P8S181E9VCF5XK
comments:
- id: 01M7XNGHX641R64TZEYSDTTZA0
  author: Steve Vine
  at: 2026-11-20T23:43:49.158784Z
  text: |-
    Done and merged to main (PR #2034, migration 0887).

    What changes:
    - Every piece of evidence in Audit ▸ Evidence has an ID, EVD-n, numbered within its company. Existing evidence was numbered oldest first by date added, archived pieces included.
    - A new piece takes the company's next number whichever way it arrives: an upload, a web address, Evidence Collection, a built-in check run or the User Portal. Numbers are never reused, and the deletion log keeps the ID a deleted piece had.
    - The ID is its own sortable column in the register (and in Archived), and shows on the piece's page. It also shows on the evidence rows of a control, a plan entry, an incident, a risk, a vulnerability, an audit request, a finding's closing evidence and a vendor's certificate.
    - The search box at the top of Compass and Audit ▸ Evidence's search both find a piece by its ID. The address /audit/evidence/EVD-12 goes straight to the piece.
    - Packs and exports list the ID: the audit pack index, the plan export, the request-list spreadsheet, the auditor's zip and the zip downloaded before deleting archived evidence.
    - Polaris shows each piece's ID, and every existing tool that takes evidence also accepts "EVD-12".

    Calls for you to overturn:
    - A piece keeps its number across versions: a replacement file, a renewed vendor certificate, and each new capture of a collected check (EVD-7 v3).
    - A built-in check's results are one piece per check in each company, so that check's line in the register has one stable ID.
    - Trust Centre documents and data subject request files get IDs, because they're in the register.
    - The vendor portal doesn't show the ID, because it's Compass's own reference.

    Left over: on a control's assessment card, the Automatic Collection rows don't show the ID yet. The same pieces show it on the control's Evidence tab and in the register. I've added it to COM-2040.
- id: 01M7YN9Y8KM3M729A9RD107VME
  author: Steve Vine
  at: 2026-11-21T08:59:26.867794Z
  text: |-
    Passed (pre-UAT, staging 7e04d3f5e, E2E Admin A, E2E Test Company).

    Steps and what I saw:
    - Audit ▸ Evidence: ID is the register's own column. Sorting it ascending gives EVD-1, 2, 3…; descending gives EVD-59, 58, 57… (the address becomes ?sort=ref / ?sort=-ref). Every uploaded, plan and check piece in E2E Test Company has an ID: 56 pieces, EVD-1 to EVD-59. EVD-6, 8 and 9 are under Archived, and the Archived tab has the ID column too.
    - The register's search box: "evd-5" found only EVD-5, not EVD-50 to 59.
    - The search at the top of Compass: "EVD-12" found one result, "EVD-12 · e2e-uat4-pentest.pdf", which opened the piece.
    - Typing /audit/evidence/EVD-12 into the address bar went straight to the piece. Its page shows EVD-12 at the top and in the breadcrumb.
    - New pieces took the next numbers (EVD-60 to EVD-78) whichever way they were added: a control, Audit ▸ Evidence, a schedule entry, an audit request, the portal, an incident, a risk or a vulnerability.
    - The ID shows on the evidence rows of a control (Evidence tab and assessment panel), a schedule entry (and Mark done), an audit request, a finding's closing evidence, an incident's Evidence card, a risk and a vulnerability, and in the Add evidence window's Link tab.

    For Steve to look at:
    - About 90 rows in the register are Library documents ("Library · Policy" and so on) with "—" for ID. That fits "pieces of evidence" (they're the Playbook's documents), but they do sit in the register without an ID.
    - An incident timeline entry's files and a notification's copy don't show their EVD IDs, though the pieces have them (EVD-75, EVD-76). Written up under COM-2045.
    - Not checked: the ID in packs and exports (audit pack index, plan export, request spreadsheet, auditor zip).

    Screenshots: ~/compass-uat/s9hexqn/COM-2039/
assignee: steve
label:
- feature
priority: medium
task_status: done
---
Built to the ADR in COM-2038. Steve asked for an ID on evidence that shows in the register and in the new Add evidence window (2026-11-20).

**What people see**
- Every piece of evidence in a company has an ID: **EVD-n**, numbered within that company, with no padding (EVD-7, not EVD-007), following the three-letter reference convention (RSK, GAP, CHB, CHC…).
- **Existing evidence** is numbered in the order it was added, oldest first, per company. Archived pieces are numbered too, so an auditor's earlier reference still finds them.
- **A new piece** takes the next number when it's added: uploaded, linked as a web address, or filed by Evidence Collection or a built-in check run.
- The ID shows in the **register** (Audit ▸ Evidence, as its own sortable column), on **every evidence row** wherever evidence is listed (a control's evidence, a schedule entry, an incident, a risk, a vulnerability, an audit request, a finding's closing evidence), and on the evidence's own details.
- **Search** finds a piece by its ID (global search and the register's search box), and an address with the ID goes straight to it.
- **Audit packs** and exports (the SAP export, a request's evidence, an audit pack's index) list each piece with its ID.
- **Polaris** names evidence by its ID and accepts one wherever it takes evidence ("link EVD-12 to RIM.9").
- Numbers are never reused. Deleting a piece for good leaves a gap.

**Implementation notes**
- Covers both kinds of evidence (files and web addresses) and every owner kind that appears in Audit ▸ Evidence. Places outside the register (DDQ, contracts under review, Trust Centre documents, DSR files) don't need IDs.
- Per-company counter, like CHC-n. Migration backfills by created date, then id.

**Done when**
- Every piece of evidence in the register has an EVD ID, existing pieces numbered by date added.
- The ID shows in the register (sortable), on every evidence row and in packs/exports.
- Search and Polaris find a piece by its ID.

On the chain: migration and API change.