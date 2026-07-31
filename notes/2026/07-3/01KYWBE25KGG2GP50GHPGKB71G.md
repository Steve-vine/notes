---
id: 01KYWBE25KGG2GP50GHPGKB71G
created: 2026-07-31T15:07:10.899397Z
updated: 2026-07-31T15:16:15.579531Z
type: task
title: Freshservice burst + same-issue cluster detectors
project: 01KX671DATY39VW6GWK3M2T3DN
number: 441
order: 1.0
sprint: s5pft6a
blocked_by:
- 01KYWBDKMHGT3KM4TK3H6Q8KWF
assignee: steve
priority: medium
task_status: todo
---
The point of the integration: humans are a sensor. Mine the ticket stream for two derived signals.

**Both are Observations, not Alerts.** Per the Canon, Alerts come from a source's own detection layer; Observations are ISE-derived where there is none. Freshservice has no detection layer — it has tickets. Both detectors are ISE-computed aggregates → `signal_type="observation"` with confidence, gated by the auto-incident confidence bar (default 0.70).

**Detectors compute in Python over ONE freshly-fetched batch** covering `max(burst_window, cluster_window)`. They never query `webhook_event`. This keeps signal correctness independent of a 90-day-purged table, and makes the detector a pure function of a live read — ADR 0030's model ("the rate is a single read — no cross-pass state").

- **Burst** — count of in-scope tickets created in the window ≥ threshold → **one** signal carrying the count. The `_node_flap_observations` rate-guard shape (`connectors/kubernetes.py:1694`): alert on the rate, not the event.
- **Same-issue cluster** — normalise each subject (lowercase, strip ticket refs/punctuation/stopwords) → token set; cluster by Jaccard similarity; one observation per cluster of ≥3 carrying the member ticket ids.

**`pg_trgm` is unavailable** — `CREATE EXTENSION` is a privilege the CNPG role may not hold, recorded in `search.py` and migrations 0054/0062/0073. SQL-side similarity is not an option; client-side token-set comparison is the design, not a compromise.

**AI adjudicates the grey band only** — invoked solely for candidate pairs the deterministic pass cannot settle (mid-range Jaccard), over just those subjects, degrading to the deterministic answer when the model is unavailable or budget-exhausted (the `status_pages.comprehend` gating shape). Keeps spend proportional to genuine ambiguity rather than to helpdesk volume — the ADR 0030 idle-spend lesson.

**Source keys must be stable across the signal's life** or window-slide recovery breaks:
- `obs/tickets/burst` — no count, no timestamp in the key
- `obs/tickets/duplicate/{hash of sorted cluster tokens}`

Recovery then falls out for free: as the window slides past, the count drops below threshold, the key leaves the batch, and `reconcile_findings` recovers it. No state machine.

Entity-less (`entity_key=None`) — no CMDB means no reliable ticket→entity mapping, and ISE never invents an entity from a hint. Precedent: M365 licence observations (`connectors/m365.py:398`).

`kind` per detector (`ticket_burst` / `ticket_duplicate`) as the ADR 0026 severity-override tuning axis. Fixed per-detector confidence with a stated rationale (the `_LICENSE_CONFIDENCE` idiom). Calibrate so a threshold burst is *visible but does not page* and a 2x burst does — an operator who disagrees tunes via the override layer, not a config flag that defaults to off.

One instance-wide burst key in v1; `details` carries the category breakdown, so bucketing by group/category can follow once the data shape is known (the ISE-301 "don't invent buckets early" lesson).

Reconcile via `reconcile_findings(..., signal_types={"observation"})` then `promote_findings`. Use `_bounded_key()` — `source_key` is varchar(300).

**`obs_detection_enabled` stays `False` on this system, and this is load-bearing.** `reconcile_findings` treats absence within a signal_type as recovery. If the Obs Loop also reconciled `{"observation"}` here, its empty detector pass would silently recover every ticket signal the sweep just wrote. The column already defaults False (`models.py:460`) and `obs_loop.py:48` gates on it — so the requirement is "never opt in", plus a comment saying why, or a future maintainer will enable it and break detection invisibly.

UI: ticket-derived signals and incidents appear on the existing Signals and Incidents screens.