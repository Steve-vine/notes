---
id: 01M484WJ71CDQ6ZHAE9V756XHP
created: 2026-10-06T08:22:08.353844Z
updated: 2026-10-06T08:32:58.058566Z
type: task
title: The new-joiner form asks for the fields the admin chose — and the request keeps them
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 840
sprint: sme8esk
blocked_by:
- 01M484VZM2KPGN26XM4H79SW9H
assignee: steve
label:
- feature
priority: medium
task_status: todo
---
Asked for by Steve, 2026-10-06. Second of four — follows COM-839 (the Joiner fields section on Access Control ▸ Admin); COM-841 writes the values to the new account, and COM-842 adds the Manager, Country and hire-date pickers.

## What people see

**Raising a joiner request.** The form asks for Display name, User principal name and Business roles as today, then every field on the Joiner fields list **for the directory new starters are created in** — the Active Directory list in AD only and Hybrid, the Entra ID list in Entra ID only. The other directory's list is never shown. Fields appear in the admin's order, under the admin's names (an extension attribute shows as "Cost centre", never as "Extension attribute 7"); a required one must be filled before the request can be raised, an optional one can be left blank.

**More than one joiner.** Today each joiner is one line across the form (name, UPN, roles). With more fields that no longer fits, so each joiner becomes its own block — the fixed three at the top, the chosen fields in a grid beneath — with **Add another joiner** under the last block and a remove button on each.

**On the request.** The values are shown with the joiner's other details on the request page, to everyone who can see the request.

**At approval and validation.** Wherever a joiner's details can be corrected before approving today, these fields can be corrected too, with the same required/optional rule.

## What's permanent

A request keeps the fields **as they were when it was raised** — their names, order and whether they were required. If an admin later renames, deletes or adds a field, requests already raised don't change: an approver sees exactly the form the requester filled in. New requests use the new list.

## Decisions taken (say if any is wrong)

- **With no fields added, nothing changes** — the form is the three boxes it is today.
- **The directory is decided when the request is raised.** If the setup is switched (say Hybrid → Entra ID only) while a joiner request is waiting, that request still carries the fields it was raised with; COM-841 says what happens to them at creation.
- **Blank optional fields are not stored** — a blank means "leave it unset on the account", not "set it to empty".
- **Every field in this task is a text box.** The pickers (Manager, Country, hire date) are COM-842.

## Notes (technical)

- Form: `JoinerRows` in `app/frontend/src/access/RaiseRequestModal.tsx` (one `Group` per joiner today → a block per joiner). Gate editor: `SubjectFieldsEditor.tsx`; `subjectsFromRequest` in `subjectFields.ts` must carry the new values or a gate save posts them blank (the COM-740 mistake — see the comment there). Request page: the joiner's details in `RequestDetailPage.tsx`, including the before/after rows shown when a gate corrected something.
- Storage: the values live on the request subject as a snapshot list — per field: directory, attribute, **kind**, label, required, position, value — not as references to the definition rows (the ADR 0032 §4 snapshot pattern; a definition may be gone by the time the request is read). One JSON column on the subject is enough; nothing queries inside it. `kind` is always `text` here; carrying it now means COM-842's `person` / `country` / `date` need no change to the shape. Render the form input by switching on `kind`, so COM-842 adds cases rather than restructuring.
- The server, not the form, decides which list applies (directory setup from configuration) and validates on raise: every required field present, no attribute outside the snapshot's list, values trimmed, a sensible length cap (AD single-valued strings: 1024 covers this catalogue; keep one cap in the catalogue module).
- A gate edit validates against the request's **own** snapshot, not today's definitions.
- A GET for "the joiner form's fields right now" (directory in use + its ordered list) so the modal doesn't need the admin endpoints — a requester has Access request rights, not Access write.
- API change → regenerate `schema.d.ts`, run the drift script. Page tests that stub by URL prefix will answer a new sub-route with the parent object — stub the new route explicitly.

## Done when

- The raise form shows the in-use directory's fields in order, enforces required, and works for several joiners in one request.
- The request page shows the values; the gate editor can correct them.
- A field renamed or deleted after raising doesn't change an existing request.
- Tests: the form for each setup (AD only, Hybrid → AD list; Entra ID only → Entra list; no fields → today's form), required enforcement in the form and the API, the snapshot surviving a definition change, a gate save round-tripping the values.