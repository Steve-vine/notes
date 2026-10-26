---
id: 01M5X2KCV7GMQM7RVRQT24HGSD
created: 2026-10-26T21:41:55.687187Z
updated: 2026-10-26T22:47:56.883327Z
type: task
title: Someone who signs in with Entra has their job title from the directory, so content reviews (and vendor reviews and SAP approvals) record it without anyone typing it in
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1344
sprint: s4zhkvy
comments:
- id: 01M5X6C6F3VQGBTGXBMBQRSR5R
  author: Steve Vine
  at: 2026-10-26T22:47:54.082742Z
  text: |-
    Done — PR #1353 merged (4cc94f70).

    What changed:
    - Someone who signs in with Entra now has their job title from the directory. Compass copies it at every sign-in and after every directory sync (Entra and Active Directory).
    - A title HR changes in the directory reaches Compass on the next sign-in or sync, so new content reviews, vendor reviews and SAP approvals record it without anyone typing it.
    - On Admin ▸ Users, a title the directory holds shows read-only with "From Entra" underneath.
    - Reviews already recorded keep what they recorded.

    My calls, for you to check:
    1. A linked person whose directory record has no title keeps whatever an Admin typed, and that field stays editable. "From Entra" (read-only) shows only when the directory actually holds a title. Otherwise an empty directory value would lock an empty field.
    2. Typing a different title for a directory-sourced account is refused: "Job title comes from Entra — change it in the directory". Sending back the same value is accepted.
    3. The label says "From Entra" even for an account whose title came from on-prem AD. For a synced account, AD is where HR changes it, but Entra shows the same title. Say if you'd like "From the directory" instead.
    4. The sync refreshes every linked account on every pass. It writes only when the title differs, so a quiet pass changes nothing.

    To smoke-test on staging:
    - Sign in with Entra (or wait for the next directory sync, about 15 min).
    - Your row on Admin ▸ Users should show your Entra job title and "From Entra", and the field shouldn't be editable.
    - Record a content review: the Document Review history and PDF show your title.
    - An older review still shows a blank title.
assignee: steve
label:
- bug
priority: medium
task_status: review
---
## What Steve saw

When he reviews content, the review doesn't pick up his job title. He signs in with his Entra account.

## Cause

- **A review records the reviewer's job title** from their Compass account (`User.job_title`):
  - content reviews (`api/v1/content.py`);
  - vendor reviews (`vendors.py`);
  - SAP plan approvals (`sap.py`).
- **That field is only ever filled in by hand**, by an Admin on the Users page.
- **Signing in with Entra doesn't set it**, and neither does SCIM provisioning. The sign-in token doesn't carry a job title.
- **Compass does know it.** The directory sync (Access Control) holds every person's job title from Entra, or from on-prem AD for synced accounts (`DirectoryUser.job_title`). It just never reaches the account.

## Behaviour

- **An account linked to the directory takes its job title from the directory.** That's anyone who signs in with Entra or was provisioned from it.
  - It's filled in at each sign-in, and refreshed whenever the directory sync sees it change.
  - When HR changes a title in Entra, Compass follows.
- **On the Users page**, a linked account's job title shows as "From Entra" and can't be edited there. It's changed in the directory. Local accounts keep the editable field as today.
- **If the directory has no job title for someone**, any title an Admin typed in is kept rather than blanked.
- **Reviews and approvals already recorded keep what they recorded.** A review is a record of who signed off and in what role at the time, so past reviews with no title stay as they are. New ones carry the title.
- This covers every place a reviewer or approver's title is recorded: content reviews, vendor reviews and SAP approvals.

## Notes for the build

- **The rule:** when `User.entra_object_id` is set, `job_title` = `DirectoryUser.job_title` for that object id. Write it:
  - on OIDC sign-in, alongside the existing entra_object_id back-fill;
  - in the directory sync, after a person's row is upserted, for linked users whose title changed. Batch it and keep the sync idempotent.
- A null directory title doesn't overwrite a non-null one.
- **Users API:**
  - Return `job_title_source: "directory" | "local"`.
  - Refuse a PATCH of `job_title` on a linked account (422, "Job title comes from Entra").
  - This is an API change, so regenerate schema.d.ts. No migration is needed: the column exists.
- **Users page:** show the title read-only with a "From Entra" hint for linked accounts.
- **Check the multi-tenant case:** `DirectoryUser` can exist per company, so the same person may have a row per tenant. Pick the row matching `entra_object_id`; object ids are unique per tenant.
- **Tests:**
  - sign-in fills the title;
  - a sync change updates it;
  - a null directory title keeps the typed one;
  - a local account is unchanged;
  - the PATCH is refused on a linked account;
  - a content review made after sign-in records the title;
  - an older review is unchanged.