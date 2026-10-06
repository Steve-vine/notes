---
id: 01M487HTNKSMDP8RADDHH5YZX7
created: 2026-10-06T09:08:42.291657Z
updated: 2026-10-06T11:01:40.973374Z
type: task
title: The joiner form asks for a Primary role and Additional roles — the primary decides the OU and the field defaults
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 845
sprint: sme8esk
comments:
- id: 01M489JBVNC119WQTMN1VGKHPS
  author: Steve Vine
  at: 2026-10-06T09:43:57.045799Z
  text: |-
    Correction to the technical notes (found 2026-10-06): `new_starter_ou` has a **third** caller the body doesn't list — the mover path, `_move_to_new_role_ou` in `tasks/access_execute.py:1427`. When a mover loses the role whose OU their account sits in, it calls `new_starter_ou` with **all the roles they now hold, sorted by id** to pick where to move them (ADR 0083 §6). A mover has no primary role (this task keeps "primary" a joining-time idea), so changing `new_starter_ou` to take one primary role would break it.

    Keep the mover on today's rule: split the function — `new_starter_ou_for_primary(role_id)` for the joiner's two callers, and leave the existing multi-role walk for the mover, unchanged. Don't alter mover behaviour in this task. (Whether a mover should also name a primary role, instead of the id-order pick, is an open question with Steve.)
- id: 01M489XPWBV0VNYC00HZBSXFGW
  author: Steve Vine
  at: 2026-10-06T09:50:08.779735Z
  text: |-
    Superseded decision (Steve, 2026-10-06): the body says "Primary only matters at joining… nothing afterwards knows or shows which one was primary". That is no longer the plan — **COM-848** makes the primary role a remembered fact about the person, shown on the person and on the role, and changed by name in a mover request (which moves the account to the new primary's OU).

    For this task that means: still only the joiner form, request and OU rule, as written — but store `primary_business_role_id` on the joiner subject durably and don't discard it after execution, because COM-848 backfills each person's primary from it. The earlier comment's "leave the mover's multi-role walk unchanged" still holds for this task; COM-848 replaces it.
assignee: steve
label:
- improvement
priority: medium
task_status: active
---
Asked for by Steve, 2026-10-06.

## Why

A joiner's roles are picked in one box today, and **whichever was picked first** quietly decides where the account is created. Nothing on the form says so, and COM-843 was about to hang the field defaults off the same hidden rule. The order of clicks shouldn't carry meaning — the form should ask.

## What people see

### On the new-joiner form

Each joiner has two role fields, at the top of their block:

- **Primary role** — one role, **required**. It decides:
  - **where the account is created** (the OU named on that role — "New starters go in"), and
  - **the field defaults** that are filled in (COM-843).
- **Additional roles** — any number, optional. They add their **groups and shared mailboxes**, and nothing else: an additional role never changes the OU or the defaults.

The primary role's own groups and mailboxes are granted too, exactly as today — the starter ends up holding the primary and every additional role.

- A role can't be both: the one chosen as primary isn't offered under Additional roles, and choosing an additional role as the new primary moves it across.
- **Under Primary role the form says where the starter will be created** — "Created in Staff › Sales" — or, if that role names no OU and there's no default, says so there and then instead of when the request is submitted. (Active Directory setups only; in Entra ID only there is no OU and the line isn't shown.)
- The request can't be raised without a primary role for every joiner.

### On the request, and at approval

- The request shows **Primary role** and **Additional roles** separately.
- Wherever a joiner's roles can be corrected before approving, the same two fields are used. Changing the **primary** changes where the account will be created (the line under it updates) and triggers COM-843's "apply the new defaults?" prompt; changing additional roles does neither.

## What changes from today

- **OU:** today the account goes in the OU of the first-picked role *that names one* — so if the first role names none, a later role's OU is used. From now on only the primary counts: **primary role's OU, otherwise the default on Admin ▸ Integrations ▸ Active Directory.** An additional role's OU is never used.
- **A role is now required** to raise a joiner; today a joiner can be raised with none.

## Decisions taken (say if any is wrong)

