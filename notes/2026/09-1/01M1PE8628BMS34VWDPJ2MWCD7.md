---
id: 01M1PE8628BMS34VWDPJ2MWCD7
created: 2026-09-04T14:48:02.888248Z
updated: 2026-09-04T14:48:02.888248Z
type: task
title: A signal count is a dead end — nothing on the Business Application page opens the signals it counts
assignee: steve
label: bug
task_status: backlog
priority: medium
project: 01KX671DATY39VW6GWK3M2T3DN
number: 772
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