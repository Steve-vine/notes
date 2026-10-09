---
id: 01M4DTGAG6GYPPRJ294BK42TV9
created: 2026-10-08T13:16:08.070487Z
updated: 2026-10-09T13:46:48.660721Z
type: task
title: The mirror keeps every account detail Compass can set, from Active Directory and from Entra — and the move form reads them from there
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 863
sprint: sme8esk
comments:
- id: 01M4DV00WXRFHT1P4R3VWZFS8X
  author: Steve Vine
  at: 2026-10-08T13:24:42.524843Z
  text: 'Decided by Steve, 2026-10-08: go straight for this task. COM-862''s worker read is not built; COM-862 is now blocked by this task and closes when it is on staging. The "Relationship to COM-862 — Steve to say which" section in the body is settled by this. Priority raised to high because this now carries the COM-862 fix.'
- id: 01M4E3PFZJYNQHQ9WMTTFDHXYV
  author: Steve Vine
  at: 2026-10-08T15:56:47.473851Z
  text: |-
    Done — PR #867, merged to main 2026-10-08 (ADR 0093, migration 0230). Not yet on staging (deploys with the rest of the sprint).

    What changed:
    - The mirror now keeps every account detail the joiner-field catalogue names, for everybody, from each directory they are in (35 from AD, 31 from Entra).
    - The move form's Account details, and a request being raised, read the mirror. The web side no longer asks a directory anything — the live read was removed, not kept beside the new one. So no "Active Directory could not be reached" banner (COM-862), before → after on the request, and a field can be cleared.
    - Admin ▸ Joiner fields answers "does this domain have that extension attribute?" from what the AD read recorded, instead of always "couldn't be checked".
    - A change to the list of details forces one full read by itself, in both directories — nobody has to remember to bump a constant.
    - Compass's own writes update the mirror straight away. A person's details are dropped when their record is marked gone.
    - The run is unchanged: it still reads the account live and writes only what differs.

    Decided differently from the task body:
    - Manager from Entra is read by its own small listing on every pass, rather than relying on the delta (a manager change never surfaces a user in a delta). A failed listing keeps the last answer and never fails the pass.
    - Asking AD for an attribute its schema lacks is harmless (proved against the Samba test domain), so the read asks for all of them; the schema record is only what the Joiner-fields check answers from.

    NOT verified — needs staging after deploy:
    1. The managers listing against real Graph (/users?$select=id&$expand=manager($select=id), 100 a page). If Graph refuses it, managers stay blank and the worker logs "Managers could not be read"; nothing else is affected. I will check the worker log after the deploy.
    2. The first passes after deploy are full reads by design (no fingerprint stored yet) — AD in seconds, Entra a full crawl once.
    3. Done-when items that need the real directories: a change made in AD showing within 5 minutes, in Entra within 15, including manager; the move form on staging with no banner; Joiner fields answering present/absent for an extension attribute.
- id: 01M4GEN6YMQMFP67GFGFY8AJ84
  author: Steve Vine
  at: 2026-10-09T13:46:48.660482Z
  text: On staging 2026-10-09 (5161e64a). The migration ran, and the first AD and Entra syncs on the new build re-read every account in full (as designed) and succeeded; the next quick syncs succeeded too.
