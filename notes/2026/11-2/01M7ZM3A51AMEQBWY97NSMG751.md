---
id: 01M7ZM3A51AMEQBWY97NSMG751
created: 2026-11-21T17:57:35.521469Z
updated: 2026-11-21T17:58:09.753484Z
type: task
title: Templates — start the Obligations, Incident contacts and Management review actions registers ready-made and linked to their controls; a register named like one Compass already keeps points there
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 2084
sprint: s64t54m
blocked_by:
- 01M7ZM2F7JZ3N6PTQWXW4VNN6T
assignee: steve
label:
- feature
priority: medium
task_status: todo
---
Sprint "Registers" (ADR in COM-2076). Builds on COM-2083: the templates set a review cycle, reminder dates and a Responsible person, so everything they use has to exist first.

## What people see

**New register ▸ From a template** offers three templates. Each shows its fields and controls before it's created. The name, prefix and owner can be changed, and fields can be changed afterwards like any register's.

**1. Legal, regulatory and contractual obligations**
- Prefix OBL. One list for every company. Kept for INS.5 and INS.12. Reviewed every 12 months.
- One register for obligations and the parties they come from, so INS.5 and INS.12 are met by the same list (Steve agreed, 2026-11-21).
- Fields:
  - **Obligation** (the Title)
  - **Kind**: choice of Law, Regulation, Contract, Code of practice, Standard, Customer expectation
  - **Source**, e.g. "UK GDPR Art. 32" or a contract's name
  - **Who it comes from**: the interested party, e.g. ICO, a customer, the card schemes
  - **Jurisdiction**: choice of UK, EU, US, International, Other
  - **What it requires of us** (long text)
  - **How we meet it** (long text). Links to the controls and documents go in Links.
  - **Applies to** (Company)
  - **Status**: choice of Met, Partly met, Not met, Not yet assessed
  - **Owner** (Person, Responsible)
  - **Next review** (Date, reminds 30 days before)

**2. Incident contacts**
- Prefix CON. A list for each company. Kept for IMA.3. Reviewed every 6 months.
- Fields:
  - **Contact** (the Title)
  - **Organisation**
  - **Kind**: choice of Regulator, Law enforcement, Insurer, Supplier, Customer, Legal, Forensics, Internal, Other
  - **When to contact them** (long text)
  - **Notification deadline**, e.g. "72 hours from awareness"
  - **Phone**
  - **Out-of-hours phone**
  - **Email**
  - **Web address** (a reporting portal)
  - **Last checked** (Date, reminds 30 days before it's six months old)
  - **Owner** (Person, Responsible)
- **Print this register** is offered on its page: IMA.3 asks where the list is held for a systems-down scenario. It's the COM-2082 PDF.

**3. Management review actions**
- Prefix MRA. A list for each company. Kept for INS.6 and INS.19. Reviewed every 12 months.
- Fields:
  - **Action** (the Title)
  - **From the review on** (Date)
  - **Owner** (Person, Responsible)
  - **Due** (Date, reminds 14 days before)
  - **Status**: choice of Open, In progress, Done, Dropped
  - **Completed on** (Date)
  - **Notes** (long text)

Making a register from a template whose prefix is taken (say, a second OBL register) asks for another prefix.

**A register Compass already keeps**
- On **New register**, a name that reads like a register Compass already holds shows a note under the name, with a link: "Compass already keeps this in Risks — open Risks". It only advises; creating the register is still allowed.
- The names it recognises:
  - risk → Risks
  - asset or inventory → Inventory
  - software → Inventory ▸ Software
  - data or information asset → Inventory ▸ Data
  - vendor or supplier → Vendor Management
  - policy → Content
  - exception → Exceptions
  - finding or deficiency → Audits
  - disclosure or subject access → Data Subject Requests
  - secret, key or certificate → Secrets
  - incident → Incidents
  - vulnerability → Vulnerabilities

## Implementation notes (technical)

- Templates are code-defined data (a list of definitions), not database rows. Creating from one makes an ordinary register; nothing stays tied to the template.
- Controls are named by ref. A ref the library doesn't have is skipped, and the preview says so.
- The name-match note is a client-side keyword check with a server-provided list of (keywords → page) pairs, so the list lives in one place.

## Done when
- Each of the three templates creates a register with its fields, prefix, Shared or per company setting, controls, review cycle, reminder dates and Responsible person as listed. Name, prefix and owner can be changed first.
- Incident contacts can be printed from its page.
- Typing a name like "Risk register" or "Supplier list" on New register shows where Compass already keeps it, without blocking.

On the chain: API.