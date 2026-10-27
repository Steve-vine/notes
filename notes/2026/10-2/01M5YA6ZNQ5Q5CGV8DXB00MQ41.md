---
id: 01M5YA6ZNQ5Q5CGV8DXB00MQ41
created: 2026-10-27T09:14:12.023429Z
updated: 2026-10-27T09:18:53.271985Z
type: task
title: What happens to a vulnerability — marked fixed, accepted with a reason until a review date, called a false positive, turned into a risk, logged in error, or reopened when it comes back
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1367
sprint: s6wypy5
assignee: steve
label:
- feature
priority: high
task_status: todo
---
Sprint 91, Vulnerabilities - Register (ADR in COM-1362). Builds on COM-1366.

## What people see

The Fix card offers what the state allows.

- **Open:**
  - **Mark fixed**: with a note on what was done, and optional evidence. Offered for hand-recorded and pen-test vulnerabilities. A scanner or cloud source closes its own when it stops seeing them (sprints 92–93). A person can still mark one fixed early, and it shows "Fixed — waiting for <source> to confirm" until the source agrees or sees it again.
  - **Accept**:
    - a reason;
    - a review date (required, at most a year away);
    - optionally a decision record, new or existing.
    - Needs the accept permission. Accepted vulnerabilities are left out of overdue counts.
  - **False positive**: a reason.
  - **Raise a risk**: opens the usual new-risk window, pre-filled with the title, system and severity. The vulnerability links to the risk and stays open. Linking to an existing risk is also offered.
  - **Logged in error**: hand-recorded only, with a reason. It leaves the register and the figures, and stays readable in History and through a "Show logged in error" filter.
- **Accepted / False positive / Fixed:** **Reopen**, with a reason.
- **Automatic changes:**
  - an accepted vulnerability whose review date passes reopens and goes back to its owner;
  - a fixed one seen again by a source reopens as the same VUL, and History says "seen again by Nessus on …";
  - both are recorded as made by Compass.

## Who can do what

- Work vulnerabilities: everything except Accept.
- Accept vulnerabilities: Accept.
- **Nobody accepts a vulnerability they recorded or own.** This is the second-person rule Compass applies to approvals everywhere, with no exception. Items from a scanner or cloud have no recorder, so only the owner rule applies to them.

## Notes (technical)

- State transitions in one service function with a tested transition table.
- A Beat job reopens accepted items past their review date.
- Reuse the risk-link and decision-link patterns from Inventory findings (`resource_findings.risk_id` / `decision_id`).

**Chain:** on the chain (migration + API).

**Done when:**
- every transition works with its rules;
- review dates reopen;
- a risk raised from a vulnerability shows on both records;
- History tells the whole story.