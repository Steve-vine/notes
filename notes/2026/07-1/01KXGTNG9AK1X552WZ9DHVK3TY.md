---
id: 01KXGTNG9AK1X552WZ9DHVK3TY
created: 2026-07-14T17:26:48.362554649Z
updated: 2026-07-19T21:30:30.376704225Z
type: task
title: Frontend — decisions search box + Declined status
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 92
sprint: sk4616x
assignee: steve
task_status: done
priority: medium
---
Frontend for **M20 — Decisions**, consuming <issue id="728f4187-10f2-4097-a2bb-9f9bd3e19143" href="https://linear.app/stevevine/issue/DEV-670/backend-decision-fuzzy-search-pg-trgm-declined-status">DEV-670</issue>. Two small additions to the existing decisions UI: a **fuzzy search box** on the Decisions list page, and surfacing the new `declined` status. Design in **ADR 0029** (project repo). Depends on the backend brief (the `q` param and `declined` enum value). Do this brief second.

### Why (ADR 0029 context)

As decisions accumulate the `/decisions` page — which today offers only a status `Select` (`pages/DecisionsPage.tsx`) — gets hard to navigate; the backend now supports typo-tolerant fuzzy search via a `q` param. Separately, `declined` joins `proposed/accepted/superseded` as a terminal status that **stays visible**, so it needs to appear in the status filter, the New/Edit forms, and as its own pill.

### Decisions (ADR 0029)

* **Search box on the Decisions page (§2).** A text input beside the existing status `Select` that filters the table via the backend `q` param (trigram-ranked). Typo-tolerant — surfacing previous decisions is the milestone's headline ask.
* `declined` **stays visible (§4).** A normal terminal status: selectable when authoring, filterable on the list, listed by default (not hidden). `StatusPill` colour — `gray` (a neutral terminal state, sharing the muted tone of `superseded`; `proposed`=blue / `accepted`=teal).

### Checklist

- [ ] `q` **in the decisions hook** (`decisions/hooks.ts`): extend `useDecisions` to accept an optional query string and pass it to `GET /decisions?q=`; fold it into the React Query cache key (`['decisions', status, q, ...]`). Debounce input (~300ms) so typing doesn't spam requests.
- [ ] **Search input on** `DecisionsPage.tsx`: a `TextInput` (clearable, search affordance) beside the status `Select`; wire to local state → debounced hook. Empty query restores the default (number-ordered) list. Keep the status filter working alongside it.
- [ ] `declined` **in** `STATUSES` (`decisions/status.ts`): add `'declined'` so it appears in the list-filter `Select` and the New/Edit status `Select`s automatically.
- [ ] `declined` **colour** (`components/statusColors.ts`): add `declined: 'gray'` to the `COLORS` map (decision-status section). Default label "Declined" is fine (auto-capitalised) — no `LABELS` entry needed.
- [ ] **Regenerate the API client** from the updated OpenAPI schema (picks up `q` and the `declined` enum value) so `DecisionStatus` includes `declined`.
- [ ] **Tests** (`DecisionsPage.test.tsx`): typing in the search box issues a `q`-filtered request and renders the result; `declined` is selectable in the status filter and renders a gray pill in the table. Update any fixture/enum lists that hard-code the three statuses.

Note: the M6 global top-bar search already has its input; its typo-tolerance upgrade is **server-side** (<issue id="728f4187-10f2-4097-a2bb-9f9bd3e19143" href="https://linear.app/stevevine/issue/DEV-670/backend-decision-fuzzy-search-pg-trgm-declined-status">DEV-670</issue>) — **no frontend change** needed there.

Refs: ADR 0029 (this milestone), 0021 (global search), 0013/0001 (decision records), 0022 (StatusPill / status colours), 0017 (IA).

---
*Migrated from Linear [DEV-671](https://linear.app/stevevine/issue/DEV-671/frontend-decisions-search-box-declined-status) · created 2026-06-27 · completed 2026-06-27*  
*Related to (Linear): DEV-670*