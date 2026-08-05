---
id: 01KZ8WVPJMVZ871X4EGC4R26KQ
created: 2026-08-05T12:02:36.756477Z
updated: 2026-08-05T12:53:11.09994Z
type: task
title: Ignore / downgrade actions leave no trace on the incident timeline
project: 01KX671DATY39VW6GWK3M2T3DN
number: 557
sprint: scb3vol
assignee: steve
priority: medium
task_status: backlog
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