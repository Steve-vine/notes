---
id: 01M101Y9MR3F6DKKQ9C277QQMA
created: 2026-08-26T22:09:38.456277Z
updated: 2026-08-27T22:54:07.612444Z
type: task
title: A person holds business roles on the record — and a mover removes the old role's groups, precisely
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 448
sprint: snq23hz
comments:
- id: 01M12PWF27E5XVFACV78WSX5QE
  author: Steve Vine
  at: 2026-08-27T22:54:07.431793Z
  text: |-
    Done — merged to main as 0c5d158 (PR #464). Full CI green (one npm registry timeout on the frontend job, rerun clean — an infrastructure signature, not a real failure).

    **The record.** `directory_user_business_roles` — company-scoped, audited, keyed on the Entra object id, carrying the request that put it there. **No endpoint sets it**, deliberately: a person's roles are the outcome of an approved change, and an editable copy would immediately disagree with the memberships it is supposed to explain. A joiner's roles land, a mover's replace, a leaver's clear.

    **The mover, rewritten.** Removals now come from the provenance record rather than the matrix: a membership goes only when it is role-derived from a role the person no longer holds. `core/business_role_holdings.plan_mover` sorts the current memberships into three buckets — removed, exception (kept), unattributed (kept) — and the execution task writes the first and *says the other two out loud* in `outcome_detail`: "1 approved exception(s) kept: Legacy Share", "3 membership(s) Compass cannot explain, kept as unexplained: …".

    **Dropping an unexplained membership** is an explicit decision: `drop_group_ids` on the mover subject, which joins `_GATE_EDITABLE_FIELDS` so the approver can change the answer — they are exactly the right person to answer *keep or drop?*. Dropping one is an ordinary removal down the ordinary path, with its ledger row, and clears the record. Keeping one leaves it unattributed, never promoted to an exception.

    **Making the listing readable before approval.** `GET /directory/users/{id}/groups` gained `provenance`, `business_role` (name, not a GUID) and `request_id`; a membership with no record yet reads as unattributed, which is the honest answer rather than a blank. `AccessSubjectOut` gained `held_business_roles`, so a mover request shows what the person is being moved *away from*. COM-450 puts it on screen.

    **Migration 0129** is additive: one table plus `drop_group_ids` defaulting to `[]`, so in-flight requests keep everything. The role record cannot be back-filled — reconstructing it would mean replaying every executed request and hoping nothing happened in Entra in between — so it starts empty, which on day one makes every mover's removal set empty and its listing the whole value.

    **`test_mover_touches_managed_groups_only` was rewritten, not patched** — its premise was the sweep. In its place: a mover removes only the old role's groups; keeping a role keeps its groups (the sweep would have removed them); an exception survives and is listed and is *still* an exception afterwards; an unexplained membership is offered not removed; dropping one executes and clears; `drop_group_ids` is refused on a leaver and on an unmirrored group; a leaver clears the role record; a person's groups say why they have each one.
assignee: steve
company:
- moneypenny
label:
- feature
priority: high
task_status: review
---
Stacks on COM-447. Part 3 of COM-446.

`business_role_ids` lives on the request that changed them and nowhere else, so there is no answer to "what roles does this person hold?" except by replaying their history. A mover compensates by removing every managed group the new role set does not imply — a sweep, not a removal, and one that will destroy exceptions the moment COM-449 exists.

## What changes for the reader

**A person's roles are a fact you can look at.** And a mover does what you would expect: it takes away what the old role gave, adds what the new one gives, and leaves approved exceptions alone.

## Scope

**The record.** Which business roles a person holds, company-scoped, audited — changed by executing a request, never edited directly. A joiner's roles land here; a mover's replace them; a leaver's clear.

**The mover, rewritten against it.** Remove memberships whose provenance is *role-derived from a role they no longer hold*. Add what the new roles grant. Touch nothing else.

**Exceptions survive** (decided in COM-446). An approved exception was a deliberate decision and does not evaporate because someone changed job. The mover **lists** them on the request so the approver sees what is being kept — visible, not silently preserved.

**Unattributed memberships get asked about, not swept.** Day one every existing person is entirely unattributed, so a mover's removal set is empty and the listing is where the value is: *this person has fourteen memberships Compass cannot explain — keep or drop?* That is a better decision than any upfront mapping would have produced, because it is made against a real person and a real job change. Dropping one is a removal like any other and goes through the same execution path; keeping one leaves it unattributed rather than promoting it to an exception — an exception is something a person decided about *this* group, not a byproduct of a job change.

**Backfill.** The role record starts empty for everyone. That is correct and expected.

## Tests

Integration tests: a mover between two roles removes only the old role's groups; an exception survives a mover and appears in the listing; an unattributed membership is offered, not removed; dropping one executes and clears its record; a leaver clears the role record. Plus the existing mover tests, which will need rewriting rather than patching — their whole premise changes.