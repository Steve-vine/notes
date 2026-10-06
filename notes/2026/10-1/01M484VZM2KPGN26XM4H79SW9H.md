---
id: 01M484VZM2KPGN26XM4H79SW9H
created: 2026-10-06T08:21:49.314353Z
updated: 2026-10-06T08:21:49.314353Z
type: task
title: Access Control ▸ Admin gets "Joiner fields" — choose which details the new-joiner form asks for, per directory
task_status: todo
label: feature
assignee: steve
priority: medium
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 839
---
Asked for by Steve, 2026-10-06, while testing the joiner process. First of three: this task is the admin section only; the joiner form (next task) and writing the values to the new account (third task) follow.

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
- **The name on the form** defaults to the directory's own name for it and can be changed ("Job title" → "Role title").
- **Required or optional**, per field. Optional by default.
- **Edit** changes the name on the form and required/optional. **Delete** asks to confirm, then removes it from future joiner forms.
- **Order**: fields can be moved up and down; the form asks for them in this order.
- A detail one directory has and the other doesn't (Description exists on an AD account, not on an Entra one) simply only appears in that directory's picker — the reason the two lists are independent.

Needs Access write, like the rest of this screen.

## What's permanent

Nothing here changes an account or a request that already exists. Deleting or renaming a field affects only joiner requests raised afterwards (the next task makes each request keep the fields as they were when it was raised).

## Decisions taken (say if any is wrong)

- **Pick from a list, don't type the schema name.** A mistyped schema name would only be found out when the account is being created — after approval, at the worst moment. The list is the "helper" Steve asked for, and it makes a wrong name impossible rather than explained.
- **Text fields only in this first cut.** Manager (a person), Country/region (three linked attributes in AD) and Employee hire date (a date) need their own inputs — left out of the list for now.
- **Standard details only.** Custom / extension attributes (AD `extensionAttribute1–15`, Entra extension properties) are not offered yet — open question to Steve; a follow-on task if wanted.
- **Not the same thing as Extra fields.** Extra fields are notes Compass keeps for itself about a directory object; Joiner fields are written into the directory. The card's one-line description should say so.

## Notes (technical)

- Card goes in `SECTIONS` in `app/frontend/src/access/AccessAdminPage.tsx`; follow `ExtraFieldsSection` for the add / edit / delete shape and the screen conventions (`brief/information-architecture.md`; the screen-conventions test wants `w="fit-content"` on switches and `SortableTh` or a no-sort comment on tables).
- New table, one row per (company, directory, attribute): directory (`active_directory` | `entra_id`), attribute key, label, required, position. Unique on (company, directory, attribute). Company-scoped like the other Access configuration. Display name and UPN are **not** rows — they are fixed in code and rendered locked, so they can't drift or be deleted by the API.
- The catalogue is code, not data: one module listing, per directory, `attribute` (the schema name: LDAP display name / Graph property), `directory_label` (the name ADUC / the Entra admin centre shows), and for now `kind = text`. Served by a GET so the picker and the server validate against one list; the API refuses an attribute not in the catalogue for that directory.
  - AD starting set: `givenName` First name · `sn` Last name · `initials` Initials · `description` Description · `physicalDeliveryOfficeName` Office · `telephoneNumber` Telephone number · `mobile` Mobile · `title` Job Title · `department` Department · `company` Company · `streetAddress` Street · `l` City · `st` State/province · `postalCode` Zip/Postal Code · `employeeID` Employee ID · `employeeNumber` Employee number · `employeeType` Employee type · `info` Notes.
  - Entra starting set: `givenName` First name · `surname` Last name · `jobTitle` Job title · `department` Department · `companyName` Company name · `officeLocation` Office location · `streetAddress` Street address · `city` City · `state` State or province · `postalCode` ZIP or postal code · `mobilePhone` Mobile phone · `employeeId` Employee ID · `employeeType` Employee type.
  - **Usage location** already has a route on a joiner (`usage_location` on the request subject, edited at the gate in `SubjectFieldsEditor`). Don't offer `usageLocation` in the catalogue — one attribute, one route.
- "In use for new starters" comes from the directory setup (`core/directory_setup.py`; no row = Entra ID only). Read it from configuration, never from health (ADR 0083's routing rule).
- Guard: the Access write set that already guards this page (`access.manage_business_roles`).
- API change → regenerate `schema.d.ts` and run the drift script. Migration: revision id ≤ 32 chars.
- No new ADR expected: this extends ADR 0083 §6 (joiners) without changing a decision in it. If the implementation finds it does, write one.

## Done when

- The card is on Access Control ▸ Admin with both lists, add (from the picker), edit, delete, reorder; the in-use directory is marked.
- Display name and UPN are shown locked on both sides.
- The API refuses an unknown attribute and a duplicate.
- Tests: the section (add / edit / delete / reorder / locked rows / in-use marker for each setup), the API (catalogue validation, uniqueness, permission).