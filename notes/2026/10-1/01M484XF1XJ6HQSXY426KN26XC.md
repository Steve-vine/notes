---
id: 01M484XF1XJ6HQSXY426KN26XC
created: 2026-10-06T08:22:37.885311Z
updated: 2026-10-06T12:28:17.161632Z
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
task_status: active
---
Asked for by Steve, 2026-10-06. Third of four — follows COM-839 (Joiner fields on Access Control ▸ Admin) and COM-840 (the joiner form collects them and the request keeps them); COM-842 (Manager, Country, hire date) builds on this. Until this ships the values are collected and shown but not written anywhere.

## What people see

When an approved joiner request runs, the new account is created **with the fields already filled in** — first name, last name, job title, city, an extension attribute, whatever the request carried. Open the account in Active Directory Users and Computers or the Entra admin centre and they are there. A field left blank on the form is left unset on the account.

- **Hybrid:** the account is created in Active Directory with its fields; they reach Entra the usual way, through the directory sync. Compass doesn't write them twice.
- **If the directory refuses** (for example Compass's AD account has no right to set one of the details), the joiner shows **Failed** with the reason and a **Retry** — and **no account is left half-filled**: once the cause is fixed, Retry finishes the same account with every field, rather than leaving it without them.

## Decisions taken (say if any is wrong)

- **Only an account Compass creates gets the fields.** If an account with that User principal name already exists — one somebody else made — Compass adopts it as it does today and leaves its details alone; it doesn't overwrite what someone else set.
- **A setup switched mid-request fails plainly.** If a request was raised with Active Directory fields and the setup has since changed to Entra ID only (or the reverse), the joiner fails with "raised for a different directory — raise it again" rather than quietly creating an account without the details.
- **Fields are set at creation only.** Changing them afterwards is a mover/correction, not part of this.

## Notes (technical)

- AD: `_join_in_ad` in `tasks/access_execute.py` → `ad_writer.create_user` (`core/ad_writer.py:201`). Pass the request's snapshot values into the **same `connection.add`** that creates the object — all of this task's AD catalogue, extension attributes included, are plain single-valued strings and can go on the add. Prove against the Samba test DC that a delegated (non-admin) account can set them on `add`; `tests/fake_ad.py` (ldap3 MOCK_SYNC) won't tell you. The Samba test domain has no Exchange schema — the extension-attribute test needs the attribute added to its schema, or to be proven on staging.
- Entra: the joiner `POST /users` body near `access_execute.py:1229` — add the standard properties to the same request. **Extension attributes** are `onPremisesExtensionAttributes: { extensionAttributeN: … }`; Graph lets them be written only on a cloud-only account (which an account Compass creates in Entra ID only is). Check whether `POST /users` accepts them; if not they need a `PATCH` straight after the create.
- **Retry must tell "the account I made on an earlier attempt of this request" from "somebody else's account"** — today both take the adopt branch (`find_user_by_upn` → `created = False`), which by the decision above writes nothing. Wherever a field can't ride on the create itself (the Entra PATCH above; COM-842's Entra manager), a failure after the create would otherwise lose the fields for good. The subject's `user_created` ledger entry already says Compass made it: an adopted account with that entry for this subject gets its outstanding fields written; one without is left alone.
- Attribute names come from the request's snapshot and are checked against the catalogue again at write time (never send an attribute name the catalogue doesn't hold).
- Which directory: the existing routing (configuration, not health — ADR 0083). Snapshot directory ≠ directory being created in → fail the subject with the plain message above. A write-time refusal is "something broke" → Failed + Retry, never a to-do (the sprint's "can't do it" rule).
- Rights: check the AD delegation list in the setup docs (the "Compass Directory Writers" dsacls recipe) covers writing these attributes on user objects in the managed OUs, and update the doc if it needs more.
- The mirror record needs nothing new — it describes the account from the next read.
- Redaction: values are personal data but not secrets; keep them out of log lines all the same (log attribute names, not values).

## Done when

- A joiner raised with fields is created in AD (AD only, Hybrid) or Entra (Entra ID only) with exactly those attributes set — extension attributes included; blanks unset.
- A refusal shows Failed + Retry with the reason; Retry after fixing the cause ends with one account carrying all its fields.
- An existing account Compass didn't create is adopted untouched.
- Tests: AD create with fields against the Samba test DC; Entra create payload (and the extension-attribute write); the refusal path; retry completing a Compass-made account; the adopt path; the switched-setup path.
- Smoke-tested on staging with a real joiner, checked in ADUC.