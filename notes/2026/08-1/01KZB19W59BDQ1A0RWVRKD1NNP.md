---
id: 01KZB19W59BDQ1A0RWVRKD1NNP
created: 2026-08-06T07:58:44.393482Z
updated: 2026-08-07T10:35:09.94751Z
type: task
title: Migrate Freshservice burst config to threshold_specs, retire bespoke surface
project: 01KX671DATY39VW6GWK3M2T3DN
number: 581
sprint: syjypmr
blocked_by:
- 01KZB18ZQNJVZGXRYY1ZWTT7S8
- 01KZB198WA3NK866R0GHVGE1TX
comments:
- id: 01KZB714DZ1P2WFHNVBS3TD87Z
  author: Steve Vine
  at: 2026-08-06T09:38:49.407684Z
  text: |-
    Done — PR #496 (feature/ise-581-freshservice-threshold-specs, stacked on #495).

    Four specs declared: `ticket_burst` (count, 2-1000, medium), `ticket_burst_window` (minutes, 5-1440, scoping), `duplicate_cluster` (count, 2-100, medium), `duplicate_cluster_window` (hours, 1-168, scoping). Same keys, **same bounds as the retired Pydantic model** — moving a validated setting onto a new mechanism must not quietly re-validate it differently. Derived ladder untouched: medium at threshold, high at 2x, still derived from the one number.

    I migrated the cluster tunables alongside the burst ones, though the task named only burst. Leaving cluster in the bespoke card while burst moved to the generic one would recreate exactly the split the sprint exists to remove, and they are the same shape.

    **One scope decision I want to flag, because it departs from the task as written.** The task asked to retire `_FRESHSERVICE_CONFIG_KEYS`, the endpoints, the schema and `FreshserviceConfigCard.tsx` outright. I did that for the thresholds and deliberately NOT for the rest — the card also carries:
    - `requester_email`, the one field `create_ticket` cannot work without. Deleting its editor recreates the exact live-smoke failure ADR 0068 §8 records ("No requester configured", with no way to set it).
    - ticket scope: types, queues, categories, priority floor, lookback — lists and filters, not trip points.
    - `cluster_adjudication_enabled` — a boolean.

    Widening the threshold mechanism to hold a tag list, a switch and an email address would rebuild the per-connector config surface under another name; the numbers are the part that generalises. The card is retitled "scope and requester" and points at the thresholds card so an operator can find where the numbers went, and the ADR's consequences section now records the split. **If you'd rather retire the whole card, that needs a home for scope first — say so and I'll raise it as a follow-up task.**

    Because both surfaces now write to one `System.config`, there is a new test holding that **saving scope leaves a threshold override alone** — the obvious way this could have silently wiped somebody's tuning.

    Also moved the four DEFAULT_* constants from `freshservice_detect` to `connectors/freshservice`: a default is now half of a declaration, and a declaration importing its numbers from the module that consumes them closes an import cycle.

    6 new tests; freshservice suites green (35 detect + 27 ingest), backend unit 688, frontend 638. api-types regenerated — removing four public schema fields reddens the snapshot, as the task predicted.
- id: 01KZBDZS32GR0PDWQ1VHTP77FH
  author: Steve Vine
  at: 2026-08-06T11:40:25.058262Z
  text: |-
    Scope question resolved — Steve accepted the split as built (2026-08-06, at release).

    The rule that now stands: **the threshold mechanism owns numeric trip points; per-connector config owns everything else.** Freshservice keeps its own card and endpoints for ticket scope (types, queues, categories, priority floor, lookback), the AI-adjudication switch, and `requester_email`. Only the four numeric trip points moved to `threshold_specs()`.

    The reasoning, for whoever revisits this: `requester_email` is the field `create_ticket` cannot work without, and removing its editor recreates the ADR 0068 §8 live-smoke failure exactly. The rest are lists, strings and a boolean. Widening ThresholdSpec to carry them would rebuild the per-connector config surface under a new name — the numbers are the part that generalises, and that is where the decoupling win actually is.

    So a connector may legitimately have BOTH a generic thresholds card and its own config card. That is not a leftover to clean up later; it is the intended shape. ADR 0088's consequences section records it.
assignee: steve
priority: medium
task_status: done
---
Move the ticket-burst tunables (`freshservice_detect.py:46-54, 229-240`: `burst_window_minutes`, `burst_min_tickets`) onto declared `ThresholdSpec`s, and retire the hand-wired per-connector surface they currently require:

- `_FRESHSERVICE_CONFIG_KEYS` + `_require_freshservice` type guard (`systems.py:711-739`)
- the bespoke GET/PUT config endpoints (`systems.py:741-780`) and their Pydantic model (`schemas.py:307-317`)
- `FreshserviceConfigCard.tsx` — replaced by the generic threshold card

Keep the derived ladder exactly as-is (medium at threshold, high at 2× — the `freshservice_detect.py:236-240` stance): the specs declare the two inputs, not four knobs. Same config keys so existing per-System overrides carry over.

Removing API endpoints reddens the OpenAPI snapshot — regen api-types on this branch. Acceptance: burst config is editable via the generic card with identical validation bounds (`ge=5, le=1440` etc.), bespoke endpoints and card gone, detector behaviour unchanged.