assignee: steve
label:
- feature
priority: high
task_status: review
---
Asked for by Steve, 2026-10-08, after COM-862 (the move form's false "Active Directory could not be reached" banner). Steve chose the mirror over reading on the fly, and **all** the details rather than a chosen few.

**This is the foundation of a set of five.** It carries the COM-862 fix; the rest build on it:
- COM-864 — more settable details offered in Admin ▸ Joiner fields (contact, name parts, organisation).
- COM-865 — settable details that hold several values (the "other" numbers, other email addresses).
- COM-866 — a user's record shows their account details.
- COM-867 — a user's record shows read-only facts (account state, logon restrictions, profile settings, mail addresses, licence detail).

## What people see

- **The move form's Account details shows what the account says now, straight away** — no wait, no banner, and it still shows when Active Directory or Entra can't be reached at that moment.
- What it shows is the account as of the last sync: at most 5 minutes old for an AD account, 15 for a cloud-only one.
- The request records before → after for each detail it changes, and a field can be cleared.
- Nothing changes about what gets written: when the request runs, Compass still reads the account live and writes only what differs then.
- **Admin ▸ Joiner fields: adding an Active Directory field says whether the domain has it.** Today that check also runs from the web side, so on staging it can only ever answer "couldn't be checked" — the same fault as COM-862, found while scoping this (2026-10-08).

## What is mirrored

Every detail in the joiner-field catalogue (`core/joiner_fields.CATALOGUE`), for every person, from each directory the person exists in:

- **Active Directory (20 + 15):** first name, last name, initials, description, office, telephone, mobile, job title, department, company, manager, street, city, state/province, postcode, country/region (`c`, `co`, `countryCode`), employee ID, employee number, employee type, notes, and extension attributes 1–15.
- **Entra ID (16 + 15):** first name, last name, job title, department, company name, manager, office location, street address, city, state, postcode, country/region, mobile phone, employee ID, employee type, employee hire date, and extension attributes 1–15.

The list is **driven by the catalogue**, not written out a second time. COM-864 and COM-865 widen the catalogue and COM-867 adds a read-only list beside it; none of them should have to touch the sync.

## Decision record first

This reverses **ADR 0090 §3** ("One account is read live; the mirror is not widened"). Write a new ADR that supersedes that section — do not edit 0090. It should settle, for the whole set of five:

- Why now: the live read needs a route to AD from the web side, which the chart does not give (COM-862); and Steve wants the details held and shown.
- **The web side never talks to Active Directory.** The worker is the only thing with the route; anything a screen needs from AD comes from what the sync stored.
- **Personal data.** The mirror will hold phone numbers, addresses and free-text notes for ~1,500 people, and (COM-867) read-only facts about each account. Values are never logged (attribute names only — the rule `core/account_details.py` already follows); check the log-redaction list. My default: **blank a person's details when their record is marked vanished.** What is read is an explicit allow-list; nothing credential-bearing, ever.
- The form reads the mirror; the run still reads live (ADR 0090 §4 stands).

## How (implementation)

**Storage.** Two JSONB columns on `directory_users` — `ad_details` and `entra_details` — each the raw values by attribute, null until first read. Two, not one: in Hybrid a synced person exists in both directories and each sync must write its own half without trampling the other (`ad_sync._apply_user` deliberately leaves an Entra-described record's columns alone). `job_title` / `department` / `employee_id` stay as columns — lists sort and filter on them. Migration 0230 or the next free; revision id ≤ 32 chars.

**A change to the list forces its own full read.** Today a hand-bumped constant (`MIRROR_SELECT_VERSION`) forces the one full Entra pass after a `$select` change, and nothing equivalent exists for AD. Once the list follows the catalogue, a hand-bumped number will be forgotten the first time someone adds a catalogue entry — and the sync will keep succeeding while watching the old list (the COM-508/521 failure). Store a fingerprint of the attribute list each directory was last read with (a hash of the sorted names) and do a full pass when it differs: Entra — fold it into the existing select-version comparison; AD — treat a mismatch like `highest_usn is None`. The first deploy then fills everyone without a migration clearing anything.

**Active Directory.** Add the catalogue's LDAP names (through `account_details.ad_names`, so country brings `c`/`co`/`countryCode`) to what `ad_reader` asks for and carry them on `AdUser` into `_apply_user`, written for every AD account whether or not Entra describes it. The 5-minute pass is incremental by `uSNChanged`, which any attribute change bumps, so changes arrive on their own. A full pass is ~3 s for 1,493 people.
- **Which attributes the domain has.** `extensionAttribute1–15` exist only where the Exchange schema has been added. On each full pass, ask the schema once which of the wanted attributes it defines, store the answer (on the AD sync-state row), and request only those.
- **Admin ▸ Joiner fields reads that stored answer.** `joiner_fields.ad_schema_check` (called from `api/v1/joiner_fields.py:163`) opens its own AD connection from the API pod. Replace it with a lookup of what the sync recorded; "unchecked" then means only "no sync has run yet". An attribute not yet in the wanted list (a brand-new catalogue entry) is covered by the next pass.
- Manager is kept as the DN AD gives; it is resolved to a person when read (`_ad_manager`), not when stored.

**Entra ID.** Add the catalogue's Graph properties, and `onPremisesExtensionAttributes`, to the user `$select`. Store next to the `jobTitle`/`employeeId` mapping (`tasks/directory_sync.py:2335`).
- **Manager is the awkward one — verify before building.** It is a relationship, not a property. The full crawl can take `$expand=manager($select=id)`; `$expand` is ignored on `/users/delta` (COM-521 learned this for groups). Check against the real tenant whether `manager` in the delta `$select` is tracked and arrives as `manager@delta`. If it isn't, the fallback is a manager read per changed user in the pass, plus the nightly full crawl as the backstop. Don't assume.
- Check `employeeHireDate` and the extension attributes need no new Graph permission.

**Compass's own writes keep the mirror in step.** Extend what `MIRROR_COLUMNS` does today (`account_details.py:431`, `:484`) to patch the matching key in `ad_details` / `entra_details`, so the form doesn't show the old value for five minutes after Compass changed it.

**The form.** `GET /access-requests/mover-details` and the read at submit (`api/v1/access_requests.py:1480`, `:418`) take "now" from the mirror through `account_details.readings()` — which already turns raw values into what the form shows — instead of `read_now`. `read_now` stays for the run. A person whose details haven't been mirrored yet (null) gets today's "couldn't be read" banner with a true reason: not read yet.

## COM-862

Settled by Steve, 2026-10-08: this task is the fix. COM-862's worker read is not built; COM-862 is blocked by this and closes when this is on staging.

## Done when

- [ ] ADR accepted, superseding ADR 0090 §3.
- [ ] After one sync on staging, an AD person and a cloud-only person each hold every catalogue detail their directory has; a hybrid person holds both halves.
- [ ] A change made in AD shows on the move form within 5 minutes; one made in Entra within 15 — **including a change of manager**.
- [ ] A detail Compass itself changes shows on the form immediately.
- [ ] The move form shows current values with no banner while AD is unreachable from the web side (staging as it is today).
- [ ] A request shows before → after; a field already as asked is not on it; a field can be cleared.
- [ ] Adding an AD field in Admin ▸ Joiner fields on staging answers present or absent, not "couldn't be checked".
- [ ] Adding a catalogue entry in a test makes the next pass full, for both directories, with no constant bumped.
- [ ] A domain without the Exchange extension attributes still syncs.
- [ ] No detail value appears in any log line.
- [ ] Test: no API route opens an LDAP connection (mover-details, submit, joiner-fields add).
- [ ] OpenAPI drift script run if any route's schema or docstring changes.