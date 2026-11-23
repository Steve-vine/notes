---
id: 01M7ZKYVNWPJX322TKWFH428HY
created: 2026-11-21T17:55:09.628498Z
updated: 2026-11-23T19:36:19.282031Z
type: task
title: 'ADR: Registers — people define their own registers, keep entries linked to the rest of Compass, review them on a cycle, and can show any register as it stood on a date'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 2076
sprint: s64t54m
comments:
- id: 01M7ZM9T5YB6ERGZFVJ471P3KK
  author: Steve Vine
  at: 2026-11-21T18:01:08.542662Z
  text: |-
    Done. ADR 0165, "Registers", is accepted and merged to main (PR #2068). It's documentation only: no migration and no API change.

    What it records:
    - A register is defined on screen: name, three-letter prefix, owner, editors, shared or per company, Restricted, and the controls it's kept for. It sits under Assurance ▸ Registers, after Evidence (amends ADR 0152 §5).
    - Eleven field types. Date fields can remind, one Person field can be Responsible, and a Company field says where an entry applies. Fields rename and add freely; removing one hides it and keeps its values. Only Text → Long text and Choice → Multiple choice can change type.
    - Entries have IDs (OBL-4) and full history, and are archived with a reason, never deleted.
    - Entries link to controls, gaps, risks, SAP entries, documents, decisions, vendors and assets. A company's records are linked and seen only within that company. Evidence comes through the Add evidence window.
    - Any register can be shown as at a date, exported (CSV, Excel, PDF) and imported.
    - Mark as reviewed files a PDF of the register as evidence on its controls in each applicable company and completes a due SAP entry. Reviews and entry dates remind through Actions.
    - Templates: OBL (shared, INS.5 + INS.12), CON (per company, IMA.3), MRA (per company, INS.6, INS.19).
    - Permissions: View registers (given to View the playbook holders) and Make registers and change their fields (given to Author playbook content holders). Entry editing belongs to the register's owner and editors.
    - Second sprint, recorded but not built: Polaris, Workflows, audit packs, update-on-import.

    Briefs updated: data model, feature set, information architecture (menu groups and module table), permission catalogue, and CLAUDE.md's Key ADRs line.

    Calls for Steve to overturn (listed in the ADR):
    1. Registers sit in Assurance.
    2. View registers goes to everyone who can view the playbook.
    3. The prefix and shared/per company are fixed once there are entries.
    4. Entries are never deleted.
    5. Obligations and interested parties are one template.
    6. A review files evidence in every company where the register's controls apply, and completes only a SAP entry whose due window has started.
assignee: steve
label:
- brief
priority: high
task_status: done
---
Write the ADR the rest of the Registers sprint is built to. ADR 0165 is the next free number on main as of 2026-11-21. The Guided procedures planning had its eye on 0165+, so check main and open branches before merging.

**Why (Steve, 2026-11-21)**
INS.5 asks for a register of legal, regulatory and contractual obligations. Steve keeps it in a spreadsheet. A sweep of the control library found about 60 registers, inventories and logs named as evidence. Most already live in Compass (Risks, Inventory, Vendors, Content, Data Subject Requests, Audit findings, Exceptions, Secrets, Incidents). A handful are kept by hand and reviewed once a year, and none has a home: obligations (INS.5), interested parties (INS.12), incident contacts (IMA.3) and management review actions (INS.6, INS.19). Steve chose one general Registers module over a feature for each.

**What it records**
- **A register is defined on screen:** name, description, a three-letter reference prefix (ADR 0157), owner, editors, its fields, and the controls it's kept for.
- **Field types:** Title (always first), Text, Long text, Number, Date, Choice, Multiple choice, Yes/No, Web address, Person and Company.
- **Fields Compass acts on:** a Date field can **remind** as it nears and once it passes. One Person field can be marked **Responsible**, and that person gets the reminders. In a shared register, a Company field says which companies an entry applies to.
- **Shared or per company (Steve, 2026-11-21):** each register chooses one list for every company or a list for each company.
- **Who does what (Steve, 2026-11-21):** administrators and anyone who can edit Content create registers and change their fields. Entries are added and edited by the register's owner and the editors they name, and by administrators. A register can be **Restricted**, so only its owner, editors and administrators see it.
- **Changing fields (Steve, 2026-11-21):** fields can be renamed and added freely. Removing a field hides it, and its values stay in each entry's history. Choice values can be added; a removed value stays on entries that have it, marked retired. Only Text → Long text and Choice → Multiple choice can change type.
- **Entries:** every entry gets an ID (OBL-4) and a full history (who, when, before → after). Entries are archived with a reason, never deleted.
- **Links:** an entry can link to controls, gaps, risks, SAP entries, documents, decisions, vendors and inventory assets. Each linked record shows the entry back. Evidence comes through the Add evidence window (ADR 0164).
- **Proof for an auditor:** any register can be shown as it stood on a date. It can be exported to CSV, Excel or PDF, and imported from a spreadsheet.
- **Review cycle:** a register has a review cycle. **Mark as reviewed** records who, when and a comment. The review is filed as evidence on the register's controls, and it completes a linked SAP entry that's due.
- **Templates:** three starting points for registers Compass doesn't already keep. Obligations covers INS.5 and INS.12 as one register. The other two are Incident contacts (IMA.3) and Management review actions (INS.6, INS.19). A register named like one Compass already keeps (risks, assets, vendors…) points there, but isn't blocked.
- **Where it goes:** the Registers page sits in the **Assurance** group of the menu, after Evidence ("How we prove it's all working"). This amends ADR 0152's group table.
- **Later (second sprint), recorded but not built here:** Polaris reads and adds entries (its own MCP area, ADR 0144). Workflows read a register. Audit packs include a register as it stood during the audit period. Import can also update existing entries by ID.

**Technical decision to record:** values are held per entry keyed by each field's stable ID, so renaming a field touches no data. They are checked against the field definitions on every write. Each change keeps a full revision of the entry, which is what makes "as it stood on a date" possible.

Brief updates: `brief/data-model.md` (registers, fields, entries, revisions, links), `brief/information-architecture.md` (Assurance ▸ Registers, the menu table, the permission catalogue), `brief/feature-set-and-phasing.md`, and CLAUDE.md's Key ADRs line.

**Done when**
- The ADR is merged and accepted, and the briefs above say the same.

Independent: no migration and no API change.