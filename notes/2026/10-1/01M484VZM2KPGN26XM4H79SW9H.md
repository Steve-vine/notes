---
id: 01M484VZM2KPGN26XM4H79SW9H
created: 2026-10-06T08:21:49.314353Z
updated: 2026-10-06T08:32:05.816235Z
type: task
title: Access Control ▸ Admin gets "Joiner fields" — choose which details the new-joiner form asks for, per directory
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 839
sprint: sme8esk
assignee: steve
label:
- feature
priority: medium
task_status: todo
---
Asked for by Steve, 2026-10-06, while testing the joiner process. First of four: this task is the admin section only; the joiner form (COM-840), writing the values to the new account (COM-841) and the Manager / Country / hire date pickers (COM-842) follow.

## Why

The new-joiner form asks for Display name and User principal name and nothing else. A real starter needs more filled in on their account — first name, last name, description, city, job title — and which ones differs by organisation and by directory.

## What people see

A new card on **Access Control ▸ Admin**, titled **Joiner fields**, beside *Extra fields* and *What Compass watches*.

- **A switch at the top: Active Directory | Entra ID.** Each side holds its own list; changing one never touches the other. The side that new starters are created in today (from the setup chosen on Admin ▸ Integrations — AD only and Hybrid create in Active Directory, Entra ID only creates in Entra) is marked **In use for new starters**, and the card opens on it.
- **The list starts with Display name and User principal name.** They are always asked, always required, and can't be edited or deleted — an account can't be created without them. They show locked.
- **Add field.** The person doesn't type a schema name. They pick from a searchable list of the directory's account details, each shown the way the directory's own tools name it, with the schema name underneath:
  - Active Directory: "Job Title — `title`", "City — `l`", "Office — `physicalDeliveryOfficeName`", "Last name — `sn`"
  - Entra ID: "Job title — `jobTitle`", "City — `city`", "Office location — `officeLocation`", "Last name — `surname`"
  
  Searching matches either name, so "title", "job" and "sn" all find their field. A detail already on the list isn't offered again.
- **Extension attributes 1–15** are in both pickers ("Extension attribute 7 — `extensionAttribute7`"), for the details an organisation keeps that the directory has no box for (cost centre, payroll number, start date). (Added at Steve's request, 2026-10-06.)
- **The name on the form** defaults to the directory's own name for it and can be changed ("Job title" → "Role title"). For an extension attribute the directory's name says nothing, so the admin **must** give it a name ("Cost centre") before it can be added.
- **Required or optional**, per field. Optional by default.
- **Edit** changes the name on the form and required/optional. **Delete** asks to confirm, then removes it from future joiner forms.
- **Order**: fields can be moved up and down; the form asks for them in this order.
- A detail one directory has and the other doesn't (Description exists on an AD account, not on an Entra one) simply only appears in that directory's picker — the reason the two lists are independent.
- **An extension attribute the Active Directory doesn't have is refused when it's added**, not when a joiner is created: they only exist in a domain that has had Exchange's additions made to it. If Compass can't reach AD to check at that moment, the field is added with a note saying it couldn't be checked.

Needs Access write, like the rest of this screen.

## What's permanent

Nothing here changes an account or a request that already exists. Deleting or renaming a field affects only joiner requests raised afterwards (COM-840 makes each request keep the fields as they were when it was raised).

## Decisions taken (say if any is wrong)

- **Pick from a list, don't type the schema name.** A mistyped schema name would only be found out when the account is being created — after approval, at the worst moment. The list is the "helper" Steve asked for, and it makes a wrong name impossible rather than explained.
- **This task is text fields** — the standard details and the fifteen extension attributes. **Manager, Country and Employee hire date** each need their own input on the form; they are COM-842, which adds them to these pickers.
- **Extension attributes are text.** An organisation that keeps a date or a number in one types it as text, as it would in the directory's own tools.
- **Not the same thing as Extra fields.** Extra fields are notes Compass keeps for itself about a directory object; Joiner fields are written into the directory. The card's one-line description should say so.

## Notes (technical)

- Card goes in `SECTIONS` in `app/frontend/src/access/AccessAdminPage.tsx`; follow `ExtraFieldsSection` for the add / edit / delete shape and the screen conventions (`brief/information-architecture.md`; the screen-conventions test wants `w="fit-content"` on switches and `SortableTh` or a no-sort comment on tables).
- New table, one row per (company, directory, attribute): directory (`active_directory` | `entra_id`), attribute key, label, required, position. Unique on (company, directory, attribute). Company-scoped like the other Access configuration. Display name and UPN are **not** rows — they are fixed in code and rendered locked, so they can't drift or be deleted by the API.
- The catalogue is code, not data: one module listing, per directory, `attribute` (the catalogue key: LDAP display name / Graph property), `directory_label` (the name ADUC / the Entra admin centre shows), `kind` (`text` for everything in this task — COM-842 adds `person`, `country`, `date`), and `label_required` (true for the extension attributes). Served by a GET so the picker and the server validate against one list; the API refuses an attribute not in the catalogue for that directory.
  - AD starting set: `givenName` First name · `sn` Last name · `initials` Initials · `description` Description · `physicalDeliveryOfficeName` Office · `telephoneNumber` Telephone number · `mobile` Mobile · `title` Job Title · `department` Department · `company` Company · `streetAddress` Street · `l` City · `st` State/province · `postalCode` Zip/Postal Code · `employeeID` Employee ID · `employeeNumber` Employee number · `employeeType` Employee type · `info` Notes · `extensionAttribute1`…`extensionAttribute15`.
  - Entra starting set: `givenName` First name · `surname` Last name · `jobTitle` Job title · `department` Department · `companyName` Company name · `officeLocation` Office location · `streetAddress` Street address · `city` City · `state` State or province · `postalCode` ZIP or postal code · `mobilePhone` Mobile phone · `employeeId` Employee ID · `employeeType` Employee type · `extensionAttribute1`…`extensionAttribute15` (these live under `onPremisesExtensionAttributes` on the Graph user — the catalogue entry carries that, COM-841 writes it).
  - **Usage location** already has a route on a joiner (`usage_location` on the request subject, edited at the gate in `SubjectFieldsEditor`). Don't offer `usageLocation` in the catalogue — one attribute, one route.
- AD extension attributes: `extensionAttribute1–15` come with the Exchange schema extension. On add, look the attribute up in the connected forest's schema (ldap3 exposes it on the server's schema info) and refuse with a plain message if absent. Unreachable / AD not configured → accept and return a "could not be checked" flag the card shows. This is a validation convenience only — it never decides routing (ADR 0083: route from configuration, never health).
- "In use for new starters" comes from the directory setup (`core/directory_setup.py`; no row = Entra ID only). Read it from configuration, never from health.
- Guard: the Access write set that already guards this page (`access.manage_business_roles`).
- API change → regenerate `schema.d.ts` and run the drift script. Migration: revision id ≤ 32 chars.
- No new ADR expected: this extends ADR 0083 §6 (joiners) without changing a decision in it. If the implementation finds it does, write one.

## Done when

- The card is on Access Control ▸ Admin with both lists, add (from the picker), edit, delete, reorder; the in-use directory is marked.
- Display name and UPN are shown locked on both sides.
- Extension attributes 1–15 can be added on both sides, each only with a name given; an AD one missing from the domain is refused on add.
- The API refuses an unknown attribute and a duplicate.
- Tests: the section (add / edit / delete / reorder / locked rows / in-use marker for each setup / extension attribute needs a name), the API (catalogue validation, uniqueness, permission, the AD schema check and its unreachable path).