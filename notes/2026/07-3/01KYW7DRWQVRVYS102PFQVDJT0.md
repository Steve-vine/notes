---
id: 01KYW7DRWQVRVYS102PFQVDJT0
created: 2026-07-31T13:57:07.095968Z
updated: 2026-08-05T12:02:49.776427Z
type: task
title: 'Integration docs: DataDog'
project: 01KX671DATY39VW6GWK3M2T3DN
number: 411
order: 1.25
sprint: sp3en5k
comments:
- id: 01KYW82Y9TQ6M259XAKER333P6
  author: Steve Vine
  at: 2026-07-31T14:08:40.762893Z
  text: |-
    Done on feature/ise-411-docs-datadog — PR #9, left OPEN for the PR-preview test.

    Full DataDog page replacing the stub: capabilities (host/APM-service discovery into the estate with tag provenance; per-monitor-group alert signals with natural recovery; ignore rules incl. the save-time preview; on-demand evidence — query_metrics / search_logs / search_events / active_metrics; action table ack_event T0, mute/unmute_monitor T1 with the downtime semantics and one-week cap, set_host_tag T1, edit_monitor T2), setup (API + app key with the five read scopes, site field, encryption/redaction note, ~2-min monitor sync), three worked examples (alert→incident, evidence pull, env:sandbox ignore rule). Facts checked against connectors/datadog.py and ADRs 0027/0044. Build/lint green.
assignee: steve
label: null
priority: medium
task_status: done
---
Replace the DataDog stub (`src/content/docs/integrations/datadog.md`) with full operator documentation:

- **Capabilities** — what is discovered into the estate (hosts, services, tags), monitor alerts as signals (per-group semantics, recovery), ignore rules, metrics/logs as on-demand evidence.
- **Setup** — creating the integration: API/app keys, credential handling (never stored in plaintext), verifying the connection.
- **Examples** — a monitor alert arriving as a signal on an incident; pulling metric/log evidence during an investigation.

Ground in the app repo (ADR 0044 ignore rules, connector capability contract ADR 0027); rewrite for operators, released capability only.