- **Primary only matters at joining.** Once the account exists the person simply holds all their roles, as now; nothing afterwards (movers, reviews, the people listed on a role) knows or shows which one was primary.
- **Joiner requests already raised** treat their first-picked role as the primary — the same role that decides their OU today — so nothing waiting for approval changes where it lands. (The one difference: a waiting request whose first role names no OU and whose second does would now go to the default OU. Check staging for any before deploying; expect none.)
- **Required in every setup**, Entra ID only included — there it has no OU to decide, but it still decides the defaults.
- **An organisation with no business roles can't raise a joiner** until it has one; the form says so and links to the Role matrix.
- **Movers, leavers and the other request kinds are untouched.**

## Notes (technical)

- Today: a joiner subject holds `business_role_ids` (ordered JSONB list on `access_request_subjects`). `core/ad_scope.py:new_starter_ou` walks it in order and returns the first role's OU that exists, then the setup default; `new_starter_refusal` builds on it and is called at raise (`api/v1/access_requests.py:154`) and at run (`_join_in_ad`). Groups and mailbox grants are taken from the whole list (`access_execute.py` — `_grant_join_roles`, `mailbox_grants.role_grant_map`).
- API contract for a joiner subject: `primary_business_role_id` (required for kind `joiner`) and `additional_business_role_ids`. Store the primary explicitly (a column on the subject) rather than as "element 0 of the list" — a gate save or a client that re-sorts the list must not be able to change which role is primary. Keep `business_role_ids` as the full set (primary + additional) so every existing consumer of "the roles this joiner gets" keeps working unchanged; the server derives it, clients don't send both.
- Migration: add the column; backfill joiner subjects with `business_role_ids[0]` where the list is non-empty. Existing joiner subjects with an empty list stay null — only *new* joiner requests and gate saves are required to have one. Revision id ≤ 32 chars. CI migrates a fresh DB only — run the backfill against a populated copy locally before deploying.
- `new_starter_ou(db, company_id, primary_role_id)` → that role's OU if it names a live one, else the setup default. Update `new_starter_refusal`'s message to name the role ("Sales Executive names no OU for new starters — name one on the role, or set the default on Admin ▸ Integrations ▸ Active Directory"). Both callers pass the primary.
- "Created in …" line: a small GET (or a field on the role options the form already loads) giving each role's resolved new-starter OU path and refusal reason, so the form shows it without re-implementing the rule. Read from configuration only.
- Form: `JoinerRows` in `RaiseRequestModal.tsx` (a single `MultiSelect` today → a `Select` + a `MultiSelect` that excludes the primary). Gate: the joiner branch of `SubjectFieldsEditor.tsx`; `subjectsFromRequest` in `subjectFields.ts` must carry the new field or a gate save posts it blank (the COM-740 mistake). Request page: the roles rows in `RequestDetailPage.tsx`, including the before/after rows — which currently print raw ids joined by commas (`:861`); show names, and show a primary change as its own row.
- Validation (raise and gate save, one validator): primary present and a live role of this company; additional roles live, of this company, and not containing the primary (drop a duplicate silently rather than refuse).
- Order with the other joiner-form tasks: independent of COM-839…842 and COM-844 and can ship before them; **COM-843 builds on this** (its defaults come from the primary). COM-840 rebuilds each joiner's block on the same form — whichever lands second adopts the other's layout, with Primary role then Additional roles first in the block.
- API change → regenerate `schema.d.ts`, run the drift script.

## Done when

- The joiner form has Primary role (required) and Additional roles; the primary can't also be additional; the form says where the account will be created.
- A joiner is created in the primary role's OU, or the default OU when that role names none — never an additional role's.
- The starter holds the primary and all additional roles, with all their groups and shared mailboxes.
- The request page and the approval editor show and edit the two separately.
- Existing joiner requests still run, landing where they would have.
- Tests: the form (required, exclusion, swap, the "created in" line and its refusal); the API validator; `new_starter_ou` for primary-with-OU / primary-without-OU-with-default / neither, and that an additional role's OU is ignored; the backfill; a gate save round-tripping both fields.
- Smoke-tested on staging: primary with an OU plus an additional role naming a different OU → account in the primary's OU, holding both roles' groups.