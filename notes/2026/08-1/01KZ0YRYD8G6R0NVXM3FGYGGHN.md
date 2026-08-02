---
id: 01KZ0YRYD8G6R0NVXM3FGYGGHN
created: 2026-08-02T10:02:08.168852Z
updated: 2026-08-02T10:03:35.913485Z
type: task
title: 'Unknown assets: alerts against things no source of record claims'
project: 01KX671DATY39VW6GWK3M2T3DN
number: 470
sprint: s7j0986
assignee: steve
label:
- feature
priority: urgent
task_status: backlog
---
The counterpart to demoting DataDog, and what stops the demotion losing information.

When an alert arrives against something no source of record claims:

- The **alert and any Incident are still created**, flagged as an **unknown asset**.
- **No placeholder entity is minted** — that pollution is exactly what the three-layer model designs out.
- The flag is a **temporary state, not a label**: when the account, cluster or server is finally integrated, the existing back-fill re-links the alert to the real Resource with its incident history intact.
- Gaps are **deduplicated by the identifier the source used** — "4 unknown hosts, 17 alerts", never 17 orphans.

Today 54 of 77 findings in production carry no entity at all, so this surface has immediate content.

**UI**: a coverage-gap view listing unknown assets by identifier with their alert counts and which integration is reporting them. This turns the integration backlog into an evidence-backed list — and later becomes the detector for infrastructure appearing outside the accounts ISE knows about. Steve has confirmed more AWS/Azure accounts and clusters exist but are intentionally not yet added, plus physical servers awaiting a 'Server' integration, so this list is expected to be substantial and useful from day one.

**Acceptance**: an alert naming an unknown thing opens an incident that says so; no entity is created for it; the gap list is deduplicated and shows what would close it; integrating a source re-links its previously-unknown alerts.

Ship with the source-of-record task.