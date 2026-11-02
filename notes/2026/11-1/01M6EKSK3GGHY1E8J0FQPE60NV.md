---
id: 01M6EKSK3GGHY1E8J0FQPE60NV
created: 2026-11-02T17:09:29.840125Z
updated: 2026-11-02T18:54:47.856868Z
type: task
title: '"Possibly affects us" — every new or changed item is checked against the company''s watch lists and Inventory; a match names the systems and our version against the affected and fixed versions, and a manager confirms it or marks it not relevant'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1520
sprint: s6xh9g1
blocked_by:
- 01M6EKRMXRTPRW3FGW0N9HRCWE
assignee: steve
label:
- feature
priority: high
task_status: active
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