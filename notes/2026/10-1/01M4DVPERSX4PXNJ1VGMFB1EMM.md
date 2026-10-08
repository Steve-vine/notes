---
id: 01M4DVPERSX4PXNJ1VGMFB1EMM
created: 2026-10-08T13:36:57.62529Z
updated: 2026-10-08T22:43:11.507659Z
type: task
title: A user's record shows the account's state, logon restrictions, profile settings, mail addresses and licence detail — read-only
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 867
sprint: sme8esk
blocked_by:
- 01M4DTGAG6GYPPRJ294BK42TV9
- 01M4DVNMRPQNHEPWR5ZA688J0B
comments:
- id: 01M4ETYKE36FS3E3X4NV8QY3NF
  author: Steve Vine
  at: 2026-10-08T22:43:10.40319Z
  text: |-
    Done — PR #876, merged to main 2026-10-08. Not yet on staging (deploys with the rest of the sprint).

    What changed: a person's record has up to five read-only sections under Details. One with nothing to show for that person isn't there.
    - Account state — from Active Directory: account expires ("Never" or the date), last logon (marked approximate), password last set, must change password at next logon, locked out since, password never expires, password not required, smart card required, last changed. From Entra: how the account was created, sign-in identities, sessions last revoked.
    - Logon restrictions (AD) — logon hours in words, e.g. "Monday to Friday 08:00 to 18:00 (UTC)", or "Any time"; can log on to "All computers" or the named ones.
    - Profile settings (AD) — profile path, logon script, home folder, home drive.
    - Mail addresses — aliases with the primary marked, mail nickname, forwarding target, hidden from address lists.
    - Licence detail (Entra) — each licence: directly or through which group, any assignment error, and the service plans switched on.
    A synced person shows both directories' facts under the same headings, Entra's marked "in Entra ID", and their aliases once.

    Three things that differ from the task:
    1. Entra's facts are read once a night, not every 15 minutes, and the sections say so ("What Entra ID holds here is read once a night."). Reason: the task asks for each Entra property to be checked against the real tenant on both kinds of read before relying on it, which can't be done from here. So they are read separately, in a way that can fail without stopping the Entra sync. If you want them fresher once they're proven on staging, that is a small follow-up.
    2. Logon hours are shown in UTC, as Active Directory stores them — not converted to your time zone.
    3. The service plans listed are each licence's own (its plans minus any switched off for that person).

    To check on staging after deploy:
    - After the first Entra sync, a cloud-only person shows Account state, Mail addresses and Licence detail. If those sections are missing for everyone, Graph refused one of the properties — the worker log will say "Account facts could not be read"; nothing else is affected.
    - An AD person shows the AD sections; "Never", "Any time" and "All computers" read as words.
    - A licence assigned through a group names the group.
assignee: steve
label:
- feature
priority: medium
task_status: review
---
Asked for by Steve, 2026-10-08, with COM-863. Beyond the details Compass can set, a directory holds facts about an account that Compass only needs to **show**. Steve chose five groups.

**Blocked by COM-863** (the mirror's per-directory store and its self-forcing full read) **and COM-866** (the Details section this sits beside on the user's record).

## What people see

On a user's record, read-only sections below Details. A group with nothing to show for that person is left out; a group that doesn't exist in their directory never appears.

**Account state**
- AD: account expires on · last logon (**approximate** — AD only updates it every 9–14 days, say so beside the value) · password last set · must change password at next logon · locked out since · password never expires · password not required · smart card required for sign-in · when the account was last changed.
- Entra: how the account was created · sign-in identities · sessions last revoked on.

**Logon restrictions** (AD only)
- Logon hours — "Any time", or the permitted hours in words by day · Can log on to — "All computers", or the named ones.

**Profile settings** (AD only)
- Profile path · logon script · home folder · home drive.

**Mail addresses**
- AD: email aliases (primary marked) · mail nickname · forwarding target · hidden from address lists.
- Entra: email aliases (primary marked) · mail nickname.

**Licence detail** (Entra only)
- Each licence: assigned directly or through which group, and any assignment error · the service plans that are switched on.

