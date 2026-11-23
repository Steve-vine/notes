---
id: 01M7ZM0WDN6TFDBT24FZRD05YZ
created: 2026-11-21T17:56:15.925064Z
updated: 2026-11-23T19:36:19.345395Z
type: task
title: Evidence on a register entry — the Add evidence window works on an entry, and the piece's "Used in" lists it
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 2080
sprint: s64t54m
blocked_by:
- 01M7ZM0H3WQ90W4GMRNFDBEANS
comments:
- id: 01M81KGDP8T0H6700GNDEFJZGG
  author: Steve Vine
  at: 2026-11-22T12:25:45.41686Z
  text: |-
    Done — merged in PR #2078 (0fdb6478), migration 0893_register_evidence.

    What changed for people:
    - An entry's page has an Evidence section with the usual Add evidence button, opening the shared window titled "Add evidence to OBL-4 Data Protection Act 2018". Add new works as everywhere else, with the period defaulting to today. Link existing opens filtered to the controls the entry links to plus the controls its register is kept for; the filter can be cleared.
    - Each piece shows its EVD ID, name, type, classification and status. Take off unlinks it from this entry only.
    - A piece's Used in lists "OBL-4 Data Protection Act 2018 · Legal and regulatory obligations", linking to the entry.
    - A per-company register's entry holds its own company's evidence. In a shared register, evidence is added within the company being viewed and shows only there, and so do its History lines.
    - An archived entry keeps its evidence read-only. Once restored, it takes evidence again.
    - Only the register's owner, its editors and administrators add or take off evidence. Anyone who can see the entry reads it, except restricted pieces. Each add and take-off is in the entry's History. People who can see the register can download the entry's files without needing View audit.

    My calls (yours to overturn):
    - Evidence added to an entry isn't also linked by hand to the register's controls or the entry's linked controls, unlike a plan entry's evidence. It's a small change if you want it.
    - The entry's evidence card has Take off only (no Archive or New version), because entry editors don't manage evidence; pieces are archived from their own page.
    - A shared register's entry viewed with no company chosen says "Choose a company to see its evidence for this entry."

    Not done: no Browser smoke journey for entry evidence (the screen crawl visits the entry page).
- id: 01M82XC3QSCAW57CT3QS6ZWFR2
  author: Steve Vine
  at: 2026-11-23T00:37:24.345353Z
  text: |-
    Pre-UAT on staging f73af7daf: Partly. One defect, raised as COM-2102.

    Correction to my earlier comment on this task: it said each piece shows its classification and status. On the card it didn't. COM-2102 adds them.

    - Evidence can be added, new or linked, through the standard window, and the link tab opens filtered to the entry's and register's controls: Partly. The window was titled "Add evidence to ZMA-1 E2E 121 Alpha". New file EVD-100 was added. Link existing opened filtered "On INS.12, INS.5", the filter cleared, and EVD-99 linked. The card left out classification and status (COM-2102). COM-2080/evidence-card-two-pieces.png
    - Used in lists the entry, and Take off unlinks it there only: Passed. EVD-99's Used in listed ZMA-1. After Take off it listed INS.10 alone, and History recorded both steps. COM-2080/used-in.png, used-in-after-take-off.png
    - In a shared register, each company sees only the evidence added within it: Couldn't check. It needs a second company, and the test accounts stay in E2E Test Company.
    - After a reload, an archived entry showed its evidence with no Add evidence or Take off.

    Screenshots are under ~/compass-uat/s64t54m/.
assignee: steve
label:
- feature
priority: medium
task_status: done
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