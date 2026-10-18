---
id: 01M57VSQSH1S16GRE5WP9ECNW4
created: 2026-10-18T15:59:00.401411Z
updated: 2026-10-18T15:59:02.886414Z
type: task
title: Attestations appears in the Modules menu and opens on Open — every role's content that's running now, how many have signed, the % complete, days left, and who's overdue or can't be reached
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1099
sprint: s7s7mn9
assignee: steve
label:
- feature
priority: high
task_status: todo
---
Sprint 78, Attestations (ADR in COM-1092; Steve's decision: its own section). Builds on the portal section (COM-1095), because signatures are what fill the percentages, and on the new-version rounds (COM-1098).

## What people see

**Attestations** in the Modules section of the menu, for anyone with `attestations.view`, per company (company switcher as usual). It opens on the **Open** tab:

- Headline tiles: **Running now** (rounds open), **Signed** (overall % across open rounds), **Overdue** (people), and **Can't be reached** (people).
- A table of **open rounds**, one row per role and content: **Role**, **Content**, **Opened**, **Deadline**, **Days left** ("6 days left", "Ended 3 days ago"), **Signed** ("31 of 40"), **% complete** (a bar), **Overdue**. Rows ending soonest come first. A round opened by a new version is labelled so.
- **Clicking a row** opens the round: everyone in it with **Signed** (date, "late" where it was), **Outstanding** (due date) or **Overdue** (by how long). Where it applies, it also shows **No email address** or **Can't sign in** (no Entra account).
- **Assigned** sits below the table: every role's content that isn't running right now, with its **Next opens**. That covers "what is assigned by role", including what's scheduled or stopped.
- Filters: role, content, and "only with overdue". They're kept in the address (URL-backed list filters).

A round stays on Open until its deadline has passed and everyone has signed, or until 30 days after its deadline, whichever comes first. After that its final numbers live on in Compliance (COM-1100).

## Rules

- Counts follow COM-1094's rules: leavers drop out, new starters count from when they joined, and someone signed via another role counts as signed.
- Clicking a role or content goes to its own page. Clicking a person goes to their compliance history (COM-1100).

## Notes (technical)

- Read-only. New router under `/api/v1/attestations/…` gated on `attestations.view`.
- Add it to the sidebar's Modules group and the IA (`brief/information-architecture.md`). It needs a page header and tab titles per the screen conventions, `SortableTh` throughout, and breadcrumbs.

**Done when:** an admin sees what's running per role and content, with % complete and time left, and can drill into any round to see who's done, who's late and who can't be reached.