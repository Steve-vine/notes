---
id: 01KZ5TC7Q383T3NDFTNQ00AYHK
created: 2026-08-04T07:21:29.571631Z
updated: 2026-08-07T12:15:51.982889Z
type: task
title: 'Estate list: filter by who operates an entity — ours vs third-party'
project: 01KX671DATY39VW6GWK3M2T3DN
number: 527
order: 1.5
sprint: skxht3g
comments:
- id: 01KZ68MT1E75M9PXF1S6YJYWY3
  author: Steve Vine
  at: 2026-08-04T11:30:50.542241Z
  text: |-
    Built — PR #451, branch feature/ise-527-operated-by-filter. No migration.

    FILTERED ON `operated_by`, AS RECOMMENDED
    New opt-in `operated_by=internal|external` on GET /api/v1/entities. It reads ADR 0073's general attribute rather than EntraID's `tenant_owned`, so the same control answers the question for the status page register's provider services and M365's too — not just Entra.

    THE TRAP WAS REAL, AND CHECKED RATHER THAN ASSUMED
    Confirmed straight against Postgres: `('{}'::jsonb ->> 'k') != 'external'` is NULL, `... is distinct from 'external'` is true. So with `!=`, "Ours" returns only the handful explicitly marked internal and silently drops every entity that never stated an operator — nearly all of them. `IS DISTINCT FROM` it is.

    A PROCESS NOTE WORTH YOUR ATTENTION
    My first attempt to prove the test catches the trap was itself broken: I edited the code to the naive `!=`, the tests passed, and I nearly recorded that as "the guard is weak". The replace had silently matched nothing, because ruff had wrapped the expression across three lines — so I was testing unchanged code. Re-broken properly, two tests fail as they should. I now assert the break landed before trusting the result of a break-it check; a no-op edit and a passing test look identical otherwise.

    WHAT THE TESTS HOLD
    - Third-party returns only externally-operated entities.
    - Ours includes every entity that never stated an operator — the trap head-on, asserted on names AND count, because the failure mode is a list that looks fine.
    - The two halves PARTITION the estate: ours + theirs = everything, nothing double-counted, nothing lost. That property is what makes the filter trustworthy rather than merely functional, and it is the one I would want if I came back to this in six months.
    - An unknown value is refused (422).
    - Frontend: the filtered row is genuinely on screen and the other genuinely is not — reachability, not "a request was made". Also that unfiltered still shows both, so the control cannot quietly hide half the estate from someone who never opens the filters.
    - The frontend guard was verified by dropping the query param: two tests fail.

    NOT DONE, DELIBERATELY
    No index. `attributes` is JSONB with none on this key, and it wants measuring on the live estate first — a sequential scan may be entirely fine at this size, and an unused index is its own cost.

    UI NOTE
    Nothing had to shrink to make room, as flagged when the task was written: the FilterPanel already wraps to a second line by design. ISE-528 stands on its own merits. Wording matches the entity-page badge exactly. The persisted-filters hook already merges stored values over defaults, so a returning operator picks up the new key with no version bump and no lost filters — someone had already thought of that.

    VERIFICATION
    Full backend suite 2187 passed; frontend 579 passed; ruff, mypy, eslint, prettier, npm run build clean. OpenAPI + api types regenerated.

    FOR YOU on staging: "Ours" should give the 334 — worth checking against the number, not just that the list changed.
assignee: steve
label: null
priority: medium
task_status: done
---
Follow-up to ISE-526, which made ours-vs-third-party visible **per entity** and not across the list. Nobody wants to click through 1,781 service principals to find the 334 that are ours.

## The row does NOT need to shrink first

Worth stating up front, because it changes the shape of this task: `FilterPanel` already wraps. `components/FilterPanel.tsx:93` — `<Group gap="md" align="flex-end" wrap="wrap">`, with the comment *"a second line of filters grows the panel rather than shoving the table sideways — and the operator opened it deliberately"* (ISE-192/478).

So this filter can land on its own. Combining the four date inputs into two range pickers is worth doing for its own reasons and is tracked separately — **it is not a blocker for this**.

## Filter on `operated_by`, not on `tenant_owned`

ISE-526 set two things on a service principal: `tenant_owned` (bool, EntraID-specific) and, for the ones the tenant does not own, `operated_by: "external"` — ADR 0073's existing statement about who runs a thing.

Filter on `operated_by`, because it is the general concept and already carries the same meaning elsewhere: the status page register stamps it on provider services (`status_pages.py:265`) and the M365 connector on Microsoft's services (`m365.py:238`). One filter then answers "which of these are somebody else's" across the whole estate, not just for Entra. Filtering on `tenant_owned` would build an EntraID-only control and leave the same question unanswerable everywhere else.

## The trap that will get whoever builds this

**Absence is not third-party.** Most entities have no `operated_by` key at all, and in SQL `attributes->>'operated_by' != 'external'` evaluates to NULL for a missing key — so the row is silently excluded. "Ours" would return only entities explicitly marked as ours, which is almost none of them, and the filter would look like it worked.

Use a NULL-safe comparison (`IS DISTINCT FROM`), and assert the count in a test rather than only asserting that filtering does something. ADR 0073 is explicit that external-ness is the attribute — absence means we operate it.

## Scope

1. **Backend**: a new opt-in query param on `GET /api/v1/entities`, e.g. `operated_by=internal|external`, filtering on the JSONB key. `limit` stays opt-in — this must not become a fourth caller that quietly truncates (ISE-523).
2. **Index**: `attributes` is JSONB with no index on this key. Measure on the live estate (4,717+ entities) before adding an expression index on `(attributes->>'operated_by')`; a sequential scan may well be fine at this size, and an unused index is its own cost.
3. **UI**: a `Select` in the Estate `FilterPanel` — All / Ours / Third-party — wrapped in a `FilterField` like the others, and counted in `activeCount` so the badge and "Clear filters" stay honest.
4. **Wording**: "Ours / Third-party" is the operator's language and matches the entity-page badge ISE-526 added. Keep the two the same — a filter that says "External" against a badge that says "Third-party" is two names for one idea.

## Definition of done

An operator can filter the Estate list to entities their organisation operates, and to those somebody else does, and the counts reconcile with the entity pages. On the live tenant, "ours" should give the 334 tenant-owned service principals — verify against the number, not just that the list changed.

## Testing notes

- Assert on **what the operator can reach**, not that a request was made — the ISE-515 lesson. A filter that sends the right query param and renders an empty list has failed.
- Cover the absence case explicitly: an entity with no `operated_by` at all must appear under "Ours" and not under "Third-party".
- The count assertion is the one with teeth: filter, then check the total, because a NULL-safe bug shows up as a plausible-looking short list rather than an error.