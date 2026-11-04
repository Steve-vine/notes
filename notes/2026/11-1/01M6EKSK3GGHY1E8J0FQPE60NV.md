---
id: 01M6EKSK3GGHY1E8J0FQPE60NV
created: 2026-11-02T17:09:29.840125Z
updated: 2026-11-04T07:45:33.870231Z
type: task
title: '"Possibly affects us" — every new or changed item is checked against the company''s watch lists and Inventory; a match names the systems and our version against the affected and fixed versions, and a manager confirms it or marks it not relevant'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1520
sprint: s6xh9g1
blocked_by:
- 01M6EKRMXRTPRW3FGW0N9HRCWE
comments:
- id: 01M6F0RJGHFD4D92VRX4P8J4E0
  author: Steve Vine
  at: 2026-11-02T20:56:07.953671Z
  text: |-
    Done. Merged to main (PR #1537). It isn't on staging yet: the whole sprint goes there together once every task is in Review.

    What happens now:
    - Each new or changed item is checked against every company's watch lists. When a watch list or a product link is edited, the last 12 months are checked again.
    - A match is **Possibly affects us**, or **Versions not stated** when the item names the product but gives no versions.
    - On the item page, **Does it affect us?** shows:
      - which list and rule it matched;
      - the affected and fixed versions against ours;
      - the systems it's on;
      - "From Polaris's reading" when the products came from Polaris.
    - A manager **confirms** it, or marks it **not relevant** with a reason: not exposed, already patched, feature not used, not our product, or other (which needs a note). Either can be reopened.
    - An item marked not relevant **comes back** as "Changed since marked not relevant", saying why, if it later becomes known exploited, rises to Critical, or its affected versions come to include ours. Checking again never overrides a person's decision in any other way.
    - Every decision is in the activity log and in the item's history.

    Built differently from the task:
    - Systems are named only through the Products tab. A system appears when its software has a confirmed product link. For the UAT check, E2E Test Company's PHP software needs confirming on Products first.
    - On a product rule, "ours" is the version written in the watch list. The "Everything we run" rule uses each piece of software's Inventory version.
    - Where a match came from is named only when it was Polaris's reading. For structured data it doesn't say which source (NVD, the vendor and so on).
    - A confirmed item can be reopened too, not only a not-relevant one.
- id: 01M6G9ZFSYFC8QP8390B0TWQHG
  author: Steve Vine
  at: 2026-11-03T08:56:26.174614Z
  text: |-
    Pre-UAT (staging, 2026-11-03, E2E Test Company): **Passed**. **Couldn't check** "comes back on its own" on live data.

    - **Possibly affects us:** CVE-2025-14180 (PHP). "Why this matched" shows the list and rule, "Our version is affected", "PHP · 8.2.20 (SFT-15): ours is 8.2.20", "Affected: 8.1.0 to before 8.1.34; 8.2.0 to before 8.2.30; …", "Fixed in … 8.2.30 …" and "Systems: AST-32 E2E pre-UAT 102 web-1".
    - **Versions not stated:** CVE-2025-68686 (FortiOS, CISA known exploited), with "Versions not stated" said plainly.
    - **Release line:** SQL Server 2016 at "13.0" says "Some releases of our version line are affected: check which we run".
    - **Not relevant** offers Not exposed, Already patched, Feature not used, Not our product and Other, and explains when the item comes back. The status changed to Not relevant, and **Reopen** put it back to Possibly affects us. History shows each step with "E2E Admin A".
    - **Confirm** on CVE-2026-54118 changed it to Confirmed.

    For you to check: "Changed since marked not relevant" needs a source to revise an item we've dismissed. Nothing did during the pass. The tests cover it.

    Screenshots: ~/compass-uat/sprint-102/COM-1520/, ~/compass-uat/sprint-102/COM-1522/
assignee: steve
label:
- feature
priority: high
---
Sprint 102, Security Feed (ADR 0139 §8, COM-1510).

## What people see

When an item arrives or changes, or a watch list or product link is edited, Compass checks it against each company's watch lists (COM-1519). A matching item gets a **company status**:
- **Possibly affects us** (new match);
- **Versions not stated** (the product matched, but the item gives no versions);
- **Confirmed** (a person agreed);
- **Not relevant** (a person said why).

On a matched item, a **"Why this matched"** panel shows:
- the watch list and the rule that matched;
- **for each system**, from Inventory: the system (AST-14), the software entry, **our version**, the **affected range** and the **fixed version** ("Our 8.2.20 is affected (8.2.0 to before 8.2.27). Fixed in 8.2.27.");
- where the match came from: structured data (and whose), or Polaris's reading (COM-1517);
- **can't compare** or **versions not stated**, said plainly, never hidden.

A manager can:
- **Confirm**: "yes, this affects us". Then raise a vulnerability or risk (COM-1525).
- **Not relevant**, with a reason: "Not exposed", "Already patched", "Feature not used", "Not our product", or Other plus text. It applies to the company, not just the person.
- **Reopen** a not-relevant item.

**Comes back on its own:** an item marked not relevant returns as **Changed since marked not relevant** if it later becomes known-exploited, its severity rises to Critical, or its affected versions change to include ours. The reason it was dismissed is shown alongside.

Every status change is in the activity log and in the item's history.

## Notes (technical)

- `company_feed_matches(company_id, item_id, status, matched_lists[], reasons JSONB, systems JSONB, dismissed_reason, decided_by, decided_at, reopened_reason)`, unique on (company, item).
- Matching runs as Celery tasks, each with a label:
  - on item upsert, enqueue a match for the item across companies with lists;
  - on list or link edit, rematch that company over the window (12 months), batched.
- Re-matching is safe to repeat and never undoes a person's decision, except through the comes-back rules above, which record why.
- The "affects us" filter and company status columns land in the feed screen (COM-1521) when this merges.

**Chain:** on the chain (migration + API).

**Done when:** on staging in E2E Test Company, with a list for PHP 8.2.20 and Windows Server 2019:
- a PHP CVE affecting 8.2 before 8.2.27 shows Possibly affects us, naming the system and the versions;
- marking it Not relevant ("Already patched") holds;
- an item with no versions shows Versions not stated;
- the activity log records each decision.