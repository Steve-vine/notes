---
id: 01M7ZM0WDN6TFDBT24FZRD05YZ
created: 2026-11-21T17:56:15.925064Z
updated: 2026-11-22T11:33:53.451905Z
type: task
title: Evidence on a register entry — the Add evidence window works on an entry, and the piece's "Used in" lists it
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 2080
sprint: s64t54m
blocked_by:
- 01M7ZM0H3WQ90W4GMRNFDBEANS
assignee: steve
label:
- feature
priority: medium
task_status: active
---
Sprint "Registers" (ADR in COM-2076). Builds on COM-2079 and on ADR 0164 (Evidence Improvements: one piece of evidence held once and used in many places, and the Add evidence window from COM-2041 and COM-2042).

## What people see

- The entry page has an **Evidence** section with the same **Add evidence** button as everywhere else. It opens the same window, titled "Add evidence to OBL-4 Data Protection Act 2018".
  - **Add new evidence** works as it does everywhere: type and classification required, with dates filled in. The period defaults to the day it's added.
  - **Link existing evidence** opens filtered to evidence on the controls the entry links to, plus the controls its register is kept for. The filter can be cleared.
- Each piece shows with its EVD ID, name, type, classification and status, as on other records. **Take off** unlinks it from this entry only (ADR 0164 §6).
- A piece's details list the entry under **Used in** ("OBL-4 Data Protection Act 2018 · Legal and regulatory obligations").
- **Evidence belongs to a company:**
  - In a per-company register, it's the entry's company's evidence.
  - In a shared register, it's added within the company being viewed and shows only there. Each company keeps its own proof for a shared obligation.
- **An archived entry keeps its evidence**, read-only. Archiving a piece still archives it everywhere (ADR 0164).
- Adding and taking off evidence is recorded in the entry's history.
- **Who:** the register's owner, its editors and administrators add and take off evidence. Anyone who can see the entry sees its evidence, unless the piece itself is restricted (ADR 0122 §2).

## Implementation notes (technical)

- Register entries become one more kind of record in the evidence-link model from ADR 0164 §1. Use the one add-evidence API and the shared window component. No per-area upload route.
- The entry editors' rule is the area's permission check for adding and taking off.
- "Used in" gains the entry kind, with a link to the entry page.

## Done when
- Evidence can be added to an entry, new or linked from the register, through the standard window. The link tab opens filtered to the entry's and register's controls.
- The piece's Used in lists the entry, and Take off unlinks it there only.
- In a shared register, each company sees only the evidence added within it.

On the chain: migration and API.