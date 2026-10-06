---
id: 01M485X94AZDFKK464GADDPAD4
created: 2026-10-06T08:40:00.394346Z
updated: 2026-10-06T08:40:04.675729Z
type: task
title: A business role carries default values for the joiner fields — picking the role on the new-joiner form fills them in
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 843
sprint: sme8esk
blocked_by:
- 01M485FX60ZVPSWBFZ4PA83PEA
assignee: steve
label:
- feature
priority: medium
task_status: todo
---
Asked for by Steve, 2026-10-06. Follows the Joiner fields set — COM-839 (the list), COM-840 (the form), COM-841 (the account), COM-842 (Manager / Country / hire date pickers).

## Why

Most of what's typed for a new starter is the same for everyone in the role — the department, the office, the city, the company, often the manager. Typing it per joiner is slow and inconsistent ("Sales", "sales", "Sales Dept").

## What people see

### On a business role (Role matrix ▸ open a role)

A new card, **Default values**, below *Shared mailboxes* and above the people who hold the role.

- It lists the joiner fields **for the directory new starters are created in right now** — the Active Directory list in AD only and Hybrid, the Entra ID list in Entra ID only — in the admin's order and under the admin's names. The other directory's fields aren't shown.
- Each field has the same input it has on the joiner form: a text box, the people picker for Manager, the country list for Country, the date picker for hire date.
- Fill in the ones this role should default; leave the rest blank. **Save** on the card.
- **Display name and User principal name aren't there** — they're different for every person.
- Someone who can see the role but not change it sees the defaults read-only.
- With no joiner fields set up yet, the card says so and points to Access Control ▸ Admin ▸ Joiner fields.

### On the new-joiner form

- **Business roles moves to the top of each joiner's block**, above Display name and User principal name.
- **Picking a role fills in every blank field that role has a default for.** The person can then change any of them — a default is a starting point, not a rule.
- **What the person typed is never overwritten.** A field they have edited stays theirs, whatever roles are picked afterwards.
- **A filled-in default follows the roles until it's edited.** Remove the role, or swap it for another, and the fields it filled (and nobody touched) are cleared and refilled from the roles still picked.
- **Several roles:** each fills what is still blank, so where two roles default the same field, **the role picked first wins** — the same rule that already decides which role's OU a starter goes in.
- A default counts as an answer to a required field.

## What's permanent

Nothing. Defaults only pre-fill a form that is opened afterwards. Changing a role's defaults doesn't touch requests already raised, accounts already created, or the people who hold the role.

## Decisions taken (say if any is wrong)

- **Defaults pre-fill; they don't enforce.** The requester can change or clear one, and the request records what was actually submitted.
- **Nothing auto-fills at approval.** If an approver changes a joiner's roles while correcting a request, the fields stay as submitted — the approver edits them by hand if needed.
- **Each directory keeps its own defaults**, like the field lists. Switching the setup shows the other directory's defaults; the first set is kept, not lost.
- **A field removed from the Joiner fields list** drops off this card and stops being pre-filled; if it's added back, the default it had returns.
- **A default Manager who has since left** isn't pre-filled, and the card shows that the person has gone so it can be corrected.
- **Every joiner field can have a default**, hire date included — one rule, even though a default date is rarely useful.

## Notes (technical)

- Role page: `app/frontend/src/access/RoleDetailPage.tsx` — the main column is `GroupMappings`, `MailboxGrants`, `Holders`; the new card goes between `MailboxGrants` and `Holders` (in AD only, where the mailboxes card is absent, straight after groups). It saves on its own — it is not part of the group-mapping preview / "This changes people's access" confirmation, because it changes nobody's access.
- Storage: one row per (role, directory, attribute) → value; value encoded by kind exactly as on a request (COM-840 / COM-842: text, directory-user record id, ISO alpha-2, `YYYY-MM-DD`). Don't hang it off the role row as columns. Rows for an attribute not currently on that directory's Joiner fields list are ignored (and kept).
- Validate a default the same way a submitted value is validated (kind, length cap, catalogue membership) — one validator.
- Reuse the form's per-kind input component (COM-840 switches on `kind`; COM-842 adds the cases) so the card and the form can't drift.
- Guard: whatever guards editing the role today (`canWrite` on the role page).
- **Pre-fill is the form's job, not the server's.** If the server filled blanks on raise, a field the requester deliberately cleared would come back. The API serves each role's defaults for the directory in use (alongside the "joiner form's fields right now" GET from COM-840, or on the role options the form already loads) so any consumer can do the same; `POST` stores what it is sent.
- Form state (`JoinerRows` in `RaiseRequestModal.tsx`): each field needs to know whether its current value came from a default or from the person — track "touched" per field per joiner; recompute untouched fields whenever that joiner's roles change, walking the roles in the order they were picked (the `MultiSelect` value order). Follow the repo's hooks lint (no setState in effects — derive in the change handler).
- Role is deleted → its defaults go with it (cascade).
- API change → regenerate `schema.d.ts`, run the drift script. Migration: revision id ≤ 32 chars.

## Done when

- A role has a Default values card listing the in-use directory's joiner fields, each with its proper input; values save and reload.
- On the joiner form Business roles is first in each block; picking a role fills blank fields; edited fields are never overwritten; removing or swapping a role clears and refills untouched defaults; with two roles the first picked wins.
- Each joiner in a multi-joiner request is filled from its own roles.
- Tests: the card (each kind, read-only, empty state, per-setup list); the form (fill, don't-overwrite, role removed, two roles, required satisfied by a default, several joiners); the API (validation, guard, stale-attribute rows ignored).
- Smoke-tested on staging: set defaults on a role, raise a joiner with it, check the account in ADUC.