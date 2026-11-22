---
id: 01M7ZM3A51AMEQBWY97NSMG751
created: 2026-11-21T17:57:35.521469Z
updated: 2026-11-22T22:56:32.685165Z
type: task
title: Templates — start the Obligations, Interested parties, Obligations and interested parties, Incident contacts and Management review actions registers ready-made and linked to their controls; a note when a control or a name is already kept elsewhere
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 2084
sprint: s64t54m
blocked_by:
- 01M7ZM2F7JZ3N6PTQWXW4VNN6T
- 01M815RVX08HB95ZW5QHTC8JHV
comments:
- id: 01M82QK7M4EJP6R4NP5TCJ9DG7
  author: Steve Vine
  at: 2026-11-22T22:56:26.244051Z
  text: |-
    Built and merged to main (PR #2083, f73af7daf).

    What changed for people
    - New register ▸ From a template offers five ready-made registers: Legal, regulatory and contractual obligations (OBL), Interested parties (PTY), Obligations and interested parties (OIP), Incident contacts (CON) and Management review actions (MRA). Each shows its fields, controls, companies and review cycle first. The name, prefix and owner can be changed, and the result is an ordinary register.
    - A taken prefix asks for another. A second OBL says who has it and waits for a new one. OBL, PTY and OIP sit side by side without a clash.
    - A control already kept by another register gets a note, in the template preview and when controls are added to any register: "INS.5 is already kept by Obligations and interested parties (OIP)", with a link. It never blocks. A Restricted register the person can't open is named only as "a Restricted register".
    - A name Compass already keeps gets a note on New register: "Compass already keeps this in Risks — open Risks". It never blocks.
    - Print this register is on Incident contacts' page: a PDF of every current entry, for when systems are down. Any register's owner can switch it on or off in its details.
    - A date can say when something was last done. Incident contacts' Last checked falls due again six months later and reminds 30 days before then. Any Date field can be set this way.

    My calls (for Steve to overturn)
    - This task added a small database change it didn't expect (migration 0895_register_templates). "30 days before it's six months old" couldn't be expressed otherwise, and it keeps Print as a setting on the register rather than code that knows about Incident contacts.
    - "Key" alone would flag "Key contacts" as Secrets, so a Secrets match is dropped when the name also says contact, control, date, holder, people, person, personnel or role. "Incident contacts" isn't matched to Incidents either.
    - Someone who owns a register but can't see registers generally is told "another register" for an unrestricted register they can't open, because "a Restricted register" would be untrue.
    - Templates name controls by their on-screen reference, as the task says. If INS.5, INS.6, INS.12, INS.19 or IMA.3 are ever renumbered, the template data needs updating.
assignee: steve
label:
- feature
priority: medium
task_status: review
---
Sprint "Registers" (ADR 0165 in COM-2076; ADR 0166 in COM-2086). Builds on COM-2083: the templates set a review cycle, reminder dates and a Responsible person, so everything they use has to exist first.

## What people see

**New register ▸ From a template** offers five templates. Each shows its fields and controls before it's created. The name, prefix and owner can be changed, and fields can be changed afterwards like any register's.

For INS.5 and INS.12 there are three, so they can be kept separately or together (ADR 0166, Steve 2026-11-22). Each has its own prefix, so any mix can be made side by side.

**1. Legal, regulatory and contractual obligations**
- Prefix OBL. One list for every company. Kept for INS.5. Reviewed every 12 months.
- Fields:
  - **Obligation** (the Title)
  - **Kind**: choice of Law, Regulation, Contract, Code of practice, Standard
  - **Source**, e.g. "UK GDPR Art. 32" or a contract's name
  - **Jurisdiction**: choice of UK, EU, US, International, Other
  - **What it requires of us** (long text)
  - **How we meet it** (long text). Links to the controls and documents go in Links.
  - **Applies to** (Company)
  - **Status**: choice of Met, Partly met, Not met, Not yet assessed
  - **Owner** (Person, Responsible)
  - **Next review** (Date, reminds 30 days before)

**2. Interested parties**
- Prefix PTY. One list for every company. Kept for INS.12. Reviewed every 12 months.
- Fields:
  - **Party** (the Title), e.g. ICO, Acme Ltd, our cyber insurer
  - **Type**: choice of Customer, Regulator, Insurer, Investor or owner, Staff, Supplier, Certification body, Public, Other
  - **What they expect of us** (long text)
  - **Where it's set out**, e.g. "Master services agreement, schedule 4", "UK GDPR", "Not written down"
  - **How we meet it** (long text)
  - **Applies to** (Company)
  - **Relationship owner** (Person, Responsible)
  - **Next review** (Date, reminds 30 days before)

**3. Obligations and interested parties**
- Prefix OIP. One list for every company. Kept for INS.5 and INS.12. Reviewed every 12 months.
- Every entry is an obligation or expectation together with the party it's owed to. Read as a list it answers INS.5; grouped or filtered by party it answers INS.12.
- Fields:
  - **Obligation or expectation** (the Title)
  - **Kind**: choice of Law, Regulation, Contract, Code of practice, Standard, Expectation (not written down)
  - **Source**
  - **Owed to**: the interested party, e.g. ICO, a customer, the card schemes
  - **Party type**: the same choices as Interested parties' Type
  - **Jurisdiction**: choice of UK, EU, US, International, Other
  - **What it requires of us** (long text)
  - **How we meet it** (long text)
  - **Applies to** (Company)
  - **Status**: choice of Met, Partly met, Not met, Not yet assessed
  - **Owner** (Person, Responsible)
  - **Next review** (Date, reminds 30 days before)

**4. Incident contacts**
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

**5. Management review actions**
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

**A control already kept by another register** (ADR 0166 §2)
- When a register is about to be kept for a control that another register (not archived) already keeps, a note names it with a link: "INS.5 is already kept by Obligations and interested parties (OIP)".
- It shows in the template preview and when someone adds a control to any register (the Controls links from COM-2079).
- It advises; creating the register or adding the control is still allowed.
- A Restricted register the person can't open is named only as "a Restricted register", without a name or link.

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
- The control note: a query for other non-archived registers linked to the same control, returned as a `warnings` list beside the result (template preview, and the add-control-link response from COM-2079), never an error. Filter Restricted registers the caller can't see down to an anonymous mention.
- The name-match note is a client-side keyword check with a server-provided list of (keywords → page) pairs, so the list lives in one place.
- Linking an Interested parties entry to Obligations entries (entry-to-entry across registers) is second sprint, not here.

## Done when
- Each of the five templates creates a register with its fields, prefix, Shared or per company setting, controls, review cycle, reminder dates and Responsible person as listed. Name, prefix and owner can be changed first.
- OBL, PTY and OIP can all be made in the same Compass without a prefix clash.
- Making OIP when OBL already exists shows "INS.5 is already kept by …" in the preview; so does adding INS.5 to any register's controls. Neither is blocked.
- Incident contacts can be printed from its page.
- Typing a name like "Risk register" or "Supplier list" on New register shows where Compass already keeps it, without blocking.

On the chain: API.