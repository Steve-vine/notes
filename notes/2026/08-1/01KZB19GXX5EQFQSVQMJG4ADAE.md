---
id: 01KZB19GXX5EQFQSVQMJG4ADAE
created: 2026-08-06T07:58:32.893748Z
updated: 2026-08-06T09:18:29.613596Z
type: task
title: Migrate M365 licence threshold to threshold_specs
project: 01KX671DATY39VW6GWK3M2T3DN
number: 580
sprint: syjypmr
blocked_by:
- 01KZB18ZQNJVZGXRYY1ZWTT7S8
- 01KZB198WA3NK866R0GHVGE1TX
comments:
- id: 01KZB5VPZYM3RE2XSJGKJKCEHV
  author: Steve Vine
  at: 2026-08-06T09:18:23.230439Z
  text: |-
    Done — PR #494 (feature/ise-580-m365-threshold-spec, stacked on #493).

    `_LICENSE_THRESHOLD_PERCENT = 90` and its raw-JSON override are now a declared `ThresholdSpec` (percent, 1-100, at_or_above, detector `license-pool`). The value was already overridable — but only by hand-editing a JSONB column, with no bounds, no type check and nothing saying it existed. It has all three now, and shows in the generic card.

    **One rung, per the Canon ruling.** The escalation to `high` at a fully-consumed pool is arithmetic on this number, not a second knob: moving the bar should move both, so it stays a derivation in the detector rather than becoming a two-rung ladder. Bounds start at 1, not 0 — a bar of zero fires on every pool ISE can see, which turns the detector into noise rather than being a setting anyone wants.

    Behaviour unchanged at defaults, and the four pre-existing licence tests pass **unmodified** (trip at >= threshold -> medium, fully consumed -> high, threshold echoed into `details["threshold_percent"]`, 0-enabled guard).

    Three new tests cover the migration specifically:
    - the spec is declared with the right shape and one rung;
    - an estate carrying the OLD raw `license_threshold_percent` keeps working identically — no migration, because the spec declares the key the raw shape already used;
    - a stored value outside the new bounds falls back to 90 rather than leaving a detector that can never fire (previously 5000 would have been honoured and silenced the detector forever).

    One incidental fix that had to land here: `thresholds` now imports `get_connector` from `connectors.registry` rather than the `connectors` package. A connector module resolving its own thresholds closes an import cycle through a half-built package otherwise — the registry imports only `base`, which is why it is the safe door. Any future connector declaring specs would have hit this.
assignee: steve
label: null
priority: medium
task_status: review
---
Move the licence-exhaustion trip point (`m365.py:481-556`) onto the declared mechanism: `_LICENSE_THRESHOLD_PERCENT = 90` and its raw-JSON `license_threshold_percent` override become a declared `ThresholdSpec` (percent unit, sensible bounds), giving it typed validation and UI visibility for the first time.

Behaviour must be unchanged at the defaults: trip at ≥ threshold → medium, pool fully consumed → high, threshold echoed into `details["threshold_percent"]`. Any System that already carries a raw `license_threshold_percent` in `System.config` must keep working (same key, now validated).

Acceptance: the threshold shows up in the generic config UI for an M365 System; a staged over-threshold fixture still raises the pool-near-exhaustion observation at both rungs.