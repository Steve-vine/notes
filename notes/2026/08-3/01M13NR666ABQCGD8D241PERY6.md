---
id: 01M13NR666ABQCGD8D241PERY6
created: 2026-08-28T07:53:33.126446Z
updated: 2026-08-28T07:53:51.58673Z
type: task
title: Coverage proposals read an empty holder record as fact — retire everything, nearly-match everyone
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 479
sprint: snq23hz
assignee: steve
company:
- moneypenny
label:
- bug
priority: high
task_status: todo
---
Defect in COM-454, found testing sprint 45 on staging (`staging-20260828-0133`).

Two proposal rules read `directory_user_business_roles` and treat **empty** as *nobody holds any role*. That record starts empty for everyone and stays empty until a joiner or mover executes (COM-448 says so in its own migration note), so on day one both rules answer against no data as though it were evidence.

## What it looks like

With two roles in the matrix and no holders recorded yet, the Coverage tab offers **both roles for retirement** — and, two rows further down, **two people who nearly match one of those same roles**. The tool contradicts itself on one screen: *retire this, nobody holds it* beside *these two people look like they do this job*.

That is precisely the failure ADR 0061 §7 warns about — "a proposal that is wrong once is a tool people stop opening" — and it is the first thing anybody sees on a brand-new surface.

## Two rules, one root cause

**`_retirements` — wrong today.** Proposes every active role with groups whose id appears in no holder row. The docstring currently claims holder count avoids the day-one problem a time-based rule would have. **It does not, and the comment is wrong** — an empty record and "nobody holds it" are indistinguishable to that query. Do not trust that comment when picking this up.

**`_near_matches` — wrong at scale, not yet visible.** Same blind spot: with no holder rows, nobody is filtered out as already holding the role. Combined with `MAX_MISSING_GROUPS = 1`, a role mapping a **single** group near-matches *every mirrored user* — those holding it (missing 0) and those holding nothing of it (missing 1). Only 2 proposals appear on staging today because so little is populated; on the real tenant this is a proposal per user per single-group role.

## Scope

**Keep unknown apart from empty.** The distinction this codebase already maintains elsewhere — `directory_role_names` null vs `[]` (COM-252), `actor_kind` null vs `unknown` (COM-390). Uninitialised is not unheld.

- **Retirement:** suppress the kind entirely while a company has **no holder rows at all**. Once any role has ever been held, the query means what it says and the rule can run.
- **Near match:** require `missing < len(role_groups)` — you have to hold *something* of a role to be near it. Missing every group of a one-group role is not a near miss, it is a stranger.

Fix both together. They are one misreading, and correcting it in one rule while leaving it in the other is how the next person concludes the first fix was wrong.

## Not in scope

The clustering rule (`_clusters`) reads provenance, not the holder record, and is unaffected. The near-match proposals for people who genuinely hold all of a role's groups are correct and should keep firing — that half is working.

## Tests

- A company with roles and **no holder rows** gets no retirement proposals at all.
- Once one role has a holder, a *different* role with none is proposed — the rule still works, it just needs the record to mean something first.
- A one-group role proposes no near match for somebody holding none of it.
- Somebody holding all of a role's groups is still proposed (the case working today must not regress).
- The self-contradiction has a regression test: a role must never be offered for retirement in the same refresh that offers a near match against it.