Not included (Steve didn't ask for them): Entra sync status, photos, profile-page fields, SID history, service principal names.

## How (implementation)

**Mirror.** A second, read-only list beside the joiner catalogue — same shape (directory, attribute, label, kind, group) but never offered in Admin ▸ Joiner fields and never written. The syncs read catalogue + read-only list together into the same `ad_details` / `entra_details` blobs (COM-863); the select/attribute list is still derived, so adding one forces its own full read.

**Active Directory** (`core/ad_reader.py`)
- `accountExpires`, `pwdLastSet`, `lastLogonTimestamp`, `lockoutTime` are Windows FILETIME integers; `0` and `9223372036854775807` on `accountExpires` both mean "never"; `pwdLastSet = 0` means must change at next logon. Convert at read, store ISO timestamps.
- `userAccountControl` is already read (for enabled). Decode the flags: `DONT_EXPIRE_PASSWORD 0x10000`, `PASSWD_NOTREQD 0x20`, `SMARTCARD_REQUIRED 0x40000`. Do **not** offer "cannot change password" — it is an ACL, not a flag, and the UAC bit is not reliable.
- `lockoutTime` non-zero means locked *at that time*; whether it is still locked depends on the domain's lockout duration. Show "locked out since", not "locked".
- `logonHours` is 21 bytes, one bit per hour, **in UTC** — render in words in the viewer's time zone or say UTC; all-ones or absent = any time. `userWorkstations` is a comma-separated string.
- `profilePath`, `scriptPath`, `homeDirectory`, `homeDrive`, `whenChanged`.
- `proxyAddresses` (multi-valued; `SMTP:` upper-case = primary), `mailNickname`, `targetAddress`, `msExchHideFromAddressLists` — exist only where the Exchange schema has been added; ask only for attributes the schema has (COM-863 records which).
- Use `lastLogonTimestamp` (replicated), never `lastLogon` (per-DC). Note its updates bump `uSNChanged`, so the incremental pass will re-read people as they log on — fine at this size; check the pass stays in seconds.

**Entra ID** (`tasks/directory_sync.py`)
- `creationType`, `identities`, `signInSessionsValidFromDateTime`, `proxyAddresses`, `mailNickname`, `assignedPlans`, `licenseAssignmentStates`.
- **Verify each against the real tenant on both reads** — the full `/users` list and `/users/delta`. Some user properties are returned only on `$select`, and some are not tracked by delta at all (`signInActivity` was one; it has its own sweep). For any that delta doesn't carry, the nightly full crawl is the source and the screen should not imply it is minutes fresh.
- Licence detail joins the SKU names the mirror already has (`assigned_license_skus`) and resolves `assignedByGroup` to the mirrored group's name.

**Screen.** `access/UserDetailModal.tsx`, one `Section` per group, after Details (COM-866). API: extend the `details` list on `DirectoryUserDetailOut` with a `group` and `read_only`, or a second list — whichever keeps the modal simple. New kinds for display only: yes/no, timestamp, list.

**Personal data / security.** Logon hours, home folders and aliases are less sensitive than phone numbers, but the same rule holds: no values in logs. Never read or store password hashes, `unicodePwd`, `supplementalCredentials` or anything credential-bearing — the read-only list is an explicit allow-list, not "everything else".

Cover in the ADR written for COM-863: the mirror holds read-only facts as well as settable details.

## Done when

- [ ] An AD person shows account state, logon restrictions, profile settings and mail addresses on staging, with last logon marked approximate.
- [ ] A cloud-only person shows account state, mail addresses and licence detail; a synced person shows both directories' groups without duplication.
- [ ] "Never expires", "must change password at next logon" and "any time / all computers" read correctly — not as dates in 1601 or raw numbers.
- [ ] A licence that comes through a group names the group.
- [ ] A domain without the Exchange attributes still syncs and simply shows no AD mail section.
- [ ] Each Entra property confirmed present on the full read, and its freshness (delta or nightly) recorded in the code beside it.
- [ ] None of these can be chosen in Admin ▸ Joiner fields or changed by a request.