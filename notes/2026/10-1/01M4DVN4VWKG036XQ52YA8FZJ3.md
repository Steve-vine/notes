---
id: 01M4DVN4VWKG036XQ52YA8FZJ3
created: 2026-10-08T13:36:14.716594Z
updated: 2026-10-08T13:37:14.780242Z
type: task
title: A joiner field can hold several values — the "other" phone numbers and other email addresses become choosable
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 865
sprint: sme8esk
blocked_by:
- 01M4DVMQYWJV55JESQVYF0CT7J
assignee: steve
label:
- feature
priority: low
task_status: todo
---
Asked for by Steve, 2026-10-08. Follows COM-864 (the one-value contact, name and organisation details). These are the settable details COM-864 leaves out because each holds **several values**, and a joiner field today holds one.

**Blocked by COM-864** (same files) and so by COM-863.

## What people see

- **Admin ▸ Joiner fields** offers these too:
  - **Active Directory:** Other telephone numbers, Other home phones, Other mobiles, Other pagers, Other fax numbers, Other IP phones, Other web pages.
  - **Entra ID:** Other email addresses.
- On the joiner form, the move form and a business role's defaults, such a field takes **several values, one per line**.
- A request shows the list before and after. A move replaces the whole list with what the form says — it doesn't add to it.

## How (implementation)

- A new field kind, `list`, alongside `text | person | country | date` (`JoinerFieldKind`, `core/joiner_fields.py:53`). Every place that branches on kind needs a case — 22 today, across `core/joiner_fields.py`, `core/account_details.py` and `api/v1/access_requests.py` — plus the frontend field editor (`SubjectFieldsEditor.tsx`, `MoverAccountDetails.tsx`), the role-defaults editor and the request page.
- **Stored value.** A request keeps a field's value as a string today. Decide one encoding for a list (a JSON array in the same column is the least disruptive) and keep `value`/`display` and `previous_*` in that shape; trim, drop blanks and duplicates, keep order.
- **Comparing.** "Already says so" must compare as lists, order-insensitively, or every move will report a change (`account_details._same`, `snapshot`).
- **AD:** `otherTelephone`, `otherHomePhone`, `otherMobile`, `otherPager`, `otherFacsimileTelephoneNumber`, `otherIpPhone`, `url` — multi-valued attributes; write with a replace of the full set. `tests/fake_ad.py` doesn't reject duplicate values — the Samba test DC does; test there.
- **Entra:** `otherMails` — a string collection; PATCH replaces it whole.
- **Mirror (COM-863):** the per-directory details blob already holds raw values, so a list is stored as a list; check the form's reading of it.
- OpenAPI drift script — the kind is an enum in the schema.

## Done when

- [ ] Each field above can be chosen, defaulted on a role, filled on the joiner form, and is set on the new account.
- [ ] A mover adds, removes and clears values; the request shows the list before → after, and a list already as asked is not on the request.
- [ ] Reordering the same values is not a change.
- [ ] Verified against the Samba test DC and real Graph on staging.