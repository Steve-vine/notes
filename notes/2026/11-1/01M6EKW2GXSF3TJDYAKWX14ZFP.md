---
id: 01M6EKW2GXSF3TJDYAKWX14ZFP
created: 2026-11-02T17:10:51.165172Z
updated: 2026-11-02T19:23:23.732288Z
type: task
title: Raise a vulnerability or a risk from an item — one click turns a confirmed match into a vulnerability on each affected system (or a risk), filled in from the item and linked both ways
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1525
sprint: s6xh9g1
blocked_by:
- 01M6EKSK3GGHY1E8J0FQPE60NV
- 01M6EKTNRP1KYRX8AVXGT4PQ8P
assignee: steve
label:
- feature
priority: high
task_status: active
---
Sprint 102, Security Feed (ADR 0139 §9, COM-1510). Builds on ADR 0129 (Vulnerabilities).

## What people see

On a matched item (Possibly affects us, Versions not stated or Confirmed), a manager has:

- **Raise vulnerability**. It opens a short form listing **each affected system** from the match (ticked by default; untick any that don't apply), plus any other system to add by hand. On **Raise**:
  - one vulnerability per system (ADR 0129 §1: one issue on one system), or a new **sighting** on an existing one if that CVE is already in the register for that system;
  - filled in from the item: title, CVE, kind Software flaw, severity and CVSS (from the highest source, changeable in the form), description and recommendation (the vendor's fix and workarounds), and where (the software entry and version);
  - owner and fix-by date come from the register's own rules (the system's owner; the fix-by rubric);
  - the sighting's source is **Security Feed**.
- **Raise risk**. It opens the risk register's Add form, pre-filled with title, description and the item's link, for issues that are wider than one system (e.g. a widespread zero-day with no fix yet).
- Either one **confirms** the item if it wasn't already (COM-1520), and closes its action (COM-1523).

**Linked both ways:**
- the item's **Related** section lists the vulnerabilities (VUL-12 on AST-14) and risks raised from it, in this company;
- the vulnerability shows **From the Security Feed: CVE-2026-1234**, linking to the item page, and the item's later changes (newly exploited, rescored) show on the vulnerability's history as notes. The vulnerability's severity isn't changed without a person.

## Who can do what

*Manage security feed* **and** the right to record vulnerabilities (or add risks) for the company. If someone has only one of them, the button explains which is missing.

## My calls

- Raising when the vulnerability already exists adds a sighting rather than creating a duplicate, and the form says so ("CVE-2026-1234 is already VUL-31 on AST-14: this adds a sighting").
- When a vulnerability raised from the feed is later fixed or accepted in the register, the item's company status stays Confirmed. The register is where the work is tracked.

## Notes (technical)

- Reuse the Vulnerabilities record and sighting service (`vulnerability_source`: add a "security_feed" source kind). A link table `feed_item_links(company_id, item_id, vulnerability_id | risk_id)`.
- Source text copied into the vulnerability stays marked as from the source (`from_the_source`).
- Notes on item changes are pushed by the matcher (COM-1520) when a linked item changes. Make it idempotent.

**Chain:** on the chain (migration + API).

**Done when:** on staging in E2E Test Company:
- from a PHP match on two systems, Raise vulnerability creates two vulnerabilities, each with its owner, fix-by date and the Security Feed sighting, and each links to the item;
- raising again adds no duplicates;
- Raise risk pre-fills the risk form, and the risk links back to the item.