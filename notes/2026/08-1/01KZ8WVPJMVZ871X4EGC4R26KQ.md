---
id: 01KZ8WVPJMVZ871X4EGC4R26KQ
created: 2026-08-05T12:02:36.756477Z
updated: 2026-08-07T10:56:08.677557Z
type: task
title: Ignore / downgrade actions leave no trace on the incident timeline
project: 01KX671DATY39VW6GWK3M2T3DN
number: 557
sprint: scb3vol
comments:
- id: 01KZ9A2KV18FQCHJAQRFZKCG41
  author: Steve Vine
  at: 2026-08-05T15:53:34.817873Z
  text: |-
    Fixed on feature/ise-557-timeline-audit, PR #476 (targeting main), merged to staging.

    All three fix bullets done:

    1. Issue-scoped audit rows: new _incidents_for/_audit_on_incidents helpers in severity_api.py resolve the affected incidents via correlation_key (the same join _resolve_live_incidents uses) and record an audit event on each — downgrade → signal_downgraded (severity + reason), ignore → signal_ignored (reason), silence → alert_silenced on each incident it resolves (that path bypasses apply_status_change, so those incidents previously just read "resolved" with no author), unsilence → alert_unsilenced including on the resolved incident. Finding-scoped audits stay for the audit trail; the timeline reader is unchanged and picks the rows up for free.

    2. Ignore now takes a required reason (downgrade always had one). The UI collects it in a modal mirroring the downgrade one; a bodyless POST is a 422. API types regenerated (ignore gained a request body — note for the staging api-types check).

    3. Silence/unsilence covered as above.

    Timeline rendering: describeAudit gains labels for the four actions with the reason front and centre ("Ignored the signal — known noisy", "Downgraded future occurrences to medium — …", "Silenced the alert … — incident resolved by silencing", "Un-silenced the alert").

    Tests: new integration test drives downgrade/ignore/silence/unsilence against a promoted incident through the API and asserts all four land on /issues/{id}/timeline with reasons and actor names; frontend test goes through the new modal. Backend + frontend suites, mypy, eslint, build all green locally.
assignee: steve
priority: medium
task_status: done
---
Found during Sprint 50 incident-management testing: clicking **Ignore** or **Downgrade severity** on an incident leaves no log entry on that incident — the operator who reads the incident later cannot see the action happened, who did it, or why.

## Root cause

The incident detail page's one-click actions (`IssueDetailPage.tsx` ~line 244) call `POST /api/v1/findings/{id}/downgrade` and `/ignore` (`api/v1/severity_api.py`). Both DO write audit events — but against the wrong entity for the timeline:

- `ignore_finding` audits with `entity=finding` (and takes **no reason at all**)
- `downgrade_finding` → `_upsert_override` audits with `entity=severity_override` (the reason lives only on the override row)

The incident timeline (`get_issue_timeline` in `api/v1/issues.py`) merges only audit events with `entity_type == "issue"` (plus its proposed changes) — so neither action ever surfaces. Compare `silence_alert`, which resolves live incidents via `_resolve_live_incidents` but has the same gap: its audit lands on the finding, not the incident.

## Fix

- Record an audit event against the affected open incident(s) too (resolve them via `correlation_key` as `_resolve_live_incidents` does), carrying actor, action, and reason — the timeline then picks it up with no reader changes.
- Add a `reason` field to the ignore endpoint (downgrade already has one) and pass it through from the UI.
- Same treatment for silence/unsilence while in there.