---
id: 01KYW7FYWY4K29S8SG5KCX9XM3
created: 2026-07-31T13:58:18.782125Z
updated: 2026-08-07T10:55:52.85314Z
type: task
title: 'Integration docs: Webhooks'
project: 01KX671DATY39VW6GWK3M2T3DN
number: 418
order: 1.015625
sprint: sp3en5k
comments:
- id: 01KYW8HCC980MQPJKX4C92E1A9
  author: Steve Vine
  at: 2026-07-31T14:16:33.929075Z
  text: |-
    Done on feature/ise-418-docs-webhooks — PR #16, left OPEN for the PR-preview test.

    Full Webhooks page: capabilities (events on the Events screen with outcome badges; level:alert → real alert signals with per-source severity mapping, alert_key dedup, unchanged threshold/correlation; entity-hint resolution that never invents entities; recovery via status:recovered + per-source alert TTL; the data-never-instructions trust posture), setup (register source → minted token, URL-is-the-credential warning, ISE-defined schema with generated sample curl, unknown fields preserved, rotate/disable), examples (deploy event curl, backup-failure alert curl with recovery, thin-adapter wiring pattern). Facts from ADRs 0047/0048 + connectors/webhook.py. Build/lint green.

    That's all eight integration docs tasks (ISE-411..418) now in Review with PRs #9–#16 open.
assignee: steve
priority: medium
task_status: done
---
Replace the webhooks stub (`src/content/docs/integrations/webhooks.md`) with full operator documentation:

- **Capabilities** — accept events from systems with no native connector; events on the Events screen; webhook-backed alerts via the synthetic system; how webhook signals participate in incidents like any other source.
- **Setup** — creating a webhook source, the unique ingest URL and its token semantics (treat as a secret; rotation), enabling/disabling a source.
- **Examples** — a payload example (curl) that lands as an event; one that raises an alert signal; a sensible pattern for wiring a third-party system's outbound webhooks to ISE.

Ground in ADRs 0047 (webhook events) + 0048 (webhook alerts / synthetic system); rewrite for operators, released capability only.