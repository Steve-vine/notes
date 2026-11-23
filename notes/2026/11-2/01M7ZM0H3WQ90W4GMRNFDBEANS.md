---
id: 01M7ZM0H3WQ90W4GMRNFDBEANS
created: 2026-11-21T17:56:04.348541Z
updated: 2026-11-23T00:37:15.998907Z
type: task
title: Links — an entry links to controls, gaps, risks, SAP entries, documents, decisions, vendors and inventory assets; a register names the controls it's kept for; every linked record shows it back
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 2079
sprint: s64t54m
blocked_by:
- 01M7ZM01R4WXTDT5YZ3SBHSXF7
comments:
- id: 01M81GH1GCG19EKZ0F7JARVEEW
  author: Steve Vine
  at: 2026-11-22T11:33:39.980634Z
  text: |-
    Done — merged in PR #2076 (5f58fce3), migration 0892_register_links.

    What changed for people:
    - An entry's Links section lists what it links to, grouped by kind, each with its reference and title as a link. Add link asks what kind (Control, Gap, Risk, SAP entry, Document, Decision, Vendor, Inventory asset), then finds records by reference or title, several at once. Unlink takes one off. Each is a line in the entry's History.
    - A company's gaps, risks, SAP entries, vendors and assets are linked and seen only within that company. In a shared register each company sees only its own links. Controls, documents and decisions show everywhere.
    - A register's Settings have a Controls panel ("This register is kept for INS.5 and INS.12"), and the controls show in its header.
    - A control's page has a Registers section: the registers kept for it and the entries linked to it. A gap, risk, SAP entry, document, decision, vendor or inventory asset shows In registers. Only registers the person can see are listed.
    - When a linked record is deleted, its links go and the entry's History says "RSK-12 deleted", from any screen that deletes it (including a vendor purge). Archiving or closing a record keeps its links.

    My calls (yours to overturn):
    - "In registers" sits beside the existing Incidents card on each record's page.
    - Someone who can't see a kind of record finds none to link, and sees an existing link as "A vendor you can't open".
    - An inventory asset deleted as a duplicate of another loses its register links (History says "AST-3 deleted") rather than moving them to the asset kept.
    - A register's controls are chosen by its owner or someone who can make registers.
    - A control's Registers section needs View the playbook.

    Not done: no Browser smoke journey for links (covered by integration tests).
- id: 01M82XBVJYGES0YSMC8EWW0801
  author: Steve Vine
  at: 2026-11-23T00:37:15.99866Z
  text: |-
    Pre-UAT on staging f73af7daf: Partly. No defects; the rest needs a second company.

    - An entry links to and unlinks from each of the eight kinds, found by reference or title, each change in its history: Passed. ZMA-1 linked to INS.12, GAP-36, RSK-17, SAP-92, a published E2E document, DEC-10, E2E Test Vendor and AST-37. Each link is in History. I unlinked seven of the eight; SAP-92 stays linked. COM-2079/entry-links-eight-kinds.png, history-links-and-evidence.png
    - Links to a company's records are made and seen within that company: Couldn't check. The pickers say "This company's … only", but proving it needs a second company.
    - A register names its controls, and a control's page lists the registers kept for it and the entries linked to it: Passed. INS.5 listed its registers. INS.12 listed registers kept for it and, under Entries linked to it, ZMA-3. COM-2079/viewer-control-registers.png
    - Each linked record shows the entries linking to it, and nobody sees what they couldn't otherwise see: Passed for what I opened. RSK-17 showed ZMA-1 and ZRS-1 to Admin A, but only ZMA-1 to Viewer. E2E Test Vendor showed ZMA-1. INS.5 hid ZRS from Viewer. Couldn't check: In registers on a gap, SAP entry, document, decision or asset. COM-2079/viewer-risk-in-registers.png

    Screenshots are under ~/compass-uat/s64t54m/.
assignee: steve
label:
- feature
priority: high
task_status: review
---
Sprint "Registers" (ADR in COM-2076). Builds on COM-2078.

## What people see

**An entry's links**
- The entry page has a **Links** section. **Add link** first asks what kind:
  - Control
  - Gap
  - Risk
  - SAP entry
  - Document (published Content)
  - Decision
  - Vendor
  - Inventory asset (technology, software or data)
- Then it searches for the record by its reference or title. Several can be picked at once.
- Each link shows the record's reference and title (INS.5, RSK-12, SAP-14, AST-3…) as a link to it, grouped by kind. **Unlink** takes it off.
- Linking and unlinking are recorded in the entry's history.

**Company records** (gaps, risks, SAP entries, vendors, inventory assets) belong to one company:
- In a per-company register, an entry links only to its own company's records.
- In a shared register, an entry links to the records of the company being viewed. Those links show only when viewing that company. So OBL-4 can link to Moneypenny's risk RSK-12 and to another company's RSK-3, and each company sees only its own.
- Controls, documents and decisions are shared by every company, so their links show everywhere.

**The controls a register is kept for**
- The register's Settings name the controls it's kept for ("This register is kept for INS.5 and INS.12").
- They show in the register's header, and they're where COM-2083 files the register's review as evidence.

**Shown back on the linked record**
- **A control's page** has a **Registers** section listing:
  - the registers kept for it
  - the entries linked to it, each with its register's name
- **A gap, risk, SAP entry, document, decision, vendor or inventory asset** shows **In registers**: the entries that link to it, each as "OBL-4 Data Protection Act 2018 · Legal and regulatory obligations".
- Only registers and entries the person can see are listed, so a Restricted register stays invisible.

**When a linked record goes**
- If a linked record is deleted, the link goes, and the entry's history records "RSK-12 deleted".
- If the record is archived or closed, the link stays.

**Who can do what**
- The register's owner, its editors and administrators add and remove an entry's links.
- Choosing which controls a register is kept for is part of its Settings (COM-2077's rules).
- Linking doesn't change who can see the other record.

## Implementation notes (technical)

- One link table: entry, kind, target ID, and company where the target belongs to one. Check the target exists and is in the right company when the link is made. Clean up on target delete (by cascade, or the delete paths that already clean up links).
- One link table for a register's controls.
- Control page, risk, gap, SAP entry, document, decision, vendor and asset detail responses gain an "in registers" list. Filter it by the person's register visibility on the server, never in the browser.
- Watch the route-docstring-as-OpenAPI-contract rule (regenerate schema.d.ts) and Pydantic schema name clashes across api/v1 modules.

## Done when
- An entry can link to and unlink from each of the eight kinds of record, found by reference or title, with each change in its history.
- Links to a company's records are made and seen within that company. In a shared register, each company sees only its own.
- A register can name the controls it's kept for, and a control's page lists the registers kept for it and the entries linked to it.
- Each linked record shows the entries that link to it. Nobody sees an entry or register they couldn't otherwise see.

On the chain: migration and API.