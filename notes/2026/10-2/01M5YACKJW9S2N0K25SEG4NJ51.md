---
id: 01M5YACKJW9S2N0K25SEG4NJ51
created: 2026-10-27T09:17:16.252654Z
updated: 2026-10-28T18:16:47.791337Z
type: task
title: 'ADR amendment: the clouds'' own security tools become sources, matched to systems through what discovery already attached, and Inventory''s findings fold into Vulnerabilities'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1382
sprint: svnkdj7
blocked_by:
- 01M5YA9GHNHTXNSZ3JMFTWECB9
comments:
- id: 01M60QM7HMA7Z8E55R4XDNZ937
  author: Steve Vine
  at: 2026-10-28T07:47:06.420208Z
  text: |-
    Done — PR #1398 merged to main (ADR 0129, COM-1382 amendment; note added to ADR 0099 §10).

    What it decides: §3d the three clouds' tools read per account with discovery on, through the same connection, with a Vulnerabilities feature on each cloud tile; §3e a cloud finding's target is the resource it names — placed through what discovery attached, otherwise Unmatched with "Attach in Inventory"; §3f same-issue rules for clouds, Compass check and cloud control stay two vulnerabilities (equivalents list starts empty); §4d suppressed / exempt / muted = Accepted by the source; §7b Inventory's checks become the source "Compass checks" and existing findings migrate with their state.

    My calls, recorded in the ADR for you to overturn:
    - Each cloud's Vulnerabilities feature starts OFF — switching on brings a cloud's worth of vulnerabilities and owner actions at once, and existing roles lack the permissions until updated.
    - A placed cloud target stays put if its resource is later moved to another asset in Inventory.
    - An asset whose findings of one check were partly accepted moves across as Open, with the accepted ones named in its History.
    - An owner no longer accepts their own Compass-check items (the second-person rule) — they ask for acceptance.

    Follow-up correction (source keys aws/azure/gcp/inventory, the ones sprint 91 reserved) rides in the COM-1383 PR because #1398 merged first.
assignee: steve
label:
- brief
priority: high
task_status: done
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