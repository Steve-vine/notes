---
id: 01KYN4P7AJD733BDV20XQR8FA6
created: 2026-07-28T19:54:37.266717Z
updated: 2026-08-07T10:06:34.287092Z
type: task
title: Integration-capability-driven nav visibility
project: 01KX671DATY39VW6GWK3M2T3DN
number: 351
sprint: sg4216j
blocked_by:
- 01KYN4P2G76A0WR46V6BRHQP9Y
assignee: steve
priority: medium
task_status: done
---
Hide the Integrations nav section's items unless a configured integration actually feeds them; show an item when **any** configured integration provides its capability (agreed 2026-07-28).

Gating is capability-based (ADR 0031 connector capability contract), not integration-name-based:
- **Alerts** ← any integration with a detection layer (DataDog today)
- **Observations** ← any integration the Obs Loop covers (Kubernetes today)
- **Documents** ← any document-register source (Confluence today)
- **Repos** ← any registered GitHub repo integration

Requirements:
- Frontend needs capability presence per configured integration — reuse/extend the existing integrations API if it already surfaces capabilities.
- A section title with zero visible items is hidden too.
- Direct URL to a hidden page (bookmark/old link) still renders, with a "no integration provides this yet" empty state — not a 404.
- New integrations declaring a capability light the item up with no nav changes.

Builds on the sectioned-nav task.