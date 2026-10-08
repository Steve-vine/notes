---
id: 01M4DVMQYWJV55JESQVYF0CT7J
created: 2026-10-08T13:36:01.500201Z
updated: 2026-10-08T13:37:12.461443Z
type: task
title: Admin ▸ Joiner fields offers the rest of the contact, name and organisation details — for Active Directory and Entra ID
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 864
sprint: sme8esk
blocked_by:
- 01M4DTGAG6GYPPRJ294BK42TV9
assignee: steve
label:
- feature
priority: medium
task_status: todo
---
Asked for by Steve, 2026-10-08, with COM-863 (the mirror keeps every account detail). Steve wants every detail that can be set on an account to be choosable — not just today's list.

**Blocked by COM-863.** That task makes the mirror follow the catalogue, so each detail added here is mirrored (and shown on the move form) without further work.

## What people see

- **Admin ▸ Joiner fields** lists more details to choose from, for each directory. Chosen ones can be relabelled, as today.
- A chosen detail is asked for on the **new-joiner form**, can be given a **default on a business role**, appears in **Account details on the move form**, and is written to the account when the request runs — exactly as the existing details are.
- Nothing appears anywhere until an admin chooses it.

## The details added (one value each)

**Active Directory**
- Name parts: Middle name (`middleName`), Title (`personalTitle`), Suffix (`generationQualifier`)
- Organisation: Division (`division`)
- Contact: Home phone (`homePhone`), Pager (`pager`), Fax (`facsimileTelephoneNumber`), IP phone (`ipPhone`), Web page (`wWWHomePage`), PO Box (`postOfficeBox`)

**Entra ID**
- Organisation: Division and Cost centre (`employeeOrgData.division`, `.costCenter`), Usage location (`usageLocation`)
- Contact: Business phone (`businessPhones`), Fax (`faxNumber`), Preferred language (`preferredLanguage`)

Entra has no middle name, title or suffix to set.

## Not in this task

- **Details that hold several values** — the "other" phone numbers and other email addresses. They need a new kind of field; that is the next task.
- **Leave date** (Entra `employeeLeaveDateTime`). Reading or setting it needs an extra permission granted in the tenant. Say if it's wanted.
- **Email aliases.** Not settable through Entra — they belong to Exchange. They are shown read-only on the user record instead (separate task).

## How (implementation)

Catalogue entries in `core/joiner_fields.py` (`_ACTIVE_DIRECTORY`, `_ENTRA_ID`). Most are plain `text` and need nothing else — the admin screen, role defaults, both forms, the request page and the writers (`account_details.plan_ad` / `plan_entra`) are all catalogue-driven. Three need care:

- **`employeeOrgData.*`** — a container, like `onPremisesExtensionAttributes`: use `graph_container="employeeOrgData"`. Check the PATCH shape `_put` builds is what Graph accepts for this container, and that a clear sends null for the one key, not the whole object.
- **`businessPhones`** — a list in Graph that accepts exactly one number. One text box; read the first item, write a one-item list (empty list to clear). Don't model it as several values.
- **`usageLocation`** — a country, but written as the two-letter code, where Entra's existing Country/region writes the *name*. Either a flag on the entry or a second country kind; the reading side (`_entra_country`) already resolves both ways.

Also:
- AD length limits differ by attribute (e.g. `initials` 6, phone numbers 64). Check what `validate_value` enforces today (`MAX_VALUE_LENGTH = 1024`) and whether a per-entry maximum is needed so an over-long value is refused on the form, not at the write.
- `wWWHomePage` and `postOfficeBox`: confirm single-valued handling against the Samba test DC.
- Catalogue keys must stay unique per directory and must not collide with existing ones (`division` is new in both; Entra's sits under its container).
- OpenAPI drift script if the catalogue surfaces in any schema enum.

## Done when

- [ ] Each detail above can be added in Admin ▸ Joiner fields for its directory, with the schema check giving a real answer for the AD ones.
- [ ] A joiner created with them has them set — in AD (Samba test DC) and in Entra.
- [ ] A role default for one fills the joiner form and is offered on the move form.
- [ ] A mover changes and clears one; the request shows before → after.
- [ ] Business phone, usage location and cost centre each round-trip (set, read back, clear) against real Graph on staging.
- [ ] After a sync, each one is in the mirror (COM-863).