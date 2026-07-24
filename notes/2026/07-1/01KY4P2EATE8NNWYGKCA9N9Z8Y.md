---
id: 01KY4P2EATE8NNWYGKCA9N9Z8Y
created: 2026-07-22T10:31:18.106019Z
updated: 2026-07-24T12:07:52.487514Z
type: task
title: 'Estate: surface first-seen / last-seen dates in the list, and an Asset Details section on the detail page'
project: 01KX671DATY39VW6GWK3M2T3DN
number: 209
sprint: sbeam3b
comments:
- id: 01KY4TK89DSCAP0X5QD7QT8MJ6
  author: Steve Vine
  at: 2026-07-22T11:50:23.276918Z
  text: |-
    Done — PR #192 (feature/ise-209-estate-dates), stacked on #189/ISE-207. It has to be stacked: `last_seen_at` only exists on the Sprint 19 branch chain, not on main.

    **Estate list.** First seen and Last seen columns per row, relative time with the exact moment on hover. Relative rather than absolute here because a list is scanned for "is anything stale?" rather than read for a specific timestamp — and per the task, this is the screen where you'd notice a host that quietly stopped reporting.

    **Entity page.** New "Asset details" card at the top of the page with First seen (`created_at`), Last seen (`last_seen_at`), Last updated (`updated_at`). **Absolute** dates here, deliberately differing from the list: the value of these three facts *is* the date, and "2h ago" answers "is this fresh?" but never "when exactly?". The relative form sits alongside in dimmed text and the raw ISO is on hover. Added a shared `dateTime()` to `lib/format.ts`.

    It **absorbs** the ISE-206 last-reported line as specified — two ISE-206 tests updated to assert against the new section, plus a new test pinning that the old line is gone.

    **Both labelling traps from the task are handled with tooltips**, since the three dates look like they should agree and usually won't:
    - "Last updated" says it moves only when a discovered fact changes, and will often be far older than "Last seen" — being re-observed unchanged is not a change.
    - "First seen" says "when ISE first recorded this entity — not necessarily when the asset itself was created", rather than implying the asset's own age.

    **Null handling** as specified: an absent `last_seen_at` reads "Never" in both list and detail, never blank.

    **Confirmed pure frontend** — `EntitySummary` and `EntityDetail` already carried all three dates, so no backend, no migration, no `dump_openapi`/`generate:api`. The task's scoping was right.

    One placement note: the retired-entity alert sits above Asset details rather than below it. The alert is a banner tied to the "Retired" badge in the header, so separating them would leave the badge unexplained; Asset details is still the first *section* on the page, and for a live entity (the normal case) it is first outright.

    **Tests** — 5 new in `EstateDates.test.tsx` plus 2 updated. Frontend 288 passed, lint/format/build clean.
assignee: steve
priority: medium
task_status: done
---
ISE-206 started tracking `entity.last_seen_at` but only surfaced it on the detail page, as a single line. The estate list shows no dates at all, so an operator scanning the estate can't see how fresh anything is — which is the screen where you'd notice a host that quietly stopped reporting.

**Estate list (`EstatePage.tsx`)** — add First seen and Last seen columns. Relative time with the full timestamp on hover (`title={iso}` + `relativeTime`), the convention already used for baselines and signals. Current columns are Type / Name / Integrations / Tags, so watch the width — Name is the flexible one and two more date columns will squeeze it.

**Entity detail (`EntityDetailPage.tsx`)** — an **Asset Details** section at the top of the page (above the tags card and dependency graph), showing:

- **First seen** — `created_at`
- **Last seen** — `last_seen_at`
- **Last updated** — `updated_at`

*Absorb the existing last-reported line rather than adding to it.* ISE-206 put a "Last reported by discovery {relative}" line directly under the title; once Asset Details carries last-seen that line is duplication and should go.

**No backend work.** `EntitySummary` and `EntityDetail` already carry all three of `created_at`, `last_seen_at` and `updated_at` (confirmed against the OpenAPI snapshot 2026-07-22) — the list endpoint gained the lifecycle fields in ISE-206. No new columns, no migration, no `dump_openapi`/`generate:api` run. Pure frontend.

**Two semantics to get right in the labelling, because the three dates are easy to conflate:**

1. **`created_at` is not literally "first seen"** for every entity. It is when ISE first minted the row, which IS first-sighting for a discovered entity — and it survives a merge correctly, since `_merge_entities` keeps the oldest of the two. But a hand-created entity's `created_at` is when a human made it, and one that predates ISE-206 was minted whenever the estate was first built, not when the thing appeared in the world. Consider a tooltip saying "first seen by ISE" rather than implying the asset's own age.
2. **`updated_at` moves only when a discovered FACT changes**, not on every sighting — the reconcile is deliberately idempotent, which is the whole reason `last_seen_at` had to be added (ADR 0039). So "Last updated" means "something about this entity last changed" and will often be far older than "Last seen". That difference is genuinely useful information, but only if the labels make it obvious; two dates that look like they should match and don't will read as a bug.

**Null handling:** `last_seen_at` is nullable (an entity discovery has never reported). Render an explicit "never" rather than a blank — blank reads as fresh. Same treatment ISE-206 gave the detail-page line.

**Tests:** list rows render both dates; Asset Details shows all three with the full timestamp on hover; a null last-seen renders explicitly; the old duplicate line is gone.

Raised by Steve 2026-07-22 during the Sprint 19 smoke test, after ISE-206 shipped last-seen but left it invisible for live entities.