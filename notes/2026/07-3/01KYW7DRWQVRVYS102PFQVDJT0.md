---
id: 01KYW7DRWQVRVYS102PFQVDJT0
created: 2026-07-31T13:57:07.095968Z
updated: 2026-07-31T13:58:26.046979Z
type: task
title: 'Integration docs: DataDog'
project: 01KX671DATY39VW6GWK3M2T3DN
number: 411
sprint: sp3en5k
assignee: steve
label:
- feature
priority: medium
task_status: backlog
---
Replace the DataDog stub (`src/content/docs/integrations/datadog.md`) with full operator documentation:

- **Capabilities** — what is discovered into the estate (hosts, services, tags), monitor alerts as signals (per-group semantics, recovery), ignore rules, metrics/logs as on-demand evidence.
- **Setup** — creating the integration: API/app keys, credential handling (never stored in plaintext), verifying the connection.
- **Examples** — a monitor alert arriving as a signal on an incident; pulling metric/log evidence during an investigation.

Ground in the app repo (ADR 0044 ignore rules, connector capability contract ADR 0027); rewrite for operators, released capability only.