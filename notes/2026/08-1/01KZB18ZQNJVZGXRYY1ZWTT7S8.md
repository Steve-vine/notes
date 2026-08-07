---
id: 01KZB18ZQNJVZGXRYY1ZWTT7S8
created: 2026-08-06T07:58:15.285924Z
updated: 2026-08-07T10:35:35.348139Z
type: task
title: 'threshold_specs(): connector-declared tunable thresholds + ADR'
project: 01KX671DATY39VW6GWK3M2T3DN
number: 578
sprint: syjypmr
comments:
- id: 01KZB58BAY84ERNFJ1F31WQY4P
  author: Steve Vine
  at: 2026-08-06T09:07:48.701935Z
  text: |-
    Done — PR #492 (feature/ise-578-threshold-specs), ADR 0088 Accepted.

    Shape as planned, with one design call worth recording. `ThresholdSpec` carries a LIST of `ThresholdRung`s rather than a single value plus an optional ladder: a single trip point is just a one-rung spec. That keeps one shape for the UI to render and one code path to resolve, and it puts the derived-vs-declared question where it belongs — in the declaration, not in two different types.

    The Canon ruling holds in the ADR: derived ladders stay derived (Freshservice pages at 2x its threshold, M365 escalates at a fully-consumed pool — both declare ONE rung and keep the arithmetic in the detector), and only independently-meaningful bands become rungs (the EntraID 90/60/30/expired calendar lead times). The test in the ADR is "should moving one band move another?" — if yes it is one threshold with a derivation.

    Built:
    - `ThresholdSpec` / `ThresholdRung` + `threshold_specs()` on the connector base, default `[]`.
    - `ISE_api/thresholds.py` — resolution (override -> declared default), bounds validation, `severity_for(measurement)` walked most-severe-first, and `bands()` for echoing the effective ladder into observation `details`.
    - `GET`/`PUT /api/v1/systems/{id}/thresholds`, generic over whatever the connector declares. Envelope response so "declares none" is a value the UI reads, not a 404.
    - 44 tests (34 unit + 10 API integration against real Postgres).

    Two guards that came out of the work rather than the plan:
    - **An unreachable rung fails silently**, so it is refused twice: the spec validator rejects a malformed declaration at import, and the write path rejects an override that would invert a ladder. Bounds alone cannot catch it — 30 and 90 are both legal numbers of days. The ladder is checked as a whole AFTER the edits, so an operator can shift two bands in one save.
    - A stored override that no longer validates (hand-edited row, or narrowed bounds) falls back to the default **and logs a warning** — the detector must still run, but an operator whose number is being ignored has to be able to find out.

    No migration: overrides live in `System.config` under the keys the old shapes already used, so an estate carrying a hand-set `license_threshold_percent` keeps it, now validated and visible. api-types regenerated on the branch.
assignee: steve
priority: medium
task_status: done
---
Add a declarative threshold mechanism to the Connector base, as a sibling of ADR 0085's `sweep_specs()` (`connectors/base.py:733-741`): connectors declare their tunable trip points; core assembles, persists overrides, and exposes them — only the connector's own module changes when a threshold is added.

**Shape:**
- `ThresholdSpec`: key, default, min/max bounds, unit (days/percent/count), description, and which detector it feeds.
- `threshold_specs()` overridable base method, default `[]` (mirror `SweepSpec`, `base.py:135-170`).
- Resolution order: per-System override (`ctx.config`, typed + bounds-validated against the spec) → declared default. Effective value echoed into observation `details` (the `m365.py:553` pattern).
- Exposed on `/api/v1` so the generic config UI can render specs + current values. No migration expected (overrides live in existing `System.config` JSONB).

**ADR must address:**
- ADR 0026's stance (per-integration thresholds must decide *what a signal is worth*, never *whether to act* — auto-incident gating stays global).
- ADR 0085's caveat: declaring must not remove configurability — specs declare defaults + bounds + a config key, they don't bake values in.
- The ISE-537 lesson (`obs_loop.py:46-53`): a defaulted-but-invisible setting sat inert for a sprint — declared thresholds must surface as real visible values.
- Multi-rung ladders (a spec may declare an ordered band→severity ladder, not just one trip point) — the EntraID credential-expiry task is the first consumer.

Retires the two current ad-hoc shapes: `_LICENSE_THRESHOLD_PERCENT` raw-JSON override (`m365.py:481-498`) and the hand-wired `_FRESHSERVICE_CONFIG_KEYS` (`systems.py:714-729`) — actual migrations are separate tasks in this sprint.