---
id: 01M54K9M964BMNH39JC81VADMX
created: 2026-10-17T09:32:40.614603Z
updated: 2026-10-18T07:50:10.065713Z
type: task
title: 'An SAP entry''s owner is told when it''s coming up and when it''s overdue — in their Actions and the actions email — and works it from the User Portal: comment, add evidence, mark done'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1054
sprint: sxflvhs
blocked_by:
- 01M54K4NQ1YFFFXKNEDBQ3KS9X
- 01M54K3VR775461M4C6Y5VHMC0
comments:
- id: 01M55DZ6T132YXF60B5MW83JB4
  author: Steve Vine
  at: 2026-10-17T17:18:50.689317Z
  text: |-
    Done: merged in PR #1053.

    - An entry's owner sees it in their Actions from 14 days before its end date (or from its start, if that's sooner) and while it's overdue, until it's done or cancelled. Changing the owner moves the action to the new owner. The actions email carries these like every other action; there's no separate SAP email.
    - People who manage the plan get one action per company, "3 plan entries are overdue", which opens the Schedule filtered to overdue. Their queue doesn't list other people's entries one by one.
    - The User Portal has a Plan page, "My plan entries", showing the entries a person owns across every company. On an entry's page the owner can read it (including its controls), comment, add evidence and mark it done. They can't edit it, cancel it, delete it or change its links. The owner doesn't need any SAP permission, and anyone who isn't the owner sees nothing.
    - An action that links to an entry opens the owner's portal page when they work from the portal.
    - My call: the Plan item in the portal menu shows for everyone, as Inventory's does, with "You own no plan entries" for people who own none. Your brief said to show it only to owners; tell me if you want that instead.
assignee: steve
label:
- feature
priority: high
task_status: done
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