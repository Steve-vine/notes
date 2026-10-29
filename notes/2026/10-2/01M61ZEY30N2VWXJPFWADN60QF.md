---
id: 01M61ZEY30N2VWXJPFWADN60QF
created: 2026-10-28T19:23:15.936344Z
updated: 2026-10-29T03:27:33.309063Z
type: task
title: A runbook says which systems it recovers — linked per company from either side, so a system shows its recovery runbook and a needed system without one is flagged
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1410
sprint: stqs5r1
blocked_by:
- 01M61ZEMEQ4KVPYD4DJ5YE033C
assignee: steve
label:
- feature
priority: high
task_status: active
---
Sprint 95, Business Continuity (ADR 0131, COM-1407). Independent of the BIA tasks except for the "no runbook" flag, which reads COM-1409's targets.

## What people see

- **A runbook** (Playbook content of type Runbook) gains a **Recovers** card for the company in the top bar: the systems it recovers, add / remove from the company's technology assets. Other companies' links aren't shown.
- **Inventory ▸ a system** gains **Recovery runbooks** (in the Continuity card from COM-1409 when there is one, its own card otherwise): each runbook, its version and last review; **Link a runbook** from here too.
- A system the business needs back (COM-1409) with no recovery runbook is flagged **No recovery runbook**.
- **Activity:** "linked runbook DR-03 to system CRM" / "unlinked …".
- A runbook that's retired or deleted drops off the system with a line in Activity; a decommissioned system drops off the runbook.

## Who can do what

Linking needs Inventory write on the system's company (it's a fact about the system). Anyone who can see the runbook sees its Recovers card for companies they can see.

## Notes (technical)

- `content_item` × `container` link, company-scoped through the container, audited. Only content whose type is Runbook (by the content type's key, not its display name — an organisation may rename it).
- Content API: `GET /content/{slug}/recovers?company=`; Inventory: list/add/remove on the asset.

**Chain:** on the chain (migration + API).

**Done when:** on staging a runbook is linked to a system from each side and both pages show it; a needed system without one is flagged.