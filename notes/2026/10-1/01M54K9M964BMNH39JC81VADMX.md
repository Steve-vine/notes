---
id: 01M54K9M964BMNH39JC81VADMX
created: 2026-10-17T09:32:40.614603Z
updated: 2026-10-17T09:37:11.749754Z
type: task
title: 'An SAP entry''s owner is told when it''s coming up and when it''s overdue — in their Actions and the actions email — and works it from the User Portal: comment, add evidence, mark done'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1054
sprint: sxflvhs
blocked_by:
- 01M54K4NQ1YFFFXKNEDBQ3KS9X
- 01M54K3VR775461M4C6Y5VHMC0
assignee: steve
label:
- feature
priority: high
task_status: todo
---
Sprint 75, SAP - Schedule (ADR in COM-1041; suggestion 4). Built on COM-1045.

## What people see

- **In the owner's Actions:**
  - "**Due soon:** Annual penetration test, due 14 March". This appears from 14 days before the end date, or from the start date if that's sooner;
  - "**Overdue:** Q3 access review, 20 days overdue", until it's done or cancelled.
  Each opens the entry.
- **The actions email** carries them the same way as every other action. It's derived from the queue, so there's no separate SAP email (ADR 0055).
- **People with `sap.manage_plan`** see a company-level action, "3 plan entries are overdue", which opens the Schedule filtered to overdue.
- **In the User Portal**, under Modules, a **Plan** page (shown only to someone who owns at least one entry) lists **My plan entries**: the entries they own, in any company they can see. Opening one shows:
  - the title, description, type, dates, status and linked controls (read-only);
  - **Comments** (COM-1043) and **Evidence** upload (COM-1044);
  - **Mark done** with outcome and evidence (COM-1045).
  The owner can't change dates, owner or links, can't cancel, and can't delete.

## Rules

- Ownership-scoped, not role-gated, like asset ownership in the portal (ADR 0072 §10). An owner reaches their own entries without `sap.view`, and the API shows a non-owner nothing.
- Changing an entry's owner moves its actions to the new owner.

## Notes (technical)

- Declare action sources in `core/actions/` (a new `sap.py`, added to `ACTION_SOURCES`): due-soon and overdue per owner, plus the overdue roll-up for managers. Don't write a notifier (memory: actions queue and derived mail).
- Portal routes under `/api/v1/portal/...` must be added to the exact-set write-routes test in `tests/test_portal.py` (memory: portal write-routes allowlist; that test is integration-only and CI-only red).
- Portal nav entry in `components/portalNav.ts`, `section: 'Modules'`, `gate: null`, with the reasoning comment the Inventory entry has.

**Done when:** owners get due-soon and overdue actions (and the email), managers get the overdue roll-up, and an owner without SAP permissions can comment on, add evidence to and complete their own entries from the portal, and nothing more.