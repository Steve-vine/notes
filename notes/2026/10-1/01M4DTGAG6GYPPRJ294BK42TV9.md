---
id: 01M4DTGAG6GYPPRJ294BK42TV9
created: 2026-10-08T13:16:08.070487Z
updated: 2026-10-08T13:16:10.547616Z
type: task
title: The mirror keeps every account detail Compass can set, from Active Directory and from Entra — and the move form reads them from there
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 863
sprint: sme8esk
assignee: steve
label:
- feature
priority: medium
task_status: todo
---
Asked for by Steve, 2026-10-08, after COM-862 (the move form's false "Active Directory could not be reached" banner). Steve chose the mirror over reading on the fly, and **all** the details rather than a chosen few.

## What people see

- **The move form's Account details shows what the account says now, straight away** — no wait, no banner, and it still shows when Active Directory or Entra can't be reached at that moment.
- What it shows is the account as of the last sync: at most 5 minutes old for an AD account, 15 for a cloud-only one.
- The request records before → after for each detail it changes, and a field can be cleared.
- Nothing changes about what gets written: when the request runs, Compass still reads the account live and writes only what differs then.

## What is mirrored

Every detail in the joiner-field catalogue (`core/joiner_fields.CATALOGUE`), for every person, from each directory the person exists in:

- **Active Directory (20 + 15):** first name, last name, initials, description, office, telephone, mobile, job title, department, company, manager, street, city, state/province, postcode, country/region (`c`, `co`, `countryCode`), employee ID, employee number, employee type, notes, and extension attributes 1–15.
- **Entra ID (16 + 15):** first name, last name, job title, department, company name, manager, office location, street address, city, state, postcode, country/region, mobile phone, employee ID, employee type, employee hire date, and extension attributes 1–15.

The list is **driven by the catalogue**, not written out a second time: a detail added to the catalogue later is mirrored without a second change. (Assumption, mine: "all details" means everything Compass offers as an account detail — not every raw attribute a directory holds on a user. Widen the catalogue if more are wanted.)

## Decision record first

This reverses **ADR 0090 §3** ("One account is read live; the mirror is not widened"). Write a new ADR that supersedes that section — do not edit 0090. It should settle:

- Why now: the live read needs a route to AD from the web side, which the chart does not give (COM-862); and Steve wants the details held.
- **Personal data.** The mirror will hold phone numbers, addresses and free-text notes for ~1,500 people. Values are never logged (attribute names only — the rule `core/account_details.py` already follows); check the log-redaction list. My default: **blank a person's details when their record is marked vanished.**
- The form reads the mirror; the run still reads live (ADR 0090 §4 stands).

## How (implementation)

**Storage.** Two JSONB columns on `directory_users` — `ad_details` and `entra_details` — each the raw values by catalogue attribute, null until first read. Two, not one: in Hybrid a synced person exists in both directories and each sync must write its own half without trampling the other (`ad_sync._apply_user` deliberately leaves an Entra-described record's columns alone). `job_title` / `department` / `employee_id` stay as columns — lists sort and filter on them. Migration 0230 or the next free; revision id ≤ 32 chars.

**Active Directory.** Add the catalogue's LDAP names (through `account_details.ad_names`, so country brings `c`/`co`/`countryCode`) to `ad_reader._USER_ATTRIBUTES` and carry them on `AdUser` into `_apply_user`, written for every AD account whether or not Entra describes it. The 5-minute pass is incremental by `uSNChanged`, which any attribute change bumps, so changes arrive on their own. **One full read is needed to fill everyone** — clear `highest_usn` in the migration (a full pass is ~3 s for 1,493 people).
- Risk: `extensionAttribute1–15` exist only where the Exchange schema has been added. Ask only for attributes the domain's schema has, or the search fails — check how ldap3 treats an unknown attribute name here, and cover it in `tests/fake_ad.py` and against the Samba test DC.
- Manager is kept as the DN AD gives; it is resolved to a person when read (`_ad_manager`), not when stored.

**Entra ID.** Add the catalogue's Graph properties, and `onPremisesExtensionAttributes`, to `_USER_SELECT`; **bump `MIRROR_SELECT_VERSION` to 5** so the next pass is full and re-mints the delta link (the comment above the constant explains why). Store in `_apply`-side code next to the `jobTitle`/`employeeId` mapping (`tasks/directory_sync.py:2335`).
- **Manager is the awkward one — verify before building.** It is a relationship, not a property. The full crawl can take `$expand=manager($select=id)`; `$expand` is ignored on `/users/delta` (COM-521 learned this for groups). Check against the real tenant whether `manager` in the delta `$select` is tracked and arrives as `manager@delta`. If it isn't, the fallback is a manager read per changed user in the pass, plus the nightly full crawl as the backstop. Don't assume — a silently untracked manager is exactly the COM-508/521 failure.
- Check `employeeHireDate` and the extension attributes need no new Graph permission.

**Compass's own writes keep the mirror in step.** Extend what `MIRROR_COLUMNS` does today (`account_details.py:431`, `:484`) to patch the matching key in `ad_details` / `entra_details`, so the form doesn't show the old value for five minutes after Compass changed it.

**The form.** `GET /access-requests/mover-details` and the read at submit (`api/v1/access_requests.py:1480`, `:418`) take "now" from the mirror through `account_details.readings()` — which already turns raw values into what the form shows — instead of `read_now`. The API then opens no LDAP connection at all. `read_now` stays for the run. A person whose details haven't been mirrored yet (null) gets today's "couldn't be read" banner with a true reason: not read yet.

## Relationship to COM-862

This fixes COM-862's banner by a different route. If this ships first, COM-862 closes with it and its worker read is never built; if COM-862 ships first, this task removes that read from the form. Steve to say which.

## Not in this task

- Showing these details on a person's page, in lists or in reports — the data will be there; say if it's wanted.
- Using manager for approvals or recertification.

## Done when

- [ ] ADR accepted, superseding ADR 0090 §3.
- [ ] After one sync on staging, an AD person and a cloud-only person each hold every catalogue detail their directory has; a hybrid person holds both halves.
- [ ] A change made in AD shows on the move form within 5 minutes; one made in Entra within 15 — **including a change of manager**.
- [ ] A detail Compass itself changes shows on the form immediately.
- [ ] The move form shows current values with no banner while AD is unreachable from the web side (staging as it is today).
- [ ] A request shows before → after; a field already as asked is not on it; a field can be cleared.
- [ ] A domain without the Exchange extension attributes still syncs.
- [ ] No detail value appears in any log line.
- [ ] Test: the mover-details route and submit never open an LDAP connection.
- [ ] OpenAPI drift script run if any route's schema or docstring changes.