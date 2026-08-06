---
id: 01KZB18ZQNJVZGXRYY1ZWTT7S8
created: 2026-08-06T07:58:15.285924Z
updated: 2026-08-06T08:34:32.910548Z
type: task
title: 'threshold_specs(): connector-declared tunable thresholds + ADR'
project: 01KX671DATY39VW6GWK3M2T3DN
number: 578
sprint: syjypmr
assignee: steve
label: null
priority: medium
task_status: backlog
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