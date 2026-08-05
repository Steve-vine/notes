---
id: 01KZ0YRYD8G6R0NVXM3FGYGGHN
created: 2026-08-02T10:02:08.168852Z
updated: 2026-08-05T12:34:24.505462Z
type: task
title: 'Unknown assets: alerts against things no source of record claims'
project: 01KX671DATY39VW6GWK3M2T3DN
number: 470
sprint: s7j0986
blocked_by:
- 01KZ0YRK9K11JD5JQGHZYK9J8E
comments:
- id: 01KZ18ZSZT08G5EZK2Q9125V9J
  author: Steve Vine
  at: 2026-08-02T13:00:38.778192Z
  text: |-
    Built and up for review — PR #409 (feature/ise-470-unknown-assets), merged to staging. Stacked on #408 (the pair that ships together); no migration.

    - FindingRead.unknown_asset — derived (entity_key present, entity_id null) so it clears itself the moment the back-fill re-links. Signal detail shows an "Unknown asset" badge beside the unresolved identifier; the alert and its incident exist exactly as before; no placeholder entity is ever minted (pinned by test).
    - GET /entities/unknown-assets: deduplicated by the identifier the source used ("4 unknown hosts, 17 alerts", never 17 orphans) — reporting integrations, total + firing counts, latest title, last seen. Plus observed_only_entities: live entities whose every alias belongs to an observation source (the 263-entity prod case) — the other half of the coverage gap, claimed by integrating their platforms.
    - New /unknown-assets screen (nav under Integrations beside the signal screens that feed it) with the observed-but-unowned banner and a coverage-complete empty state.
    - Back-fill proven end-to-end: unknown alert → AWS integrates the host carrying the DataDog join key → alert re-links with history intact, flag clears, list empties.
    - 4 backend + 2 frontend tests; full suites green (88 files / 489 tests).
assignee: steve
priority: urgent
task_status: done
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