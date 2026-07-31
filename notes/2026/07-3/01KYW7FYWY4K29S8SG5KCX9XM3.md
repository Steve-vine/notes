---
id: 01KYW7FYWY4K29S8SG5KCX9XM3
created: 2026-07-31T13:58:18.782125Z
updated: 2026-07-31T14:05:06.76237Z
type: task
title: 'Integration docs: Webhooks'
project: 01KX671DATY39VW6GWK3M2T3DN
number: 418
order: 1.015625
sprint: sp3en5k
assignee: steve
label:
- feature
priority: medium
task_status: todo
---
Replace the webhooks stub (`src/content/docs/integrations/webhooks.md`) with full operator documentation:

- **Capabilities** — accept events from systems with no native connector; events on the Events screen; webhook-backed alerts via the synthetic system; how webhook signals participate in incidents like any other source.
- **Setup** — creating a webhook source, the unique ingest URL and its token semantics (treat as a secret; rotation), enabling/disabling a source.
- **Examples** — a payload example (curl) that lands as an event; one that raises an alert signal; a sensible pattern for wiring a third-party system's outbound webhooks to ISE.

Ground in ADRs 0047 (webhook events) + 0048 (webhook alerts / synthetic system); rewrite for operators, released capability only.