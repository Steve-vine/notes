---
id: 01M1PE8628BMS34VWDPJ2MWCD7
created: 2026-09-04T14:48:02.888248Z
updated: 2026-09-04T15:09:06.420841Z
type: task
title: A signal count is a dead end — nothing on the Business Application page opens the signals it counts
project: 01KX671DATY39VW6GWK3M2T3DN
number: 772
comments:
- id: 01M1PFEN27V1S3FZ3B7Q7H2BFY
  author: Steve Vine
  at: 2026-09-04T15:09:03.431074Z
  text: |-
    Built and merged — PR #714, `b011397c`, deployed to staging.

    **The route now exists end to end.** The entity page already rendered that entity's signals and the member's *name* already linked there; the count simply never pointed at it. So the count goes where the name goes, with `#signals` so it lands on the panel rather than the top of the page — the Signals card sits below the graph on any entity that has one, and a bare `/estate/{id}` would have dropped an operator somewhere that answered nothing.

    Both per-entity counts got the same treatment, because a count that opens in one table and not the next is worse than three that never opened:

    - `IncludedEntities.tsx` — the Signals column, in both the matched and the reached-via halves (one shared component).
    - `BusinessApplicationDetailPage.tsx` — the Members section's "N unassessed" badge, previously a tooltip and nothing more.

    **And the trail ends somewhere now.** Signal titles on the entity page open the same `SignalDetail` modal the Signals list opens. Following a count to a title you cannot open answers "which signals" halfway — a name with nothing behind it. `systemName` on the entity page was widened to accept `null` for the modal's sake: an alias always has a system, a signal need not.

    **Correction to this task's own body.** I listed the Business Applications *list* page as a third dead end. It is not — its whole row already navigates to the detail page with a pointer cursor, and the per-member breakdown lives there. Left alone deliberately.

    **Not taken:** `/alerts?entity_id=…`. `list_findings` has no entity parameter and the signals screen has no such filter, so it means an API parameter, a filter control and the snapshot churn behind them. Worth doing only if a shareable filtered signals view is wanted in its own right — a separate decision, and nothing here forecloses it.

    **Tests** — `SignalCountOpens.test.tsx`, four claims on the route rather than on the markup: the count is a link to `/estate/{id}#signals`; arriving with that hash actually scrolls the panel into view (asserted against the element itself, not merely that something scrolled); the unassessed badge is a route too; and a signal title opens the detail modal with its system resolved by name.

    Full vitest run rather than the touched files — 151 files, 1017 tests, all green — because a new hook landed in `EntityDetailPage` and nine other test files render it. `npm run build`, `lint` and `format:check` green. No backend change, so no OpenAPI or api-types drift; CI skipped both backend jobs and `api-types` passed.
assignee: steve
label:
- bug
priority: medium
task_status: review
tech: null
---
Smoke finding on the ISE-765 Business Application page: "it has detected 9 direct members, 8 of them show '1' in the signals column but I don't seem to have an obvious way to look at what those are, I can't click on that."

The count is correct — it is the affordance that is missing. Three separate counts on this surface are static text with no route out:

- `IncludedEntities.tsx` (the members table, both the matched and the reached-via lists) — the Signals cell is a bell icon plus a red `Text`, no `Anchor`.
- `BusinessApplicationsPage.tsx` — the list's Signals column repeats the same markup.
- `BusinessApplicationDetailPage.tsx` — the Members section's `unassessed_signals` Badge is a `Tooltip`, not a link.

A number that names a set an operator cannot open is telling them something is wrong and then closing the door. This is the read surface's job: the whole point of counting the signals against a member is that the next question — *which ones* — is the one worth asking.

The answer already exists in two places: the entity NAME in the same row already links to `/estate/{id}`, and the entity page already renders that entity's signals from `GET /api/v1/entities/{entity_id}/signals`. So the shortest honest fix is to make the count a link to the same place the name goes, landing on the signals rather than at the top of the page — an anchor into the entity page's signals panel.

The alternative — a filtered signals list at `/alerts?entity_id=…` — is a bigger job than it looks: `list_findings` has no `entity_id` parameter (only `system_id`, `severity`, `signal_status`, `q`), and neither does the signals screen, so it means an API parameter, a filter control and the drift that follows. Worth doing only if we want "the signals for this entity" to be a shareable, filterable view in its own right, and that is a separate decision.

Recommend the first. Whichever is chosen, all three counts should get the same treatment in one pass — a count that opens in one table and not in the next is worse than three that never opened.