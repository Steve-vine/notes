---
id: 01M6EKW2GXSF3TJDYAKWX14ZFP
created: 2026-11-02T17:10:51.165172Z
updated: 2026-11-04T07:45:33.916045Z
type: task
title: Raise a vulnerability or a risk from an item — one click turns a confirmed match into a vulnerability on each affected system (or a risk), filled in from the item and linked both ways
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1525
sprint: s6xh9g1
blocked_by:
- 01M6EKSK3GGHY1E8J0FQPE60NV
- 01M6EKTNRP1KYRX8AVXGT4PQ8P
comments:
- id: 01M6F3WW9KVFXDP9H2M80Y362P
  author: Steve Vine
  at: 2026-11-02T21:50:54.770908Z
  text: |-
    Done. Merged to main (PR #1540). It isn't on staging yet: the whole sprint goes there together once every task is in Review.

    What people see on a matched item (managers who can also work vulnerabilities or manage risks):
    - **Raise vulnerability** opens a form listing the systems the match names, all ticked, with the severity changeable. Raising creates one vulnerability per system, filled in from the item:
      - the title, the CVE, and the kind "Software flaw";
      - the severity, score and description;
      - the vendor's fixes and workarounds as the recommendation;
      - the software as where it is;
      - the owner from the system (or the register's default) and the fix-by date from the register's targets;
      - "Security Feed" as its source.
    - If the register already has the issue on a system, the form says "already VUL-x". Raising adds a sighting to it instead of creating a second one. Raising again creates nothing new.
    - **Raise risk** is a short form: the title filled in from the item, what could happen, likelihood and impact. The risk is linked to the systems the match names.
    - Either way the item is **confirmed** for the company, which closes its action in My actions (COM-1523). **Raised from this item** on the item page lists what was made.
    - Later changes to the item (newly exploited, rescored) are noted on each vulnerability raised from it, by Compass. Its severity is never changed without a person.

    Built differently from the task:
    - Raise risk is its own short form, not the risk register's Add form filled in. The risk's notes name the item as plain text, without a link back to it.
    - On the vulnerability, the link to the item is in its sightings ("Security Feed"). The Compass comment just names the item.

    Not built:
    - Adding a system the match didn't name: only the match's systems are offered.
    - A link from the risk back to the item.

    Say if you want either of those as a task. Raise is now hidden on items marked not relevant, and the page says which right a missing Raise needs (COM-1531).
- id: 01M6F48NVJPWKPVFYT6MCNFKH0
  author: Steve Vine
  at: 2026-11-02T21:57:21.394287Z
  text: 'Update: the risk now links back to the item. Its page says "From the Security Feed: CVE-… · title" with a link. That''s in COM-1531, so "the risk links back to the item" in Done when will hold. The one thing still not built is adding a system the match didn''t name.'
- id: 01M6GA074X65JHGEB0A1YS42GS
  author: Steve Vine
  at: 2026-11-03T08:56:50.077244Z
  text: |-
    Pre-UAT (staging, 2026-11-03, E2E Test Company): **Passed**, one usability note.

    As E2E Admin A:
    - **Raise vulnerability** on CVE-2026-54118 (SQL Server, critical) listed "AST-33 E2E pre-UAT 102 dc-1 (Microsoft SQL Server 2016 Standard · 13.0 (SFT-18))" with severity, and said the owner and fix-by come from the register's rules. Raise made **VUL-1** (open). The item turned Confirmed and lists "Raised from this item: VUL-1 on AST-33 … dc-1". Its action closed.
    - **Raise risk** on CVE-2025-68686 (FortiOS, known exploited) opened the short form with the title filled in, likelihood 3 and impact 4. Raising made **R-32** and confirmed the item. R-32's page says "From the Security Feed: CVE-2025-68686 · …" and links back.

    Note: the risk form's "What could happen" starts empty. The item is named in the risk's notes, but you have to type the description yourself. Pre-filling it from the item's summary would save that. Say if you want it.

    Screenshots: ~/compass-uat/sprint-102/COM-1525/, ~/compass-uat/sprint-102/COM-1531/03-risk-links-back.png
assignee: steve
label:
- feature
priority: high
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