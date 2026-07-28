---
id: 01KYNB1CZQV52VVWS9Q2H5CXCS
created: 2026-07-28T21:45:34.967319Z
updated: 2026-07-28T21:45:34.967319Z
type: task
title: Status page alert signals with used-service filtering
task_status: backlog
label: feature
assignee: steve
priority: medium
project: 01KX671DATY39VW6GWK3M2T3DN
number: 356
---
A provider incident on a service we use shows up as an Alert signal like any other — and issues on unused services never alert.

**Signal raising**
- Mirror the `webhook_signals.raise_signal_for_event` state machine (ADR 0048): new → `Finding(signal_type="alert", status="triggered")`; refire after resolve → `recurring`; `ignored` never overridden by a re-fire. Dedup on `(system_id, source_key)` with `source_key = "{page_id}:{provider incident/component id}"`. `kind` = provider slug (enables per-provider severity overrides via ADR 0026 layer).
- Severity map from provider impact: none/maintenance → no signal (or info), minor → medium, major → high, critical → critical — final map recorded in the ADR.
- `entity_id` set directly to the Third-Party entity (no hint resolution); tags via `tags.reconcile_finding_tags`; then `promote_findings` so incident auto-open/threshold logic applies unchanged.

**Filtering**
- Only tracked services raise signals. Untracked-component issues stay visible in the page state on detail, never as signals.

**Recovery (dual)**
- Explicit: provider marks the incident resolved / component back to operational → `recovered` + `resolved_at` + promotion transition.
- Staleness: unfetchable page → TTL auto-recover sweep for its open alerts (pattern: `tasks/webhooks.recover_stale_webhook_alerts`), with the fetch error surfaced on list/detail so silence isn't mistaken for health.

**Acceptance**: state-machine integration tests (new/refire/resolve/re-fire-after-resolve/ignored-stays-ignored); an incident on a tracked service appears on the Alerts screen, opens an incident at threshold, and shows on the entity's graph signal state; the same incident on an untracked component produces zero signals; recovery clears within one poll of the provider clearing.