---
id: 01M4DVNMRPQNHEPWR5ZA688J0B
created: 2026-10-08T13:36:30.998335Z
updated: 2026-10-08T21:47:26.692062Z
type: task
title: A user's record shows their account details — name, contact, organisation and the rest, from the mirror
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 866
sprint: sme8esk
blocked_by:
- 01M4DTGAG6GYPPRJ294BK42TV9
assignee: steve
label:
- feature
priority: medium
task_status: active
---
Asked for by Steve, 2026-10-08, with COM-863 (the mirror keeps every account detail). Once the details are held, they should be visible on the person.

**Blocked by COM-863.** Independent of COM-864/865 — details added to the catalogue later appear here without a change.

## What people see

On a user's record (Access Control ▸ Users ▸ a person — the "Account details" window):

- A new **Details** section, read-only, listing every account detail the directory holds for them: name parts, job title, department, company, manager, office, phones, address, employee ID/number/type, hire date, notes, extension attributes.
- **Only details that have a value are listed** — thirty blank rows would bury the five that matter. If none have a value, the section says so.
- **Manager** is a link to that person's record. A manager Compass has no record of is shown as the directory names them, without a link.
- **Labels:** the admin's own label where the detail is on the Joiner fields list (so "Extension attribute 7" reads as whatever the admin called it); otherwise the directory's name for it.
- **Which directory:** the details of the directory the account lives in — Active Directory for a synced or AD-only account, Entra ID for a cloud-only one. For a synced account, details only Entra holds (e.g. hire date, usage location) are listed too, marked "in Entra ID".
- Anyone who can open the user's record sees the section. No new permission.
- Nothing here is editable. Changing a detail is still a move request.

## How (implementation)

- `GET /api/v1/directory/users/{user_id}` (`api/v1/directory.py:820`, `DirectoryUserDetailOut`) gains a `details` list — `{directory, attribute, label, kind, value, display, unknown}` — built from the mirror's `ad_details` / `entra_details` through `account_details.readings()`, the same function the move form uses (COM-863), so a manager and a country resolve identically in both places.
- Labels: `joiner_fields.fields_for(db, company, directory)` for the admin's label, falling back to the catalogue's `directory_label`. The route is company-scoped already via the modal's `CompanyContext`; check how the company reaches this route today.
- "Only Entra holds": catalogue attributes in `entra_details` with no counterpart in the AD catalogue. Keep the pairing explicit (a small map), not inferred from attribute names — `title`/`jobTitle`, `sn`/`surname`, `l`/`city` don't match by name.
- Frontend: `access/UserDetailModal.tsx` — a `Section` from `components/kit`, `Fact` rows as the existing header facts use. Read *Screen conventions* in `brief/information-architecture.md` first; the screen-conventions test applies.
- Values are personal data: never logged. A vanished person shows none (COM-863 blanks them).
- Page tests that stub `/directory/users/{id}` by prefix will answer with the old shape — default `details` to `[]` in the hook.
- OpenAPI drift script.

## Done when

- [ ] An AD person, a cloud-only person and a synced person each show the right details on staging.
- [ ] A person with no details shows the empty state.
- [ ] Manager links through; an unknown manager is shown without a link.
- [ ] A relabelled extension attribute shows the admin's label.
- [ ] A detail changed by a move request shows its new value on the record straight after the request completes.