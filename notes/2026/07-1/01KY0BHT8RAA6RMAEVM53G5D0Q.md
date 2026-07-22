---
id: 01KY0BHT8RAA6RMAEVM53G5D0Q
created: 2026-07-20T18:10:29.784875Z
updated: 2026-07-22T11:23:10.989693Z
type: task
title: Create incident manually from an alert (signals three-dots menu)
project: 01KX671DATY39VW6GWK3M2T3DN
number: 164
order: 6.0
sprint: skj7tft
assignee: steve
priority: medium
task_status: done
---
ADR 0025 §4 promises an Incident can be opened by "a **person**, manually, from any signal below the bar" — this was never implemented. Today the only Finding→Issue path is auto-promotion above the ADR 0026 threshold (`promotion.py:promote_findings`), so a below-bar alert can never become an incident. The manual `POST /issues` path (`IssueCreate`, `schemas.py:126-131`) cannot reference a signal: `finding_id`/`correlation_key` are not settable, so a manual incident is invisible to correlation, gets no resolution cascade, and risks a duplicate incident if the alert later worsens past the threshold.

## UI

Add **"Create incident"** to the three-dots item menu on the signals list (`SignalsPage.tsx`, alongside Silence/Suppress). Navigate to the new incident on success.

## Backend

New operator-gated endpoint (e.g. `POST /api/v1/findings/{id}/open-incident`) reusing `_new_issue` (`promotion.py:49`) so `finding_id`, `correlation_key` and severity are set exactly as auto-promotion does. Respect the correlation invariant — at most one non-closed incident per key: if one already exists, return it (or 409) rather than duplicating. Audit-record the creation with the human actor.

## Source

The incident's `source` is a new value **`escalated`**, rendered **"Escalated"** in the UI — distinguishing a human escalating a signal from auto-promotion (`finding-promoted`), free-form `manual`, and `ai`. Requires extending the `ISSUE_SOURCES` check constraint (`models.py:28`) — append-only Alembic migration to replace the constraint — plus the frontend source label/badge mapping.

## Semantics

Manual open is a human act — allowed regardless of Ignore/silence/suppression, which govern *automation* only (ADR 0025: "a human can always open an Incident by hand").

## Cross-refs

- ISE-161 — the timeline `Alert triggered - <alert name>` entry should also fire on manual open.
- ISE-160 — timeline entry formatting.