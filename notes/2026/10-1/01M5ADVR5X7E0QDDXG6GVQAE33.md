---
id: 01M5ADVR5X7E0QDDXG6GVQAE33
created: 2026-10-19T15:53:09.565494Z
updated: 2026-10-19T15:53:18.934718Z
type: task
title: Incidents gains a Settings tab where notification rules are kept — a standard list for every company, which each company can switch off, adjust or add to
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1122
sprint: serbigk
blocked_by:
- 01M5ADHYAJ6XSG95HKZRD2EHRG
assignee: steve
label:
- feature
priority: medium
task_status: todo
---
Sprint 76 follow-up. Requested by Steve smoke-testing staging, 2026-10-19. Steve chose **a shared standard list plus per-company changes**. Blocked by COM-1121, so the rule editor moves once, with COM-1120's conditions and COM-1121's four rules already in it.

## Today

Notification rules live in **Admin ▸ Rubrics ▸ Incident rubric**, one list shared by every company, which only admins can change. A company that is UK-only still gets the HIPAA rules, and the insurer, the Board and the customer contract can't say whose insurer, Board or contract.

## What people see

### Incidents ▸ Settings

A new **Settings** tab on Incidents, after Overview and Register, for the company chosen in the top bar. It holds **Notification rules**, in two parts:

**Standard rules: every company.** The shared list: the eight shipped, plus the four from COM-1121, plus any an admin adds. Here someone with rubric rights can add, edit, reorder, retire or delete a rule, and see its history, as Rubrics allows today. A line makes clear a change here applies to every company.

**This company.** Each standard rule as it applies to this company. A company manager can:
- **Switch it off** for this company, with a reason ("UK-only — no US data subjects"). It then never appears on this company's incidents.
- **Adjust it** for this company:
  - the **recipient** (e.g. "Hiscox, policy CY-12345" for the insurer; "Acme Ltd Board" for the Board);
  - the **deadline** (e.g. the contract's 48 hours in place of the 24-hour placeholder);
  - a **company note** added to "what to include and how" (who to call, the portal to use).

  The rest (categories, conditions, standard wording) follows the standard rule. An adjusted rule shows what differs from the standard, with **Reset to standard**.
- **Add a rule of its own**: a full rule like a standard one, e.g. "Tell the parent company within 24 hours". It belongs to this company only.

Every switch-off, change and addition is kept in the rule's history with who and when, as standard rules are today.

### On incidents

- An incident's Notifications list uses the company's version of each rule: its recipient, its deadline, and its note under the standard wording.
- Switching a rule off drops it from that company's open incidents where it hasn't been decided yet. Rows already sent or decided are kept as they are.
- An adjusted deadline applies to undecided rows on open incidents, as editing a standard rule does today.

### Admin ▸ Rubrics

The Incident rubric card keeps **categories** and **severity**. Its notification rules block is replaced by one line: "Notification rules have moved to Incidents ▸ Settings."

## Who can do what

- **See Settings**: anyone who can see incidents. Seeing which rules are on matters to handlers.
- **Change this company's rules**: a new permission, *manage incident settings*. It goes to the built-in Admin role only, like the other incident permissions; tick it into other roles in Admin ▸ Roles.
- **Change the standard rules**: needs the rubric permission (as today), since they affect every company.

## My calls (Steve to confirm)

- A company can change the recipient, the deadline and add a note, but **not the categories or conditions** of a standard rule. Those carry the legal tests; to do it differently, switch the standard off and add a company rule.
- The Settings tab starts with notification rules only. It's the place later incident settings go, e.g. who counts as a handler for this company (see the COM-1063 calls).

## Notes (technical)

- New tables: per-company overrides `(company_id, obligation_id, disabled + reason, recipient_name, deadline_kind/amount/month/day, company_note)` with revisions, and company-owned obligations (a `company_id` nullable on `incident_notification_obligations`: null = standard). Migration append-only; create new enums explicitly.
- `core/incident_notifications.py`: resolve the effective rule per company (standard + override, or company rule) wherever rules are read: sync, deadlines, Actions, warning beat, exports, closure check, Overview on-time rate.
- Move `admin/IncidentObligationsSection.tsx` to `incidents/settings/…`; `IncidentsPage` tab list gains `settings` (`useTabParam`). Permission catalogue and `brief/permission-catalogue.md`; the starter-role bundle test stays unchanged.
- Assistant: read the company's rules; switch off / adjust / reset / add as the person, gated the same. Run every `test_assistant*.py`.
- ADR 0116 §7 amendment: standard rules plus per-company variations.

**Done when:** on staging, Incidents ▸ Settings for Test Company lists the standard rules. Switching off "HIPAA — tell the individuals" with a reason removes it from Test Company's new Privacy incidents, but not from another company's. Setting the Insurer's recipient and a 48-hour deadline shows both on Test Company's next P1.