---
id: 01M7ZM0H3WQ90W4GMRNFDBEANS
created: 2026-11-21T17:56:04.348541Z
updated: 2026-11-21T17:57:45.878024Z
type: task
title: Links — an entry links to controls, gaps, risks, SAP entries, documents, decisions, vendors and inventory assets; a register names the controls it's kept for; every linked record shows it back
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 2079
sprint: s64t54m
assignee: steve
label:
- feature
priority: high
task_status: todo
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