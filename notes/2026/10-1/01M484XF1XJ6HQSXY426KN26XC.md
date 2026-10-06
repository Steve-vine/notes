---
id: 01M484XF1XJ6HQSXY426KN26XC
created: 2026-10-06T08:22:37.885311Z
updated: 2026-10-06T08:22:43.980344Z
type: task
title: A new starter's account is created with the joiner fields filled in — in Active Directory or Entra ID
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 841
sprint: sme8esk
blocked_by:
- 01M484WJ71CDQ6ZHAE9V756XHP
assignee: steve
label:
- feature
priority: medium
task_status: todo
---
Asked for by Steve, 2026-10-06. Third of three — follows COM-839 (Joiner fields on Access Control ▸ Admin) and COM-840 (the joiner form collects them and the request keeps them). Until this ships the values are collected and shown but not written anywhere.

## What people see

When an approved joiner request runs, the new account is created **with the fields already filled in** — first name, last name, job title, city, whatever the request carried. Open the account in Active Directory Users and Computers or the Entra admin centre and they are there. A field left blank on the form is left unset on the account.

- **Hybrid:** the account is created in Active Directory with its fields; they reach Entra the usual way, through the directory sync. Compass doesn't write them twice.
- **If the directory refuses** (for example Compass's AD account has no right to set one of the details), the joiner shows **Failed** with the reason and a **Retry** — and **no half-made account is left behind**: the account is created with all its fields or not at all.

## Decisions taken (say if any is wrong)

- **Only an account Compass creates gets the fields.** If an account with that User principal name already exists, Compass adopts it as it does today and leaves its details alone — it doesn't overwrite what someone else set.
- **A setup switched mid-request fails plainly.** If a request was raised with Active Directory fields and the setup has since changed to Entra ID only (or the reverse), the joiner fails with "raised for a different directory — raise it again" rather than quietly creating an account without the details.
- **Fields are set at creation only.** Changing them afterwards is a mover/correction, not part of this.

## Notes (technical)

- AD: `_join_in_ad` in `tasks/access_execute.py` → `ad_writer.create_user` (`core/ad_writer.py:201`). Pass the request's snapshot values into the **same `connection.add`** that creates the object, not a later `modify`: a retry after a partial failure takes the "adopt an existing account" branch (`find_user_by_upn`), which by the decision above writes nothing — so a create-then-modify that fails halfway would lose the fields for good. Prove against the Samba test DC that a delegated (non-admin) account can set this catalogue's attributes on `add`; `tests/fake_ad.py` (ldap3 MOCK_SYNC) won't tell you.
- Entra: the joiner `POST /users` body near `access_execute.py:1229` — add the properties to the same request. All of the Entra starting set is accepted on create.
- Attribute names come from the request's snapshot and are checked against the catalogue again at write time (never interpolate an attribute name the catalogue doesn't hold).
- Which directory: the existing routing (configuration, not health — ADR 0083). Snapshot directory ≠ directory being created in → fail the subject with the plain message above. A write-time refusal is "something broke" → Failed + Retry, never a to-do (the sprint's "can't do it" rule).
- Rights: check the AD delegation list in the setup docs (the "Compass Directory Writers" dsacls recipe) covers writing these attributes on user objects in the managed OUs, and update the doc if create-time setting turns out to need more.
- The mirror record needs nothing new — it describes the account from the next read.
- Redaction: values are personal data but not secrets; keep them out of log lines all the same (log attribute names, not values).

## Done when

- A joiner raised with fields is created in AD (AD only, Hybrid) or Entra (Entra ID only) with exactly those attributes set; blanks unset.
- A refused attribute leaves no account, and shows Failed + Retry with the reason; Retry after fixing the cause creates the account with its fields.
- An adopted existing account is untouched.
- Tests: AD create with fields against the Samba test DC; Entra create payload; the refusal path; the adopt path; the switched-setup path.
- Smoke-tested on staging with a real joiner, checked in ADUC.