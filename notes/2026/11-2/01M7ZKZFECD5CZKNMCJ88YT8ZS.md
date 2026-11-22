---
id: 01M7ZKZFECD5CZKNMCJ88YT8ZS
created: 2026-11-21T17:55:29.868183Z
updated: 2026-11-22T08:36:09.975605Z
type: task
title: Registers and their fields — someone who can edit Content makes a register (name, prefix, owner, editors, shared or per company) and defines its fields; Assurance ▸ Registers lists them
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 2077
sprint: s64t54m
blocked_by:
- 01M7ZKYVNWPJX322TKWFH428HY
assignee: steve
label:
- feature
priority: high
task_status: active
---
Sprint "Registers" (ADR in COM-2076). The first build task: the register itself and its fields. Entries come in COM-2078.

## What people see

**Assurance ▸ Registers** is a new page in the menu, after Evidence. It lists the registers the person can see, with these columns:
- name
- owner
- **Shared** or **Per company**
- number of entries (for the current company, if it's a per-company register)
- last reviewed and next review (empty until COM-2083)

When there are no registers yet, the page explains what a register is and offers **New register**.

**New register** is offered to administrators and anyone who can edit Content. It asks for:
- **Name** and **Description**.
- **Reference prefix:** three capital letters (ADR 0157). It must be unique across Compass and can't be one Compass already uses (RSK, GAP, EVD, SAP, CHB, CHC, DEC, CRV, RAS, WFL, INC, AUD…). It can't be changed once the register has entries.
- **Owner:** one person.
- **Editors:** any number of people.
- **One list for every company** or **A list for each company** (Steve, 2026-11-21). This can't be changed once there are entries.
- **Restricted:** only the owner, editors and administrators see it.

**Fields**
- Every register starts with a **Title** field, which can be renamed but not removed. Its value is how an entry is named everywhere.
- **Add field** offers Text, Long text, Number, Date, Choice, Multiple choice, Yes/No, Web address, Person and Company.
- Each field has a name, an optional hint shown under it, and **Required** or not. Choice fields also have their list of values. Fields are put in order by dragging.
- **A Date field can remind:** "Remind as this date nears", with how many days before (default 30). The reminders themselves come in COM-2083.
- **One Person field can be marked Responsible.** That person gets the entry's reminders; if no field is marked, the owner does.
- **A Company field can hold several companies.** In a shared register it's how an entry says which companies it applies to.

**Changing fields once there are entries (Steve, 2026-11-21)**
- Rename a field, change its hint, reorder fields, add fields and add choice values: all allowed at any time.
- **Remove a field:** it disappears from the screens and exports. Its values stay in each entry's history, and the register as it stood on an earlier date (COM-2082) still shows it.
- **Remove a choice value:** entries that already have it keep it, marked "(retired)". It's no longer offered.
- **Make a field required:** existing entries without a value aren't changed, and are shown as incomplete.
- **Type changes:** only Text → Long text and Choice → Multiple choice.

**A register's life**
- A register with no entries can be deleted.
- A register with entries can be **archived**. It becomes read-only, is hidden from the list by default (an Archived filter shows it), and can still be opened and exported. It can be restored.
- Every change to a register's details or fields is recorded in the activity log.

**Who can do what (ADR 0165 §10)**
- **View registers** (`registers.view`): opens the page and every register that isn't Restricted. The migration gives it to every role holding View the playbook. Restricted registers are seen only by their owner, editors and administrators.
- **Make registers and change their fields** (`registers.manage`): the migration gives it to every role holding Author playbook content, so administrators and the people who edit Content hold it.
- **Changing a register's details:** the owner can change its description, editors and review settings. The name, prefix, fields and Shared or per company are changed only by someone who can make registers.

## Implementation notes (technical)

- New tables for registers and fields. Each field has a **stable ID**, and entry values (COM-2078) are keyed by that ID, so a rename touches no data.
- A removed field is soft-deleted (it keeps a removed-at date), never dropped.
- Choice values have stable IDs too, so renaming a value keeps the entries that use it.
- Prefix uniqueness is checked against every register and Compass's own reserved prefixes, held as one list in code.
- Add both permissions to the catalogue, with a migration granting them as above. Add the page to the floating menu's Assurance group (ADR 0165 amends ADR 0152 §5) and to the Browser smoke.
- Follow `brief/information-architecture.md` → Screen conventions. A row of fields with hints is a FieldRow (COM-1623). Sortable table headers use SortableTh.

## Done when
- Someone who can edit Content can make a register with fields of every type, reorder them, and set Required, reminders and Responsible.
- Assurance ▸ Registers lists it with its owner and whether it's shared or per company. A Restricted register is invisible to anyone who isn't its owner, an editor or an administrator.
- Renaming, adding and removing fields and choice values behave as above, and a removed field's values aren't lost.
- A prefix already in use, or one of Compass's own, is refused with the reason.
- An empty register can be deleted. One with entries can only be archived and restored.

On the chain: migration and API.