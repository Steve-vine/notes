---
id: 01M48CWQEEASNVW5AXZFMWFPQ7
created: 2026-10-06T10:42:02.318261Z
updated: 2026-10-06T15:00:31.721341Z
type: task
title: Moving someone to a new Primary role updates their account details — department, job title, manager — from that role's default values
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 849
sprint: sme8esk
blocked_by:
- 01M489XGQ5KGE8YC4BVMJ12VZ5
- 01M485X94AZDFKK464GADDPAD4
comments:
- id: 01M48VP0B214C9F6R6ET9VXQRX
  author: Steve Vine
  at: 2026-10-06T15:00:30.690695Z
  text: |-
    Done — PR #855, merged to main (b7a2180). Going to staging with the rest of the sprint.

    What changed for people
    - Mover form: changing the Primary role opens an Account details section — the same fields a joiner is asked for, each with what the account says now and what it will say after.
      · A field the new role has a default for is pre-set and listed as changing (Department: Sales → Support).
      · A field with no default shows what the account says and is left alone unless you edit it — so a leftover (Office: Chester) can be corrected or cleared in the same request.
      · Any field can be edited, cleared, or put back with "Leave as it is". Only what differs is sent; if nothing differs, the form says so.
      · Display name and sign-in name aren't there. Changing only Additional roles never shows the section.
    - Request page: each change reads before → after, beside the primary-role change. The approver can correct, add or drop one; if they change the primary, the new role's defaults are offered ("Apply these defaults"), not applied.
    - When it runs: written to the account — in AD for an account that lives there, in Entra for a cloud-only one. The account is read again first, so something changed in the directory in between isn't written twice ("already as asked: Department").
    - If Compass can't: something broke → that part shows Failed with Retry, and the role and access changes stand. Not set up to change it → a to-do naming each detail ("Set the account's details: Department → "Support", Office → clear it").

    Decisions I took (say if any is wrong) — recorded in ADR 0090
    - The account is read live (once for the form, once at run time) rather than Compass keeping a copy of every detail. If it can't be read, the form still works: it offers the defaults as "will be set to" and says the current values couldn't be read.
    - How a details to-do closes: where Compass is connected to AD, it checks the account every five minutes and closes the to-do when it matches (or does it itself once the OU is ticked). Where there is no AD connection there is nothing Compass could look at, so "I've done this" closes it — and the page says "Marked done by … — Compass has no connection to AD to check it", not "seen in the directory". This is the one to-do a tick closes.
    - "Changed outside Compass": Compass doesn't watch account details for outside changes at all, so its own writes can't appear on Validation. There's a test holding that.

    Known limit
    - A role's default values are kept per directory, and the role page sets them for the directory new starters are created in. In Hybrid, a cloud-only account moved to a new role therefore has no defaults offered — its fields show as they are, to be edited by hand. Say if cloud-only accounts in Hybrid are common enough to want that closed.

    Also found while doing this (fixed in COM-848's PR before it merged)
    - If AD refused to move the account, Retry would have skipped the move. It now retries it.

    Smoke test
    1. Give two roles different default Department and Manager (role page ▸ Default values).
    2. New mover for someone in the first role ▸ change Primary role to the second: Account details appears with Department and Manager pre-set as changes. Clear or edit another field.
    3. Approve. Check the account in ADUC (department, manager, the cleared field), then in Entra after the sync.
    4. For an account outside the managed OUs: the request finishes with a to-do naming the details; set them in ADUC and watch it close within five minutes.
assignee: steve
label:
- feature
priority: medium
task_status: review
---
Asked for by Steve, 2026-10-06, as the follow-on to COM-848 (a person's Primary role is remembered, and a mover changes it by name). Builds on COM-843 (a role's default values) and the Joiner fields set (COM-839…842).

## Why

After COM-848, moving someone from Sales Executive to Support Analyst moves their account to the right OU and swaps their access — and leaves the account saying Department "Sales", Job title "Sales Executive", Manager "Jane Smith". The details that were filled in from the role when they joined should follow the role when they move.

## What people see

### On the mover form

When the **Primary role is changed**, an **Account details** section appears under it. It lists the same fields the joiner form asks for, and for each one shows what the account says now and what it will say after:

- A field the **new primary role has a default for** is pre-set to that default and marked as changing — *Department: Sales → Support*.
- A field the new role has **no default for** is shown with its current value, unchanged — but can be edited, so a leftover from the old role ("Office: Chester") can be corrected in the same request rather than left behind.
- Every field can be edited or put back to its current value before the request is raised. A default is a starting point here too, never a rule.
- **Only fields that end up different from what the account says now are changed.** If nothing differs, the section says so and the request changes no details.
- **Display name and User principal name are not in this section** — a move doesn't rename anyone.
- Changing **only additional roles** never shows the section and never changes a detail.

### On the request, and at approval

- The request lists the detail changes, each as *before → after*, alongside the primary role change and the access changes.
- The approver can correct any of them before approving, as they can a joiner's fields. If the approver changes the primary role, COM-843's "apply the new role's defaults?" prompt covers the details.

### On the account

- When the request runs, the changed details are written to the account — in Active Directory for an account that lives there (reaching Entra through the sync), in Entra for a cloud-only one.
- **If Compass can't make the change**, the sprint's usual rule applies: something broke → that part shows **Failed** with a **Retry**; the account is somewhere Compass isn't set up to change (outside the managed OUs, or no AD connection) → it becomes a **to-do** for someone to do by hand, saying exactly which details to set; the role change and the access changes still go through.

## What's permanent

The request keeps the before and after of every detail it changed. Changing a role's default values later doesn't touch anyone who already holds the role — only joiners and movers raised afterwards.

## Decisions taken (say if any is wrong)

- **Shown and editable, never silent.** The requester sees every change before raising, and the approver before approving.
- **Which fields are listed depends on where the account lives**, not on the setup: an account that lives in Active Directory gets the Active Directory joiner fields, a cloud-only account gets the Entra ID ones — even in Hybrid, where both kinds exist.
- **Fields with no new default are left alone unless the requester edits them** — Compass can't tell a leftover from the old role from something set deliberately, so it shows it and lets a person decide.
- **A blank can be set deliberately.** Clearing a field in this section empties it on the account (unlike the joiner form, where a blank means "leave unset" — here there is a current value to remove).
- **Only on a primary change.** Editing someone's details without changing their primary role is not part of a mover; that would be a separate "correct this account" request if it's ever wanted.
- **A default Manager who has since left** isn't offered; the field shows its current value.

## Notes (technical)

- **Current values.** The mirror holds only `display_name`, `user_principal_name`, `mail`, `job_title`, `department`, `employee_id` for a person (`models/directory_mirror.py`; Graph `$select` in `tasks/directory_sync.py:130`). The other joiner fields — city, office, manager, country, extension attributes — aren't held anywhere. Recommended: **read that one account live when the mover form asks** (one Graph `GET /users/{id}?$select=…` plus `/manager`, or one LDAP search by GUID, limited to the attributes on the applicable Joiner fields list), served by an endpoint the form calls when the primary changes. Don't widen the mirror for this: on the Graph delta, `$select` declares what is tracked, so adding properties means a new `MIRROR_SELECT_VERSION` and a full re-crawl for a need that is one account at a time. If the directory can't be reached, the form shows the new defaults as "will be set to" without a "now" column, and says the current values couldn't be read.
- **Re-read at run time.** The before values on the request are what the form saw; execution reads the account again and writes only attributes whose current value differs from the wanted one, so a change made in the directory between raise and run isn't reported as Compass's.
- **Writing.** The machinery exists for an amendment's corrections: `ad_writer.update_attributes`, the `_AD_ACCOUNT_ATTRIBUTES` map, the Graph `PATCH`, the `user_updated` ledger entry, and the fall-back to a manual to-do via `manual_steps.raise_account_step(action=account_update)` when `_ad_managed_user` is false (`tasks/access_execute.py:2309-2338`). Generalise that path to take attribute names from the joiner-field catalogue (COM-839) instead of the fixed three-field map — one account-update routine for amendments and movers. Attribute names are checked against the catalogue at write time. Kinds from COM-842 need their writers here too: AD `manager` (resolve the manager's current DN), the three AD country attributes together, Entra `manager` via `PUT /users/{id}/manager/$ref` (or `DELETE` to clear), Entra extension attributes under `onPremisesExtensionAttributes` (cloud-only accounts only).
- **Routing** follows `ad_scope.ad_management` like every other write: from configuration, never health. Write-time error → Failed + Retry; not set up → to-do. The to-do text lists attribute → value by the admin's field names.
- **Which list:** AD anchor on the record (`ad_object_guid`, `on_premises_sync_enabled`) → the Active Directory list; otherwise the Entra ID list. The defaults read are the new primary role's for that directory (COM-843 stores them per directory).
- Mover subject: add the detail changes as a snapshot list, the same shape as a joiner's field snapshot (COM-840: directory, attribute, kind, label, value) plus `previous_value`. Validate by kind with the shared validator. A cleared field is stored as an explicit null, distinct from "not included".
- Form: the mover block in `RaiseRequestModal.tsx` (`MoverDiff`, rebuilt by COM-848); reuse the per-kind inputs and the *current → new* list component from COM-843 / COM-846. Gate: `SubjectFieldsEditor.tsx`; `subjectsFromRequest` must carry the new list (the COM-740 mistake). Request page: before/after rows.
- Detection: Compass's own detail changes must not come back on Validation as "changed outside Compass" — check how the AD and Entra detection passes attribute a change Compass made (the "Made in AD" actor line, COM-782) and make sure these writes are recognised as Compass's.
- Values are personal data: log attribute names, not values.
- API change → regenerate `schema.d.ts`, run the drift script. Migration only if the snapshot needs a new column on the subject (revision id ≤ 32 chars).

## Done when

- Changing the primary role on the mover form shows Account details with current and new values; defaults from the new role are pre-set; every field is editable; only real differences are sent.
- The request and the approver see each change as before → after; the approver can correct them.
- Running the request updates the account in AD or Entra as appropriate; an account Compass isn't set up to change gets a to-do naming the details; a write failure shows Failed + Retry without undoing the role change.
- A mover that changes only additional roles shows no section and changes no detail.
- Tests: the section (defaults applied, no-default fields shown unchanged, edit, clear, nothing-differs, directory unreachable); list chosen by where the account lives; execution for AD-managed / unmanaged (to-do) / cloud-only / failure + retry / value changed in the directory since raise; each field kind's writer; detection not flagging Compass's own change.
- Smoke-tested on staging: move someone between two roles with different default department and manager, check the account in ADUC and, after the sync, in Entra.