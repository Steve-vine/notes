---
id: 01M61Y8WNN907MB8H5GYP2ZESY
created: 2026-10-28T19:02:29.301219Z
updated: 2026-10-29T02:12:45.348398Z
type: task
title: 'Posture ▸ Exceptions — every exception for the company in one list: in force, awaiting approval, running out soon and recently lapsed, with an export'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1405
sprint: s81z16q
blocked_by:
- 01M61Y7GH2VVNHPZQ3GDRSPDAD
comments:
- id: 01M62PWK4EDYAW0AH0M14322XQ
  author: Steve Vine
  at: 2026-10-29T02:12:40.718367Z
  text: |-
    Done — PR #1422 merged.

    What's in it:
    - Posture ▸ Exceptions in the menu, after Risks.
    - One row per control excepted: control (ref and name), its real status, the risk, why, compensating controls, owner, approver, approved on, until, next review, and a state pill. The states are In force, Awaiting approval, "Runs out in 12 days" (amber within 30 days) and Lapsed. Lapsed means it ran out or was closed in the last 90 days; after that it drops off.
    - Summary cards (In force · Awaiting approval · Running out in 30 days) and state chips filter the list. Domain, Owner and Approver filters. Sortable headings. Soonest to run out first.
    - Renew (the request form, pre-filled) on rows running out or lapsed.
    - Export CSV of what's shown.
    - "Accepted risks that look like exceptions", collapsed and hidden when empty: risks with an approved acceptance and a gap on a control, but no "Exception to". "Make it an exception to ACC.8" adds the link only; nothing is approved again.
    - Empty state: "No exceptions. A control a company deliberately doesn't meet is recorded with Request an exception on the control."

    My calls:
    - It's its own item in the Posture menu ("a new tab beside Gaps and Risks" — those are separate pages, not tabs).
    - A declined request never stood, so it isn't listed as lapsed.
    - The export is generated in the browser from the rows on screen.
    - Added the page to the IA brief's nav table.
assignee: steve
label:
- feature
priority: medium
task_status: review
---
Sprint 94, Control Exceptions (ADR 0130, COM-1398). Builds on COM-1400 and COM-1402. The "register" from the original feature list — a view over the risks, not a second store.

## What people see

- **Posture ▸ Exceptions**, a new tab beside Gaps and Risks, for the selected company.
- **One row per control excepted**: control (ref and name), its real status, the risk (ref, title), why, compensating controls, owner, approver, approved on, **until**, next review, and a state pill: **In force**, **Awaiting approval**, **Runs out in 12 days** (amber from 30 days), **Lapsed** (in the last 90 days, then it drops off).
- **Filters:** state, domain, owner, approver; sorted by Until, soonest first. Sortable headings (screen conventions).
- **Row actions:** open the risk; **Renew** (COM-1402's form) for in-force and lapsed rows.
- **Header counts:** in force · awaiting · running out in 30 days.
- **Export CSV** of what's shown.
- **Candidates** (one-off tidy-up, ADR 0130 my call): a collapsible "Accepted risks that look like exceptions" — risks with a standing acceptance that are linked to a gap on a control but have no "Exception to" yet — each with **Make it an exception to ACC.8** (adds the link; no re-approval, since the acceptance is already approved). Hidden when empty.
- **Empty state:** "No exceptions. A control a company deliberately doesn't meet is recorded with Request an exception on the control."

## Who can do what

Anyone who can see the company's risks sees the tab. Make-it-an-exception needs risk write.

## Notes (technical)

- `GET /exceptions?company=` built on COM-1400's rule, returning lapsed from the acceptance's expired/closed date.
- Search (global) and breadcrumbs: the tab is a Posture page like Gaps.

**Chain:** on the chain (API).

**Done when:** on staging the tab shows the test exception in each state as it moves (awaiting → in force → runs out), and the CSV matches the screen.