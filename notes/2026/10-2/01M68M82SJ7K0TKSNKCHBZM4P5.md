---
id: 01M68M82SJ7K0TKSNKCHBZM4P5
created: 2026-10-31T09:21:58.066356Z
updated: 2026-10-31T09:23:17.460461Z
type: task
title: Access, Vendors, Inventory and Trust Centre actions follow the one-action-per-thing rule — and waiting module work (Discovered items, software suggestions) becomes an action
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1480
sprint: scpaa6p
blocked_by:
- 01M68M4TR5X3N0A30R9F8XGY5V
- 01M68M56FJGX3ZRTFG9SNDVXQX
assignee: steve
label:
- improvement
priority: medium
task_status: todo
---
Sprint 100, Actions (ADR 0137 rule 2). This is the module review Steve asked for on 2026-10-31. It works from COM-1468's per-type table.

## What changes

**Access**
- A request has one row at its step: **Approve** (COM-1472), then **Validate** (expedited), then **Run** (a scheduled change whose time passed), then **Do the on-premises step**. A leaver whose account is still standing shows **Stop or allow deletion** until the delete.
- An unrequested directory change: **Adopt or reverse**.
- A recertification: one row per reviewer per campaign (**Recertification · Review**, "14 to review"), not one per item. Check whether today's rows are per item.
- Business role clean-ups (group gone, rule-based group, role removal): one row per role, **Fix the role**.

**Vendors**
- A vendor has one row at its step: **Approve** (request) → **Answer the approver's question** → **Assign the required questionnaire** → **Review** (due, or tier rose; see COM-1478).
- Review follow-ups keep their own rows (**Follow-up · Complete**). Each follow-up is its own thing.
- An expiring certification: **Certification · Renew**.

**Inventory**
- Accounts, subscriptions or projects left undecided: one row per connection, **Decide which to read**.
- A broken discovery rule: **Fix the rule**.
- Access to remove after recertification: **Remove access**.
- **New: waiting module work**
  - Items on the Discovered tab: one row per company, **Discovered · Sort** "14 items to sort", default owner, due N days after the oldest arrived.
  - Software suggestions: one row per company, **Software · Match** "6 suggestions".
  - Today these only show if someone opens the tab.

**Trust Centre**
- Each request: **Approve or decline**.
- An expiring document: **Document · Renew**.
- "Nobody receives questionnaires": **Choose who receives questionnaires**.

All owners come from COM-1471, and unowned work goes to the default owner.

**Chain:** on the chain. Blocked by COM-1470 and COM-1471.

**Done when:** on staging, for each module, the pre-UAT pass finds no thing with two rows for steps that follow each other, and E2E Test Company's Discovered items show as one Sort row.