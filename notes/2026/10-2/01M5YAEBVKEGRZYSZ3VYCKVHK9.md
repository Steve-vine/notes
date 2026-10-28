---
id: 01M5YAEBVKEGRZYSZ3VYCKVHK9
created: 2026-10-27T09:18:13.875669Z
updated: 2026-10-28T10:37:19.468794Z
type: task
title: Inventory's findings move into Vulnerabilities — every open, accepted and risk-raised finding comes across with its history, and Inventory's Findings tab and card give way to the asset's Vulnerabilities card
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1386
sprint: svnkdj7
blocked_by:
- 01M5YACKJW9S2N0K25SEG4NJ51
- 01M5YA8JFC9Q3C8QJV0SC6J8GZ
comments:
- id: 01M611BW8THR9QM94RSB10J81E
  author: Steve Vine
  at: 2026-10-28T10:37:18.489925Z
  text: |-
    Done — PR #1404 merged to main (460c86bd, migration 0722). Not yet on staging (sprint deploy at the end).

    What you'll see
    - Compass's own checks keep running on every discovery read and now land in Vulnerabilities as the source "Compass checks", on the asset's system. Fixed in the cloud → "Fixed — confirmed by Compass checks"; comes back → the same VUL reopens.
    - The same check on two resources of one asset is now ONE vulnerability listing both (Inventory showed two findings).
    - On upgrade every existing finding moves across: open → Open; all of an asset's open ones of a check accepted → Accepted with who, when, why and the decision, reviewed a year from the move; risk raised → Open, linked to the risk; nothing open → Fixed. Each one's History says what happened ("Moved from Inventory's findings on …", "Accepted in Inventory by … on …").
    - Gone: Inventory ▸ Findings (an old link opens Vulnerabilities filtered to Compass checks), the Findings card on the asset page and in the portal (their Vulnerabilities cards stay), the Findings filter and "N findings" chip on the Technology list, the Dashboard Inventory tile's "with findings to answer" line, and the "Asset findings" action (owners get vulnerability actions instead).
    - Polaris: the three finding tools stay for one release and say where findings went.

    Release note: accepting now needs Accept vulnerabilities, and the second-person rule applies — an owner asks for acceptance rather than accepting their own. The upgrade grants nothing; built-in Admin has it.

    Migration checked against a database that already holds findings (open, two on one asset, accepted, closed, asset-level), including undo and redo — that test now runs in CI. Not run against a copy of staging's real data.

    My calls
    - Severities (findings had none): High — reachable from the internet, public access not blocked, readable by anyone, control endpoint public, out-of-support OS/software; Low — not seen, account disabled, all resources gone, outlives a decommissioned asset; Medium — the rest (not encrypted, no backups, etc.). Kind: Misconfiguration for all, as the task said.
    - An asset whose open findings of one check were only partly accepted moves across as Open; its History says how many were accepted.
    - No per-finding redirect: findings never had their own page, so only the old tab link needed one. The finding→vulnerability map is kept in the database.
assignee: steve
label:
- feature
priority: high
task_status: review
---
Sprint 93, Vulnerabilities - Cloud sources (ADR amendment in COM-1382). Steve, 2026-10-27: fold Inventory's Findings into Vulnerabilities.

## What people see

- **Compass's own checks become a source, "Compass checks".** Examples: public bucket, not encrypted, internet-reachable, no backups, readable by anyone. They keep running on every discovery read, as today, and now land in the Vulnerabilities register as Misconfigurations on the asset's system.
- **On upgrade, every existing finding moves across:**
  - **Open** → Open, keeping its sentence as the title, its opened date as first seen, and the asset as the system;
  - **Accepted** → Accepted, with who, when, the reason and the decision record. Review date one year from the upgrade, because findings had none. The History says so;
  - **Risk raised** → Open, linked to its risk;
  - **Closed** → Fixed, so the trend shows the history.
- **Owners** come from the asset's owner, as for every vulnerability. Their existing "finding" actions become the vulnerability actions.
- **Gone:**
  - Inventory ▸ Findings tab;
  - the asset page's Findings card, replaced by its Vulnerabilities card;
  - the portal's finding view, replaced by its vulnerability view.
  - Old links to a finding open its vulnerability.
- **Polaris:** `inventory_list_findings`, `inventory_accept_finding` and `inventory_raise_risk_from_finding` are retired. Their descriptions point to the vulnerability tools for one release, then go.

## Who can do what

- Today, accepting a finding needs Inventory rights. After the move it needs accept vulnerabilities.
- The upgrade grants nothing. Built-in Admin holds both, and the release note says other roles may need the new permission.

## Notes (technical)

- A data migration from `resource_findings` to vulnerabilities and sightings, keeping IDs in a mapping for redirects.
- **Migrations are only tested on a fresh database in CI.** Reproduce this one locally against a populated copy before deploying (the fresh-DB blind spot).
- `core/discovery/findings.py` writes sightings instead of findings. `resource_findings` stays read-only for one release, then is dropped.

**Chain:** on the chain (migration + API).

**Done when:**
- staging's existing findings appear as vulnerabilities with their states and histories;
- new check results land as sightings;
- nothing points at the old Findings tab.