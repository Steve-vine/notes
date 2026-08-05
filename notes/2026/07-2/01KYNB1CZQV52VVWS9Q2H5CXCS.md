---
id: 01KYNB1CZQV52VVWS9Q2H5CXCS
created: 2026-07-28T21:45:34.967319Z
updated: 2026-08-05T12:34:46.922005Z
type: task
title: Status page alert signals with used-service filtering
project: 01KX671DATY39VW6GWK3M2T3DN
number: 356
sprint: s9cqr80
blocked_by:
- 01KYNB0HDA8Z6HCTHHQ0ZN70YX
- 01KYNB13T7ZZGC7ZJENZXFE187
comments:
- id: 01KYNE2160N18EDQJ1239JDP06
  author: Steve Vine
  at: 2026-07-28T22:38:21.376655Z
  text: |-
    Built and in review. PR #329 (stacked: #325 → #326 → #327 → #328 → #329), merged to staging.

    Delivered: reconcile_signals mirrors active incidents onto Alert Findings on the statuspage System (ADR 0048 state machine: dedup {page_id}:{incident id}, refire attaches, cleared-then-back = recurring, ignored durable, provider resolution recovers), then ordinary promote_findings — overrides/threshold/Alerts screen/entity glow unchanged. kind = provider slug for per-provider severity overrides; impact map minor→medium, major→high, critical→critical, unknown→medium, none/maintenance raise nothing; entity_id set directly to the third-party entity; signals carry the page's tags. Filtering: only tracked services raise (title fallback for incidents naming no components); feed-only pages alert on everything until tracked names narrow by title; unticking recovers immediately. Staleness: recover_stale_page_alerts (new status_page_alert_ttl_minutes, default 30) auto-recovers an unreadable page's open alerts. Full map recorded in ADR 0057 §5.

    Gates: backend ruff/mypy/pytest green (49 tests incl. the full state machine + webhook-signals regression + migration check), frontend build + 435 vitest + prettier green.
assignee: steve
priority: medium
task_status: done
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