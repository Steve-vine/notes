---
id: 01M7X85FCF2REWD1JJSYCYX9BY
created: 2026-11-20T19:50:34.639301Z
updated: 2026-11-20T19:52:38.801426Z
type: task
title: Every piece of evidence has an ID (EVD-n), shown wherever the evidence is
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 2039
sprint: s9hexqn
blocked_by:
- 01M7X8522V25P8S181E9VCF5XK
assignee: steve
label:
- feature
priority: medium
task_status: todo
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