---
id: 01M5YACKJW9S2N0K25SEG4NJ51
created: 2026-10-27T09:17:16.252654Z
updated: 2026-10-28T07:43:40.091376Z
type: task
title: 'ADR amendment: the clouds'' own security tools become sources, matched to systems through what discovery already attached, and Inventory''s findings fold into Vulnerabilities'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1382
sprint: svnkdj7
blocked_by:
- 01M5YA9GHNHTXNSZ3JMFTWECB9
assignee: steve
label:
- brief
priority: high
task_status: active
---
Sprint 93, Vulnerabilities - Cloud sources. Amends the Vulnerabilities ADR (COM-1362) and the sources amendment (COM-1374). Also amends ADR 0099 §3/§10: findings move out of Inventory.

Steve, 2026-10-27:
- "CSPM-style" means reading the clouds' own tools, not growing Compass's own checks;
- Inventory's Findings fold into Vulnerabilities.

## What the amendment decides

- **Sources:**
  - **AWS Security Hub** (its controls and the findings it gathers), and **Amazon Inspector** for software flaws in instances, images and functions;
  - **Microsoft Defender for Cloud**: recommendations, plus vulnerability assessments of machines, containers and SQL;
  - **Google Security Command Center**: findings at organisation or project level.
- **Read per cloud account that has discovery on**, using the same connection and identity. The account's Vulnerabilities feature is on the cloud's tile. **Nothing new to sign up for in Compass.** The cloud tool must be switched on in the account, and the tile says when it isn't.
- **Matching:**
  - a cloud finding names a resource. If discovery has attached that resource to a technology asset, the finding lands on that system with no rules;
  - a resource still on Inventory's Discovered tab goes to Unmatched, with "attach this resource in Inventory" offered.
- **Inventory's checks become the source "Compass checks"**, e.g. public bucket, not encrypted, no backups, internet-reachable:
  - existing open, accepted and risk-raised findings move across with their state, dates, reasons, decisions and risks;
  - the Inventory ▸ Findings tab and the asset's Findings card go, replaced by the asset's Vulnerabilities card;
  - closed findings move across as Fixed history.
- **Overlap:** a Compass check and a cloud control can describe the same thing, e.g. a public S3 bucket. They're different checks, so they're two vulnerabilities, each with its own source. A short fixed list of known equivalents can merge them. Start with none, and add from real data.
- **Severity** from the cloud tool. Security Hub's Informational controls that pass aren't findings.

## Notes (technical)

- Record the read permissions each template gains (`docs/aws`, `docs/azure`, `docs/gcp`) and that existing customers must update their role or policy. The tile says which permission is missing.

**Chain:** independent (documents only).

**Done when:** the amendment is merged.