---
id: 01M101Y9MR3F6DKKQ9C277QQMA
created: 2026-08-26T22:09:38.456277Z
updated: 2026-08-27T21:54:58.505659Z
type: task
title: A person holds business roles on the record — and a mover removes the old role's groups, precisely
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 448
sprint: snq23hz
assignee: steve
company:
- moneypenny
label:
- feature
priority: high
task_status: todo
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